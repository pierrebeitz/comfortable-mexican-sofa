class ComfortableMexicanSofa::Tag::PageTag
  include ComfortableMexicanSofa::Tag

  attr_accessor :field_helper

  def self.regex_tag_signature(identifier = nil)
    identifier ||= /\w+/
    field_helper = /\w+/
    /\{\{\s*cms:page:(#{identifier}):(#{field_helper})(.*)\s*\}\}/
  end

  def content
    block.content
  end

  def self.initialize_tag(blockable, tag_signature)
    if match = tag_signature.match(regex_tag_signature)
      field_helper = match[2]

      # wrapping as array, to save the user some typing
      params = begin
        JSON.parse '[' + match[3].gsub(/\s*\((.*)\)\s*/, '\1') + ']', symbolize_names: true
      rescue
        {}
      end

      tag = self.new
      tag.blockable    = blockable
      tag.identifier   = match[1]
      tag.namespace   = (ns = tag.identifier.split('.')[0...-1].join('.')).blank?? nil : ns
      tag.field_helper = field_helper
      tag.params       = params
      tag
    end
  end
end