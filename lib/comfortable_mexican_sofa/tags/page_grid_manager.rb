class ComfortableMexicanSofa::Tag::PageGridManager
  include ComfortableMexicanSofa::Tag

  def self.regex_tag_signature(identifier = nil)
    identifier ||= IDENTIFIER_REGEX
    /\{\{\s*cms:page:(#{identifier}):grid_manager\s*\}\}/
  end

  def content
    block.content
  end
end
