#
# Cookbook Name:: yum
# Attributes:: cloudware
#
# Copyright 2012, KT Cloudware
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# default lookup repos in the environment
# if you want to enforce a specific one set it here. otherwise we will search for it
default['repo']['servers'] = [ ]

# fallback incase search fails 
#  Use repo01.mkd.ktc
master_repo = "14.63.251.159"
default['repo']['fallback'] = [ master_repo ]


