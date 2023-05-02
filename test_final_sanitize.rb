require 'rails-html-sanitizer'
require 'loofah'
require 'nokogiri'

# Example usage
#html = '<div><script>alert("XSS");</script><a href="#" onclick="alert(\'XSS\')">Link</a></div>'
#detect_xss_sinks_css(html)


def sanitize_input(input)
  # Replace < and > with their HTML entity string
  if input.size <= 50
      formatted_input=input.force_encoding('ISO-8859-1').encode('UTF-8')
      reviview_formated=formatted_input.encode!("UTF-8", "ISO-8859-1", invalid: :replace, undef: :replace)
      reviview_formated.scrub!('')
      reviview_formated.gsub!(/</, "&lt;")
      reviview_formated.gsub!(/>/, "&gt;")
      
      # Replace double quote with its HTML entity string
      reviview_formated.gsub!(/"/, "&quot;")
      
      # Replace single quote with its HTML entity string
      reviview_formated.gsub!(/'/, "&#39;")

      # Sanitize the input SafeListSanitizer
      sanitizer = Rails::Html::WhiteListSanitizer.new
      sanitized_input = sanitizer.sanitize(reviview_formated)

      # Replace double quote with its HTML entity string
      sanitized_input.gsub!(/"/, "&quot;")
      
      # Replace single quote with its HTML entity string
      sanitized_input.gsub!(/'/, "&#39;")
      sanitized_input.gsub!(/`/, "&#x60;")
      # Build the DOM using Nokogiri
      #doc = Nokogiri::HTML::Document.parse(sanitize_input)
      #detect_xss_sinks_with_xpath(doc)
      #detect_xss_sinks_with_css(doc)

      return sanitized_input
  else
    puts "input have more than 50 characters"
  end
end


def detect_xss_sinks_with_xpath(html)
  puts "using xpath search DOM search........"
  # Build the DOM using Nokogiri
  sanitized_input = sanitize_input(html)
  puts "original input:-->#{html}"
  puts "input sanitized:-->#{sanitized_input}"
  # Build the DOM using Nokogiri
  doc = Nokogiri::HTML::Document.parse(sanitized_input)
  puts "building dom....:-->#{doc}"

  # Detect XSS sinks using XPath
  scripts = doc.xpath('//script')
  events = doc.xpath('//@*[starts-with(name(), "on")]')
  if scripts.size + events.size > 0
    # Display the corresponding elements
    puts "Detected XSS sinks in scripts:"
    scripts.each { |script| puts script.to_html }
    puts "Detected XSS sinks in events:"
    events.each { |event| puts event.parent.to_html }

    puts "Found #{scripts.size} <script> tags and #{events.size} attributes with 'on' prefix"
    raise StandardError.new("--->Possible XSS detected")
  end
  puts "nothing found using ---->xpath"
end



def detect_xss_sinks_with_css(html)
  puts "using css search DOM search........"
  sanitized_input = sanitize_input(html)
  puts "original input:-->#{html}"
  puts "input sanitized:-->#{sanitized_input}"
  # Build the DOM using Nokogiri
  doc = Nokogiri::HTML::Document.parse(sanitized_input)
  puts "building dom....:-->#{doc}"

  # Search for potential XSS sinks
  scripts = doc.css('script')
  #scripts = doc.css('script[onerror], script[onclick]')
  onevent_attrs = doc.css('*').select { |el| el.attributes.keys.any? { |attr| attr.start_with?('on') } }

  if scripts.size + onevent_attrs.size > 0
    # Display the corresponding elements
    puts "Detected XSS sinks in scripts:"
    scripts.each { |script| puts script.to_html }
    puts "Detected XSS sinks in events:"
    onevent_attrs.each { |event| puts event.parent.to_html }

    puts "Found #{scripts.size} <script> tags and #{onevent_attrs.size} attributes with 'on' prefix"
    raise StandardError.new("--->Possible XSS detected")
  end
  puts "nothing found using ---->css"
end

# Example usage
#input = "elem.\"innerText=elem.outerHTML"
#detect_xss_sinks_with_xpath(input)
#detect_xss_sinks_with_css(input)
#puts "Scrubbed output final result: #{detect_xss_sinks_with_xpath(input)}"