require_relative '../../test_helper'

class PageTagTest < ActiveSupport::TestCase

  def test_initialize_tag
    assert tag = ComfortableMexicanSofa::Tag::PageTag.initialize_tag(
      comfy_cms_pages(:default), '{{ cms:page:content:text_field({ "label": "Some Id" })  }}'
    )
    assert_equal 'content', tag.identifier

    assert tag = ComfortableMexicanSofa::Tag::PageTag.initialize_tag(
      comfy_cms_pages(:default), '{{ cms:page:content:file_field({ "label": "Some Id" })  }}'
    )
    assert_equal 'content', tag.identifier

    assert tag = ComfortableMexicanSofa::Tag::PageTag.initialize_tag(
      comfy_cms_pages(:default), '{{ cms:page:content:text_field }}'
    )
    assert_equal 'content', tag.identifier
  end


  def test_initialize_tag_failure
    [
      '{{cms:page:content:not_a_field_helper}}',
      '{{cms:not_page:content:text_field}}',
      '{not_a_tag}'
    ].each do |tag_signature|
      assert_nil ComfortableMexicanSofa::Tag::PageTag.initialize_tag(
        comfy_cms_pages(:default), tag_signature
      )
    end
  end

  def test_content_and_render
    tag = ComfortableMexicanSofa::Tag::PageTag.initialize_tag(
      comfy_cms_pages(:default), '{{ cms:page:content:text_field() }}'
    )
    assert tag.block.content.blank?
    tag.block.content = 'test_content'
    assert_equal 'test_content', tag.content
    assert_equal 'test_content', tag.render
  end

end