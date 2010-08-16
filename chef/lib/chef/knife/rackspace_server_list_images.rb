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
    class RackspaceServerListImages < Knife

      banner "knife rackspace server list images (options)"

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

        image_tuples = Array.new
        connection.list_images_detail.body['images'].each do |image|
          image_tuples << [ '"' + image['name'] + '"', image['id'].to_s, image['serverId'] ? "Yes" : "No" ]
        end 

        image_tuples.sort!
        image_tuples.insert(0, h.color('Name', :bold), h.color('ID', :bold), h.color('Custom', :bold))
        puts h.list(image_tuples.flatten, :columns_across, 3)

      end
    end
  end
end



