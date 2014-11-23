class ComfortableMexicanSofa::Tag::PageTag
  include ComfortableMexicanSofa::Tag

  def self.regex_tag_signature(identifier = nil)
    identifier ||= /\w+/
    helper_method = /\w+/
    /\{\{\s*cms:page:(#{identifier}):(#{helper_method})(.*)\s*\}\}/
  end

  def content
    block.content
  end

  def self.initialize_tag(blockable, tag_signature)
    if match = tag_signature.match(regex_tag_signature)
      helper_method = match[2]
      return nil unless BootstrapForm::FormBuilder.instance_methods.include? helper_method.to_sym
      # wrapping as array, to save the user some typing
      params = begin
        JSON.parse '[' + match[3].gsub(/\s*\((.*)\)\s*/, '\1') + ']', symbolize_names: true
      rescue
        []
      end

      tag = self.new
      tag.blockable     = blockable
      tag.identifier    = match[1]
      tag.namespace     = (ns = tag.identifier.split('.')[0...-1].join('.')).blank?? nil : ns
      tag.helper_method = helper_method
      tag.params        = params
      tag
    end
  end
end