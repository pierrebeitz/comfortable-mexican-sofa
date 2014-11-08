class ComfortableMexicanSofa::FormBuilder < BootstrapForm::FormBuilder

  def field_name_for(tag)
    tag.blockable.class.name.demodulize.underscore.gsub(/\//,'_')
  end

  # -- Tag Field Fields -----------------------------------------------------
  def default_tag_field(tag, index, method = :text_field_tag, options = {})

    label       = tag.blockable.class.human_attribute_name(tag.identifier.to_s)
    css_class   = tag.class.to_s.demodulize.underscore
    content     = ''
    fieldname   = field_name_for(tag)
    case method
    when :file_field_tag
      input_params = {:id => nil}
      name = "#{fieldname}[blocks_attributes][#{index}][content]"

      if options.delete(:multiple)
        input_params.merge!(:multiple => true)
        name << '[]'
      end

      content << @template.send(method, name, input_params)
      content << @template.render(:partial => 'comfy/admin/cms/files/page_form', :object => tag.block)
    else
      options[:class] = ' form-control'
      content << @template.send(method, "#{fieldname}[blocks_attributes][#{index}][content]", tag.content, options)
    end
    content << @template.hidden_field_tag("#{fieldname}[blocks_attributes][#{index}][identifier]", tag.identifier, :id => nil)

    form_group :label => {:text => label} do 
      content.html_safe
    end
  end

  def field_date_time(tag, index)
    default_tag_field(tag, index, :text_field_tag, :data => {'cms-datetime' => true})
  end

  def field_integer(tag, index)
    default_tag_field(tag, index, :number_field_tag)
  end

  def field_string(tag, index)
    default_tag_field(tag, index)
  end

  def field_text(tag, index)
    default_tag_field(tag, index, :text_area_tag, :data => {'cms-cm-mode' => 'text/html'})
  end

  def field_rich_text(tag, index)
    default_tag_field(tag, index, :text_area_tag, :data => {'cms-rich-text' => true})
  end

  def field_boolean(tag, index)
    fieldname = field_name_for(tag)
    content = @template.hidden_field_tag("#{fieldname}[blocks_attributes][#{index}][content]", '', :id => nil)
    content << @template.check_box_tag("#{fieldname}[blocks_attributes][#{index}][content]", '1', tag.content.present?, :id => nil)
    content << @template.hidden_field_tag("#{fieldname}[blocks_attributes][#{index}][identifier]", tag.identifier, :id => nil)
    form_group :label => {:text => (tag.blockable.class.human_attribute_name(tag.identifier.to_s) || tag.identifier.titleize + "?")} do
      content
    end
  end

  def page_date_time(tag, index)
    default_tag_field(tag, index, :text_field_tag, :data => {'cms-datetime' => true})
  end

  def page_integer(tag, index)
    default_tag_field(tag, index, :number_field_tag)
  end

  def page_string(tag, index)
    default_tag_field(tag, index)
  end

  def page_text(tag, index)
    default_tag_field(tag, index, :text_area_tag, :data => {'cms-cm-mode' => 'text/html'})
  end

  def page_rich_text(tag, index)
    default_tag_field(tag, index, :text_area_tag, :data => {'cms-rich-text' => true})
  end

  def page_file(tag, index)
    default_tag_field(tag, index, :file_field_tag)
  end

  def page_files(tag, index)
    default_tag_field(tag, index, :file_field_tag, :multiple => true)
  end

  def page_markdown(tag, index)
    default_tag_field(tag, index, :text_area_tag, :data => {'cms-cm-mode' => 'text/x-markdown'})
  end

  def page_tag(tag, index)
    css_class       = tag.class.to_s.demodulize.underscore
    content         = ''
    fieldname       = field_name_for(tag)
    params          = tag.params
    options         = params[0] || {}

    case tag.field_helper
      when 'check_box'
        options[:checked] = !tag.content.to_i.zero?

      when 'select'
        params[0] = @template.options_for_select params[0], tag.content
        options = params[1] || {}

        # select_with_bootstrap(method, choices, options = {}, html_options = {})
      when 'collection_select'
        content << 'collection_select is not yet implemented'
        options = params[1]
        # method, collection, value_method, text_method, options = {}, html_options = {}
      when 'grouped_collection_select'
        content << 'grouped_collection_select is not yet implemented'
        # grouped_collection_select_with_bootstrap(method, collection, group_method, group_label_method, option_key_method, option_value_method, options = {}, html_options = {})
      when 'time_zone_select'
        content << 'time_zone_select is not yet implemented'
        # time_zone_select_with_bootstrap(method, priority_zones = nil, options = {}, html_options = {})
      when 'radio_button'
        content << 'radio_button is not yet implemented'

        # def radio_button_with_bootstrap(name, value, *args)
        #   options = args.extract_options!.symbolize_keys!
        #   args << options.except(:label, :help, :inline)
        #   html = radio_button_without_bootstrap(name, value, *args) + " " + options[:label]
        #   if options[:inline]
        #     label(name, html, class: "radio-inline", value: value)
        #   else
        #     content_tag(:div, class: "radio") do
        #       label(name, html, value: value)
        #     end
        #   end
        # end

      when 'collection_check_boxes'
        content << 'collection_check_boxes is not yet implemented'

        # def collection_check_boxes(*args)
        #   html = inputs_collection(*args) do |name, value, options|
        #     options[:multiple] = true
        #     check_box(name, options, value, nil)
        #   end
        #   hidden_field(args.first,{value: "", multiple: true}).concat(html)
        # end

      when 'collection_radio_buttons'
        content << 'collection_radio_buttons is not yet implemented'
        # def collection_radio_buttons(*args)
        #   inputs_collection(*args) do |name, value, options|
        #     radio_button(name, value, options)
        #   end
        # end
        #
      else
        options = params[0]
        options[:value] = tag.content
    end

    options[:label] ||= tag.blockable.class.human_attribute_name(tag.identifier.to_s)

    content << @template.send(tag.field_helper, "#{fieldname}[blocks_attributes][#{index}]", :content, *params)
    content << @template.hidden_field_tag("#{fieldname}[blocks_attributes][#{index}][identifier]", tag.identifier, :id => nil)

    content.html_safe
    form_group :label => {:text => options[:label]} do
      content.html_safe
    end
  end

  alias :field_tag :page_tag

  def collection(tag, index)
    options = [["---- Select #{tag.collection_class.titleize} ----", nil]] +
      tag.collection_objects.collect do |m|
        [m.send(tag.collection_title), m.send(tag.collection_identifier)]
      end

    fieldname = field_name_for(tag)
    content = @template.select_tag(
      "#{fieldname}[blocks_attributes][#{index}][content]",
      @template.options_for_select(options, :selected => tag.content),
      :id => nil
    )
    content << @template.hidden_field_tag("#{fieldname}[blocks_attributes][#{index}][identifier]", tag.identifier, :id => nil)
    form_group :label => {:text => tag.identifier.titleize}, :class => tag.class.to_s.demodulize.underscore do
      content
    end
  end

end
