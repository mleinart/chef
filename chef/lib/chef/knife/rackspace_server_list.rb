#
# Author:: Adam Jacob (<adam@opscode.com>)
# Copyright:: Copyright (c) 2009 Opscode, Inc.
# License:: Apache License, Version 2.0
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

require 'chef/knife'
require 'json'

class Chef
  class Knife
    class RackspaceServerList < Knife

      banner "knife rackspace server list (options)"

      def h
        @highline ||= HighLine.new
      end

      def run 
        require 'fog'
        require 'highline'
        require 'net/ssh/multi'
        require 'readline'

        connection = Fog::Rackspace::Servers.new(
          :rackspace_api_key => Chef::Config[:knife][:rackspace_api_key],
          :rackspace_username => Chef::Config[:knife][:rackspace_api_username] 
        )

        flavor_map = Hash.new { |h,k| h[k["id"]] = k["name"] }
        image_map = Hash.new { |h,k| h[k["id"]] = k["name"] }

        connection.list_flavors.body['flavors'].map { |i| flavor_map[i] }
        connection.list_images.body['images'].map { |i| image_map[i] }

        server_list = [ h.color('ID', :bold), h.color('Name', :bold), h.color('Public IP', :bold), h.color('Private IP', :bold), h.color('Flavor', :bold), h.color('Image', :bold) ]
        connection.servers.all.each do |server|
          server_list << server.id.to_s
          server_list << server.name
          server_list << server.addresses["public"][0]
          server_list << server.addresses["private"][0]
          server_list << flavor_map[server.flavor_id]
          server_list << image_map[server.image_id]
        end
        puts h.list(server_list, :columns_across, 6)

      end
    end
  end
end



