#!/bin/bash
#  ----------------------------------------------------------------
# Copyright 2016 Cisco Systems
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ------------------------------------------------------------------
#
# Script for running ydk CI on docker via travis-ci.org
#
# ------------------------------------------------------------------

function print_msg {
    echo -e "${MSG_COLOR}*** $(date) *** dependencies_centos_basic.sh | $@ ${NOCOLOR}"
}

function check_install_gcc {
  which gcc
  local status=$?
  if [[ $status == 0 ]]
  then
    gcc_version=$(echo $(gcc --version) | awk '{ print $3 }')
    print_msg "Current gcc/g++ version is $gcc_version"
  else
    print_msg "The gcc/g++ not installed"
    gcc_version="4.0.0"
  fi
  if [[ $gcc_version < "4.8.1" ]]
  then
    print_msg "Upgrading gcc/g++ to version 5"
    yum install centos-release-scl -y > /dev/null
    yum install devtoolset-4-gcc* -y > /dev/null
    local status2=$?
    if [[ $status2 != 0 ]]; then
      MSG_COLOR=$RED
      print_msg "Failed to install gcc; exiting"
      exit 1
    else
      ln -sf /opt/rh/devtoolset-4/root/usr/bin/gcc /usr/bin/cc
      ln -sf /opt/rh/devtoolset-4/root/usr/bin/g++ /usr/bin/c++

      ln -sf /opt/rh/devtoolset-4/root/usr/bin/gcc /usr/bin/gcc
      ln -sf /opt/rh/devtoolset-4/root/usr/bin/g++ /usr/bin/g++

      ln -sf /opt/rh/devtoolset-4/root/usr/bin/gcov /usr/bin/gcov
      gcc_version=$(echo $(gcc --version) | awk '{ print $3 }')
      print_msg "Installed gcc/g++ version is $gcc_version"
    fi
  fi
}

function install_dependencies {
    print_msg "Installing dependencies"

    yum update -y > /dev/null
    yum install epel-release -y > /dev/null
    yum install https://centos7.iuscommunity.org/ius-release.rpm -y > /dev/null
    yum install git which libxml2-devel libxslt-devel libssh-devel libtool gcc-c++ pcre-devel -y > /dev/null
    yum install cmake3 wget curl-devel unzip make java sudo -y > /dev/null
#    yum install python-devel python-pip python3-devel python3-pip -y
    yum install python3-devel -y
    yum install rpm-build redhat-lsb lcov -y > /dev/null
    yum install valgrind -y
  print_msg "Python3.6 location: $(which python3.6)"
  print_msg "Pip3.6 location: $(which pip3.6)"
}
    
function check_install_go {
  which go
  local status=$?
  if [[ $status == 0 ]]
  then
    go_version=$(echo `go version` | awk '{ print $3 }' | cut -d 'o' -f 2)
    print_msg "Current Go version is $go_version"
    minor=$(echo $go_version | cut -d '.' -f 2)
  else
    print_msg "The Go is not installed"
    minor=0
  fi
  if (( $minor < 9 )); then
    if (( $minor > 0 )); then
      print_msg "Removing pre-installed Golang"
      sudo apt-get remove golang -y
    fi
    print_msg "Installing Golang version 1.9.2"
    sudo wget https://storage.googleapis.com/golang/go1.9.2.linux-amd64.tar.gz &> /dev/null
    sudo tar -zxf  go1.9.2.linux-amd64.tar.gz -C /usr/local/
    cd /usr/local/bin 
    sudo ln -sf /usr/local/go/bin/go
    cd -
  fi
}

########################## EXECUTION STARTS HERE #############################
# Terminal colors
NOCOLOR="\033[0m"
YELLOW='\033[1;33m'
MSG_COLOR=$YELLOW

install_dependencies
check_install_gcc
check_install_go
