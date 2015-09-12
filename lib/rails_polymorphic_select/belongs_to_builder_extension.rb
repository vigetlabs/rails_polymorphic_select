module RailsPolymorphicSelect
  module BelongsToBuilderExtension
    def define_accessors(mixin, reflection)
      super

      if reflection.options[:polymorphic]
        define_global_id_methods(mixin, reflection.name)
      end
    end

    def define_global_id_methods(mixin, name)
      mixin.class_eval <<-CODE, __FILE__, __LINE__ + 1
        def #{name}_global_id
          #{name}.try(:to_global_id)
        end

        def #{name}_global_id=(new_global_id)
          self.#{name} = if new_global_id.present?
            GlobalID::Locator.locate(new_global_id)
          end
        end
      CODE
    end
  end
end
