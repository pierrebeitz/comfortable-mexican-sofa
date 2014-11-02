class ComfortableMexicanSofa::Tag::FieldTag < ComfortableMexicanSofa::Tag::PageTag

  include ComfortableMexicanSofa::Tag

  def self.regex_tag_signature(identifier = nil)
    identifier ||= /\w+/
    field_helper = /\w+/
    /\{\{\s*cms:field:(#{identifier}):(#{field_helper})(.*)\s*\}\}/
  end

  def render
    ''
  end

end