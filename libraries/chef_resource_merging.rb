#
# Cookbook Name:: chef_resource_merging
# Author:: Scott W. Bradley <scottwb@gmail.com>
#
# Copyright 2014, Facet Digital, LLC
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
class Chef
  module DSL
    module Recipe

      def reusable_resource(
        resource_type,
        resource_name,
        default_action,
        &block
      )
        resource_str = "#{resource_type}[#{resource_name}]"
        existing_resource = run_context.resource_collection.find(resource_str)
        actions_before = existing_resource.action
        actions_before = [actions_before] unless actions_before.is_a? Array
        if block
          existing_resource.instance_eval(&block)
          actions_after = existing_resource.action
        else
          actions_after = []
        end
        if actions_after.nil? || actions_after.empty?
          actions_after = [default_action]
        end
        combined_actions = actions_before + actions_after
        combined_actions.delete(:nothing) if combined_actions.count > 1
        existing_resource.action combined_actions
        existing_resource
      rescue Chef::Exceptions::ResourceNotFound => e
        method_missing(resource_type, resource_name, &block)
      end

      def package(pkg, &block)
        reusable_resource("package", pkg, :install, &block)
      end

      def service(svc, &block)
        reusable_resource("service", svc, :nothing, &block)
      end

    end
  end
end
