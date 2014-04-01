class SymbolizeInput < SimpleForm::Inputs::CollectionInput
   def input_options
      options = super
      validator_options = object.class.validators.find {|v| v.attributes == [attribute_name]}.options
      options[:include_blank] = !!(validator_options[:allow_blank] || validator_options[:allow_nil])
      options
   end

   def input
    @builder.send('select', attribute_name, collection, input_options, input_html_options)
   end

  private

  def collection
    @values ||= object.class.send(:"get_#{attribute_name}_values").to_a
  end

end