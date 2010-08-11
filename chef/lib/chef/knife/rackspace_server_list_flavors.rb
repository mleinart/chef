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
    class RackspaceServerListFlavors < Knife

      banner "knife rackspace server list flavors (options)"

      def h
        @highline ||= HighLine.new
      end

      def run 
        require 'fog'
        require 'highline'

        connection = Fog::Rackspace::Servers.new(
          :rackspace_api_key => Chef::Config[:knife][:rackspace_api_key],
          :rackspace_username => Chef::Config[:knife][:rackspace_api_username] 
        )


        flavor_pairs = Array.new
        connection.list_flavors.body['flavors'].each do |flavor|
          flavor_pairs << [ flavor['name'], flavor['id'].to_s ]
        end 

        flavor_pairs.sort! { |x,y| x[1] <=> y[1] }
        flavor_pairs.insert(0, h.color('Image', :bold), h.color('ID', :bold))
        puts h.list(flavor_pairs.flatten, :columns_across, 2)

      end
    end
  end
end



