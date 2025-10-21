require 'json'

module FromJsonFilter
  def from_json(input)
    JSON.parse(input)
  rescue JSON::ParserError => e
    nil
  end
end

Liquid::Template.register_filter(FromJsonFilter)