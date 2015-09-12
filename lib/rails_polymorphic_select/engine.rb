module RailsPolymorphicSelect
  class Engine < ::Rails::Engine

    config.generators do |g|
      g.test_framework      :rspec,        :fixture => false
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
      g.assets false
      g.helper false
    end

    initializer "rails_polymorphic_select.include_extensions" do |app|
      ActionView::Helpers::FormBuilder.send(:include, RailsPolymorphicSelect::FormBuilder)
      ActiveRecord::Associations::Builder::BelongsTo.extend RailsPolymorphicSelect::BelongsToBuilderExtension
    end
  end
end
