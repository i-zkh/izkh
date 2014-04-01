# Use this setup block to configure all options available in SimpleForm.
SimpleForm.setup do |config|
  config.wrappers :default, class: :input,
    hint_class: :field_with_hint, error_class: :field_with_errors do |b|

    # Determines whether to use HTML5 (:email, :url, ...)
    # and required attributes
    b.use :html5

    # Calculates placeholders automatically from I18n
    # You can also pass a string as f.input placeholder: "Placeholder"
    b.use :placeholder

    # Calculates maxlength from length validations for string inputs
    b.optional :maxlength

    # Calculates pattern from format validations for string inputs
    b.optional :pattern

    # Calculates min and max from length validations for numeric inputs
    b.optional :min_max

    # Calculates readonly automatically from readonly attributes
    b.optional :readonly

    ## Inputs
    b.use :label_input
    b.use :hint,  wrap_with: { tag: :span, class: :hint }
    b.use :error, wrap_with: { tag: :span, class: :error }
  end


  config.form_class = 'simple_form form-horizontal'

  config.default_wrapper = :default

  config.boolean_style = :nested

  config.button_class = 'btn'

  config.error_notification_tag = :div

  config.error_notification_class = 'alert alert-error'

  config.label_class = 'control-label'

  config.browser_validations = false

  config.wrappers :bootstrap, tag: 'div', class: 'control-group', error_class: 'error' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label
    b.wrapper tag: 'div', class: 'controls' do |ba|
      ba.use :input
      ba.use :error, wrap_with: { tag: 'span', class: 'help-inline' }
      ba.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
    end
  end

  config.wrappers :prepend, tag: 'div', class: "control-group", error_class: 'error' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label
    b.wrapper tag: 'div', class: 'controls' do |input|
      input.wrapper tag: 'div', class: 'input-prepend' do |prepend|
        prepend.use :input
      end
      input.use :hint,  wrap_with: { tag: 'span', class: 'help-block' }
      input.use :error, wrap_with: { tag: 'span', class: 'help-inline' }
    end
  end

  config.wrappers :append, tag: 'div', class: "control-group", error_class: 'error' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label
    b.wrapper tag: 'div', class: 'controls' do |input|
      input.wrapper tag: 'div', class: 'input-append' do |append|
        append.use :input
      end
      input.use :hint,  wrap_with: { tag: 'span', class: 'help-block' }
      input.use :error, wrap_with: { tag: 'span', class: 'help-inline' }
    end
  end

  config.default_wrapper = :bootstrap
end

module SimpleForm
  class FormBuilder < ActionView::Helpers::FormBuilder
    def default_input_type(attribute_name, column, options) #:nodoc:
      return options[:as].to_sym if options[:as]
      return :select if options[:collection]
      custom_type = find_custom_type(attribute_name.to_s) and return custom_type

      return :symbolize if @object.class.respond_to? "get_#{attribute_name}_values"

      input_type = column.try(:type)
      case input_type
        when :timestamp
          :datetime
        when :string, nil
          case attribute_name.to_s
            when /password/ then
              :password
            when /time_zone/ then
              :time_zone
            when /country/ then
              :text
            when /email/ then
              :email
            when /phone/ then
              :tel
            when /url/ then
              :url
            when /state/ then
              :state
            else
              file_method?(attribute_name) ? :file : (input_type || :string)
          end
        else
          input_type
      end
    end

    def submit(name = nil, options = {:class => 'btn btn-primary'})
      super name, options
    end

  end
end