require 'set'

module Rely
  # Defines a macro to allow object dependencies to be specified at the class
  # level with a block defining a default value.
  #
  # Based on attr_defaultable.
  module Dependencies
    # Ensure dependencies from the superclass are inherited by the subclass.
    def inherited(subclass)
      if superclass.respond_to?(:dependencies)
        subclass.dependencies.merge dependencies
      end

      super
    end

    # Stores a list of dependency attributes for use by the initializer.
    def dependencies
      @dependencies ||= Set.new
    end

    # Defines a new dependency attribute with a default value.
    def dependency(attribute, default)
      # Define a getter that lazily sets a default value.
      define_method attribute do
        if instance_variable_defined?(:"@#{attribute}")
          instance_variable_get(:"@#{attribute}")
        else
          instance_variable_set(:"@#{attribute}", default.call)
        end
      end

      # Define a setter that lazily sets a default value.
      attr_writer attribute

      # Mark the getter and setter as protected.
      protected attribute, "#{attribute}="

      # Add the attribute to the list of dependencies.
      dependencies << attribute
    end
  end
end
