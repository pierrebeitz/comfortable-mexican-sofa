class ComfortableMexicanSofa::FormBuilder < BootstrapForm::FormBuilder

  def field_name_for(tag)
    tag.blockable.class.name.demodulize.underscore.gsub(/\//,'_')
  end


  ### the following methods are just here to stay compatible with the current comfy-tags
  def field_date_time(tag)
    deprecate tag, 'datetime_field'
  end
  alias :page_date_time :field_date_time

  def field_integer(tag)
    deprecate tag, 'number_field'
  end
  alias :page_integer :field_integer

  def field_string(tag)
    deprecate tag, 'text_field'
  end
  alias :page_string :field_string

  def field_text(tag)
    deprecate tag, 'text_area'
  end
  alias :page_text :field_text

  def field_rich_text(tag)
    tag.params << {:data => {'cms-rich-text' => true}}
    deprecate tag, 'text_area'
  end
  alias :page_rich_text :field_rich_text

  def field_boolean(tag)
    deprecate tag, 'check_box'
  end

  def page_markdown(tag)
    tag.params << {:data => {'cms-cm-mode' => 'text/x-markdown'}}
    deprecate tag, 'text_area'
  end

  def page_file(tag)
    deprecate tag, 'file_field'
  end

  def page_files(tag)
    tag.params << { :multiple => true }
    deprecate tag, 'file_field'
  end


  def page_tag(tag = nil)
    fieldname = field_name_for(tag)
    name      = 'content'
    params    = tag.params

    default_html_options = {}
    default_options   = {
      label: tag.blockable.class.human_attribute_name(tag.identifier.to_s),
      value: tag.content
    }


    # Map tags to bootstrap_form-helpers.
    # In the order they are defined in their form_builder, except for FIELD_HELPERS
    # and DATE_SELECT_HELPERS which are handled last for convenient option-setting.
    case tag.helper_method
    when *(FIELD_HELPERS + DATE_SELECT_HELPERS)

      options = {
        label: tag.blockable.class.human_attribute_name(tag.identifier.to_s),
        value: tag.content
      }.merge params[0] || {}

      case tag.helper_method

      when *FIELD_HELPERS
        case tag.helper_method
        when 'text_area'
          options[:data] = {'cms-cm-mode' => 'text/html'} unless options[:data]
        when 'datetime_field'
          options[:data] = {'cms-datetime' => true}
        end
        send(tag.helper_method, name, options)
      when *DATE_SELECT_HELPERS
        html_options = params[1] || {}
        send(tag.helper_method, name, options, html_options)
      end

    when 'file_field'
      options = default_options.merge( params[0] || {} )
      @template.render(:partial => 'comfy/admin/cms/files/page_form', :object => tag.block) +
      file_field(name, options)

    when 'select'
      choices = @template.options_for_select   (params[0] || {}), tag.content
      options      =      default_options.merge(params[1] || {})
      html_options = default_html_options.merge(params[2] || {})
      select(name, choices, options = {}, html_options = {})

    when 'collection_select'
      'collection_select is not yet implemented'
    when 'grouped_collection_select'
      'grouped_collection_select is not yet implemented'
    when 'time_zone_select'
      'time_zone_select is not yet implemented'

    when 'check_box'
      options = default_options.merge( params[0] || {} )
      options[:checked] = !tag.content.to_i.zero?
      options[:label] = tag.blockable.class.human_attribute_name(tag.identifier.to_s) || tag.identifier.titleize + "?"
      check_box(name, options)

    when 'radio_button'
      'radio_button is not yet implemented'
    when 'collection_check_boxes'
      'collection_check_boxes is not yet implemented'
    when 'collection_radio_buttons'
      'not yet implemented'
    when 'check_boxes_collection'
      'not yet implemented'
    when 'radio_buttons_collection'
      'not yet implemented'
    else
      raise 'invalid_form_helper'
    end
  end

  alias :field_tag :page_tag

  def deprecate tag, method
    # ActiveSupport::Deprecation.warn "Please use the new page/field-helpers"
    tag.helper_method = method
    page_tag(tag)
  end

  def collection(tag)
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
