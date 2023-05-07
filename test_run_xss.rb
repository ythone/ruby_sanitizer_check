require 'nokogiri'

# Define the HTML document with the potential XSS vulnerability
html = '<html><body><script>alert("XSS vulnerability")</script></body></html>'

# Parse the HTML document with Nokogiri
doc = Nokogiri::HTML.parse(html)

# Check if the script tag is present in the document
if doc.css('script').any?
  # The script tag is present, indicating a potential XSS vulnerability
  # You can then take appropriate action, such as reporting the vulnerability or sanitizing the input
  puts 'Potential XSS vulnerability detected'
else
  # The script tag is not present, indicating that the input is safe
  puts 'Input is safe'
end