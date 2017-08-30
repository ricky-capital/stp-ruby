module Stp
  module Validation
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.extend(ClassMethods)
    end

    module InstanceMethods
      attr_reader :object, :errors

      def valid?
        @errors = []
        self.class.validators.each { |attr| validate(attr) }
        @errors.empty?
      end

      private

      def validate(attr)
        val = self.send(attr)
        @errors << attr if val.nil? || (val.respond_to?(:empty?) && val.empty?)
      end
    end

    module ClassMethods
      def validates(*args)
        create_validation(args)
      end

      def validators
        @validators.flatten
      end

      private

      def create_validation(args)
        @validators ||= []
        @validators << args
      end
    end
  end
end
