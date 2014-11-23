require_relative '../test_helper'

class FormBuilderTest < ActionView::TestCase

  def test_page_tags
    page = comfy_cms_pages(:default)
    layout = comfy_cms_layouts(:default)
    layout.content = '{{ cms:page:color_field:color_field }}
        {{ cms:page:date_field:date_field }}
        {{ cms:page:datetime_field:datetime_field }}
        {{ cms:page:datetime_local_field:datetime_local_field }}
        {{ cms:page:email_field:email_field }}
        {{ cms:page:month_field:month_field }}
        {{ cms:page:number_field:number_field }}
        {{ cms:page:password_field:password_field }}
        {{ cms:page:phone_field:phone_field }}
        {{ cms:page:range_field:range_field }}
        {{ cms:page:search_field:search_field }}
        {{ cms:page:telephone_field:telephone_field }}
        {{ cms:page:text_area:text_area }}
        {{ cms:page:text_field:text_field }}
        {{ cms:page:time_field:time_field }}
        {{ cms:page:url_field:url_field }}
        {{ cms:page:week_field:week_field }}
        {{ cms:page:date_select:date_select }}
        {{ cms:page:time_select:time_select }}
        {{ cms:page:datetime_select:datetime_select }}
        {{ cms:page:file_field:file_field }}
        {{ cms:page:files_field:file_field {"multiple": true} }}
        {{ cms:page:select:select ["Option1", "Option2"] }}
        {{ cms:page:label:label }}
        {{ cms:page:check_box:check_box }}'

    page.layout = layout

    tags = page.tags(true)

    assert_equal tags.count, 25

    assert_nothing_raised do
        builder = ComfortableMexicanSofa::FormBuilder.new :test, tags[0], self, {}
        tags.each do |tag|
            builder.send(tag.class.to_s.demodulize.underscore, tag)
        end
    end
  end
end
