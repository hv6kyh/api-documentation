module Multilang
  def block_code(code, full_lang_name)
    if full_lang_name
      # Do not know why ?
      parts = full_lang_name.split('--')
      rouge_lang_name_and_classes = parts.first
      tab_name = parts.last

      # Potentially suffix your language to add class
      classes = rouge_lang_name_and_classes.split('.')
      rouge_lang_name = classes.first
      classes = classes[1..-1].join(' ')

      # Prefix your language with < to put it back in the middle
      if rouge_lang_name[0] == '<'
        rouge_lang_name = rouge_lang_name[1..-1]
        theme_class = "middle"
      else
        theme_class = "highlight"
      end

      if scope.build?
        "<div class=\"pre-lang-wrapper #{theme_class} tab-#{tab_name} #{classes}\">" \
        "{% pygment %}" \
        "<pre lang=\"#{rouge_lang_name}\">" \
          "#{code}" \
        "</pre>" \
        "{% endpygment %}" \
        "</div>"
      else
        result = super(code, rouge_lang_name).sub("highlight #{rouge_lang_name}") do |match|
          "#{rouge_lang_name}"
        end
        "<div class=\"pre-lang-wrapper #{theme_class} tab-#{tab_name} #{classes}\">#{result}</div>"
      end
    else
      super(code, full_lang_name)
    end
  end
end

require 'middleman-core/renderers/redcarpet'
Middleman::Renderers::MiddlemanRedcarpetHTML.send :include, Multilang
