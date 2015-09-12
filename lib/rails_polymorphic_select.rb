require "rails_polymorphic_select/engine"

module RailsPolymorphicSelect
  autoload :FormBuilder, 'rails_polymorphic_select/form_builder'
  autoload :BelongsToBuilderExtension, 'rails_polymorphic_select/belongs_to_builder_extension'
end
