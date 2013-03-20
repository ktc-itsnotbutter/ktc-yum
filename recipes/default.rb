#
# Author:: Jesse Nelson <spheromak@gmail.com>
# Cookbook Name:: yum
# Recipe:: cloudware
#
# Copyright:: Copyright (c) 2011 Jesse Nelson
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


# this should only be run on a yum platform
return unless is_yum_platform 

include_recipe "yum::yum"
class Chef::Recipe
  include Helpers::Repos
end


major = node['platform_version'].to_i

# find our repo servers
repo_servers = find_repo_servers

# if no servers found use s3
if repo_servers.empty?
  Chef::Log.error "find_repo_servers returned empty array, this shouldn't happen"
end

Chef::Log.info "REPO SERVER: #{repo_servers}"
# TODO: some way to validate mirrors. 
priorities_pkg="yum-plugin-priorities"
if major == 5
  priorities_pkg="yum-priorities"
end

package priorities_pkg 

# set up repo
yum_repository "cloudware_stable" do
  description "Prod Cloudware Packages"
  url assemble_urls( repo_servers, 
        "/prod/cloudware/#{node['platform'].downcase}/#{major.to_i}/#{node['kernel']['machine']}"
      )
  failovermethod "priority"
  priority 10
  action :add
end 

yum_repository "Cloudware-EPEL" do
  description "Cloudware EPEL Mirror"
  url assemble_urls( repo_servers, "/prod/epel/#{major}/#{node['kernel']['machine']}" )
  failovermethod "priority"
  priority 20
  action :add
end

%w/os updates extras centosplus/.each do |repo|
  yum_repository "CloudwareCentOS-#{repo}" do
    description "Centos Mirror for #{repo} packages"
    url assemble_urls( repo_servers,
      "/prod/#{node['platform'].downcase}/#{major}/#{repo}/#{node['kernel']['machine']}" 
    )
    failovermethod "priority"
    key "RPM-GPG-KEY-CentOS-#{major}"
    priority 30
    action :add
  end 
end

# Manage centos Repos
# delete the pre-made centos repos
%w/CentOS-Base CentOS-Debuginfo CentOS-Media  cloudware/.each do |repo|
  yum_repository repo do
    action :remove 
  end
end 

