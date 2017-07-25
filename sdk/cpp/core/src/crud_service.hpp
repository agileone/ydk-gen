//
// @file crud_service.hpp
// @brief The main ydk public header.
//
// YANG Development Kit
// Copyright 2016 Cisco Systems. All rights reserved
//
////////////////////////////////////////////////////////////////
// Licensed to the Apache Software Foundation (ASF) under one
// or more contributor license agreements.  See the NOTICE file
// distributed with this work for additional information
// regarding copyright ownership.  The ASF licenses this file
// to you under the Apache License, Version 2.0 (the
// "License"); you may not use this file except in compliance
// with the License.  You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.
//
//////////////////////////////////////////////////////////////////

#ifndef CRUD_SERVICE_HPP
#define CRUD_SERVICE_HPP

#include <map>
#include <memory>
#include <string>
#include "service.hpp"
#include "service_provider.hpp"

namespace ydk
{

namespace path
{
class DataNode;
class ServiceProvider;
}

class Entity;

class CrudService : public Service
{
    public:
        CrudService();

        bool create(ydk::ServiceProvider & provider, Entity & entity);

        bool update(ydk::ServiceProvider & provider, Entity & entity);

        bool delete_(ydk::ServiceProvider & provider, Entity & entity);

        std::shared_ptr<Entity> read(ydk::ServiceProvider & provider, Entity & filter);

        std::shared_ptr<Entity> read_config(ydk::ServiceProvider & provider, Entity & filter);

    private:
        std::shared_ptr<Entity> read_datanode(Entity & filter, std::shared_ptr<path::DataNode> read_data_node);
};

}

#endif /* CRUD_SERVICE_HPP */
