# Copyright 2013 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"). You
# may not use this file except in compliance with the License. A copy of
# the License is located at
#
#     http://aws.amazon.com/apache2.0/
#
# or in the "license" file accompanying this file. This file is
# distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
# ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

require 'multi_xml'

module Aws
  module Xml
    # @api private
    class Parser

      # @param [Seahorse::Model::Shapes::Shape] rules
      def initialize(rules)
        @rules = rules
      end

      # @param [String<xml>] xml
      # @return [Hash]
      def to_hash(xml)
        structure(@rules, MultiXml.parse(xml).values.first || {})
      end

      # @param [Seahorse::Model::Shapes::Shape] rules
      # @param [String<xml>] xml
      # @return [Hash]
      def self.to_hash(rules, xml)
        Parser.new(rules).to_hash(xml)
      end

      private

      def structure(shape, hash)
        data = {}
        hash.each_pair do |key, value|
          if member_shape = shape.serialized_members[key]
            data[member_shape.member_name] = member(member_shape, value)
          end
        end
        data
      end

      def member(shape, raw)
        case shape
        when Seahorse::Model::Shapes::StructureShape
          structure(shape, raw)
        when Seahorse::Model::Shapes::ListShape
        when Seahorse::Model::Shapes::MapShape
        else raw
        end
      end

    end
  end
end
