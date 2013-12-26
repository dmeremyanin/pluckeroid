module Pluckeroid
  module ActiveRecord
    module Base
      def self.included(base)
        base.singleton_class.class_eval do
          delegate :pluck_attributes, :pluck, :values_of, :value_of, to: :scoped
        end
      end
    end
  end
end

class ActiveRecord::Base
  include Pluckeroid::ActiveRecord::Base
end
