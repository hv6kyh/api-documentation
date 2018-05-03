# Unique header generation
require 'middleman-core/renderers/redcarpet'
require 'digest'
class UniqueHeadCounter < Middleman::Renderers::MiddlemanRedcarpetHTML
  def initialize
    super
    @head_count = {}
  end
  def header(text, header_level)
    friendly_text = text.gsub(/<[^<]+>/,"").parameterize
    if friendly_text.strip.length == 0
      # Looks like parameterize removed the whole thing! It removes many unicode
      # characters like Chinese and Russian. To get a unique URL, let's just
      # URI escape the whole header
      friendly_text = Digest::SHA1.hexdigest(text)[0,10]
    end
    @head_count[friendly_text] ||= 0
    @head_count[friendly_text] += 1
    if @head_count[friendly_text] > 1
      friendly_text += "-#{@head_count[friendly_text]}"
    end
    anchor_svg = anchor_svg()
    anchor_svg = "<a name='#{friendly_text}' class='anchor' href='##{friendly_text}'>#{anchor_svg}</a>"
    return "<h#{header_level} id='#{friendly_text}' class='title'>#{anchor_svg}#{text}</h#{header_level}>"
  end

private

  def anchor_svg
     <<-eos
       <svg aria-hidden="true" class="octicon octicon-link" height="16" version="1.1" viewBox="0 0 16 16" width="16">
       <path d="M4 9h1v1h-1c-1.5 0-3-1.69-3-3.5s1.55-3.5 3-3.5h4c1.45 0 3 1.69 3 3.5 0 1.41-0.91 2.72-2 3.25v-1.16c0.58-0.45 1-1.27 1-2.09 0-1.28-1.02-2.5-2-2.5H4c-0.98 0-2 1.22-2 2.5s1 2.5 2 2.5z m9-3h-1v1h1c1 0 2 1.22 2 2.5s-1.02 2.5-2 2.5H9c-0.98 0-2-1.22-2-2.5 0-0.83 0.42-1.64 1-2.09v-1.16c-1.09 0.53-2 1.84-2 3.25 0 1.81 1.55 3.5 3 3.5h4c1.45 0 3-1.69 3-3.5s-1.5-3.5-3-3.5z"></path>
       </svg>
     eos
  end
end
