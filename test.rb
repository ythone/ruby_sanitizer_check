require 'rails-html-sanitizer'
require 'loofah'

# Define a list of allowed attributes for each HTML tag
# If an attribute is not in this list, it will be removed
ALLOWED_ATTRIBUTES = {
    'a' => %w[href target],
    'img' => %w[src alt],
    'div' => %w[],
    'script' => %w[],
    'svg' => %w[onload],
    'input' => %w[type name value disabled readonly tabindex accesskey alt maxlength size autocomplete placeholder required pattern min max step],
    # Add more tags and attributes as needed
  }
  
  # Define a list of tags that are allowed
  # Any tags not in this list will be removed
  ALLOWED_TAGS = %w[a script input img div svg p b i u s]
  
  # Define a list of dangerous attributes and their safe alternatives
  DANGEROUS_ATTRIBUTES = {
    'onclick' => 'data-onclick',
    'onmouseover' => 'data-onmouseover',
    'onblur' => 'tabindex',
    'onpaste'=> 'readonly',
    'onkeypress'=> 'alt'
    # Add more dangerous attributes and their safe alternatives as needed
  }
  

  def sanitize_input23(input)
    # Use Loofah to sanitize the input
  
    # Replace < and > with their corresponding HTML entities
    #input.gsub!('<', '&lt;')
    #input.gsub!('>', '&gt;')
  
    # Replace double quotes with &quote; and single quotes with &#39;
    input.gsub!('"', '&quot;')
    input.gsub!("'", '&#39;')
  
    input2nd = input
    puts "Original input: #{input2nd}"
    doc = Loofah.fragment(input2nd)
"""  
    doc.scrub!(Loofah::Scrubber.new do |node|
        # Check if the node is allowed
        if ALLOWED_TAGS.include?(node.name)
          # Remove any attributes that are not allowed
          node.attributes.keys.each do |attr|
            unless ALLOWED_ATTRIBUTES[node.name].include?(attr)
              node.remove_attribute(attr)
            end
          end
      
          # Replace any dangerous attributes with their safe alternatives
          node.attributes.each do |attr, value|
            if DANGEROUS_ATTRIBUTES[attr]
              node.set_attribute(DANGEROUS_ATTRIBUTES[attr], value)
              node.remove_attribute(attr)
            end
          end
        else
          # Remove any nodes that are not allowed
          node.remove
        end
      end)
"""
        
    doc.scrub!(Loofah::Scrubber.new do |node|
        # Check if the node is allowed
        if ALLOWED_TAGS.include?(node.name)
          # Remove any attributes that are not allowed
          """node.attributes.keys.each do |attr|
            unless ALLOWED_ATTRIBUTES[node.name].include?(attr)
              node.remove_attribute(attr)
            end
          end"""
      
            # Replace any dangerous attributes with their safe alternatives
            node.attributes.each do |attr, value|
                if DANGEROUS_ATTRIBUTES[attr]
                    node.set_attribute(DANGEROUS_ATTRIBUTES[attr], value)
                    node.remove_attribute(attr)
                end
            end

        else
          # Remove any nodes that are not allowed
          node.remove
        end
      end)

      output = doc.to_s
      puts "Scrubbed output: #{output}"
    # Use the SafeListSanitizer to remove any remaining unsafe elements/attributes
    sanitizer = Rails::Html::SafeListSanitizer.new
    sanitized_input = sanitizer.sanitize(output)
  
    # Replace double quotes with &quote; and single quotes with &#39;
    sanitized_input.gsub!('<', '&lt;')
    sanitized_input.gsub!('>', '&gt;')
    sanitized_input.gsub!(/"/, "&quot;")
  
    # Replace single quote with its HTML entity string
    sanitized_input.gsub!(/'/, "&#39;")
    sanitized_input.gsub!(/`/, "&#x60;")
  
    return sanitized_input
  end  

def sanitize_input(input)
  # Use Loofah to sanitize the input

  # Replace < and > with their corresponding HTML entities
  input.gsub!('<', '&lt;')
  input.gsub!('>', '&gt;')

  # Replace double quotes with &quote; and single quotes with &#39;
  #input.gsub!('"', '&quot;')
  #input.gsub!("'", '&#39;')
  
"""
input2nd = input
  
  doc = Loofah.fragment(input2nd)
  doc.scrub!(Loofah::Scrubber.new do |node|
    if node.name == 'input'
      # Replace onpaste with tabindex
      node['tabindex'] = '1'
      node.remove_attribute('onpaste')
    end
  end)
  
  output = doc.to_s
"""
  #doc = Loofah.fragment(input)

  # Use the SafeListSanitizer to remove any remaining unsafe elements/attributes
  sanitizer = Rails::Html::WhiteListSanitizer.new
  sanitized_input = sanitizer.sanitize(input,tags: ALLOWED_TAGS, attributes: ALLOWED_ATTRIBUTES)
  # Replace double quotes with &quote; and single quotes with &#39;
  sanitized_input.gsub!(/"/, "&quot;")
    
  # Replace single quote with its HTML entity string
  sanitized_input.gsub!(/'/, "&#39;")
  sanitized_input.gsub!(/`/, "&#x60;")

  return sanitized_input
end

# Example usage

#input = '<img onkeypress="alert(1)" contenteditable>test</img>'
input = "</script><svg onload=alert(1)>"

puts "Scrubbed output final result: #{sanitize_input23(input)}"


