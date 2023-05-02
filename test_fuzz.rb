require 'open3'
require './test_final_sanitize.rb'
def fuzz(input_file)
  # Run Radamsa on the input file
  mutated_data, status = Open3.capture2("radamsa #{input_file}")

  if status.success?
    # Do something with the mutated data
    puts "Mutated data: #{mutated_data}"
    sanitize_input(mutated_data)
    #detect_xss_sinks_with_xpath(mutated_data)
    #detect_xss_sinks_with_css(mutated_data)
    #puts "Mutated data: #{mutated_data}"
  else
    puts "Error running Radamsa"
  end
end

# Example usage
fuzz('xss-payload-fragment.txt')