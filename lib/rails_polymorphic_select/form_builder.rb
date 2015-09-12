module RailsPolymorphicSelect
  module FormBuilder
    LABEL_NAME_METHODS = [
      :to_label,
      :display_name,
      :label,
      :name,
      :title,
      :username,
      :login,
      :value,
      :to_s
    ]

    def polymorphic_select(method_name, models, options = {}, html_options = {})
      label_method = options.delete(:label_method)

      choices = models.map do |model_class|
        [model_class.model_name.human, model_class.all.map { |record|
          [label_for(record, label_method), record.to_global_id]
        }]
      end

      select(method_name, choices, options, html_options)
    end

    private

    def label_for(record, label_method)
      unless label_method && record.respond_to?(label_method)
        label_method = LABEL_NAME_METHODS.detect{|method_name| record.respond_to?(method_name) }
      end
      record.send(label_method)
    end
  end
end
