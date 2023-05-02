require 'open3'
require './test_final_sanitize.rb'
def fuzz(input_file)
  # Run Radamsa on the input file
  #mutated_data, status = Open3.capture2("radamsa #{input_file}")

  # Open the input file and read its contents line by line
  File.foreach(input_file) do |line|
    # Run Radamsa on the current line
    mutated_data, status = Open3.capture2("radamsa", stdin_data: line)
    data = mutated_data
    if status.success?
      # Do something with the mutated data
      #puts "Mutated data: #{mutated_data.class}"
      puts "Mutated data: #{mutated_data}"
      data_css=detect_xss_sinks_with_css(data)
      data_xpath=detect_xss_sinks_with_xpath(data)
      #sanitize_input(data)
      if data_css !="" && data_xpath !=""
        puts "--->Possible XSS detected with css search:#{data_css}"
        puts "--->Possible XSS detected with xpath search:#{data_css}"
    else
      puts "Error running Radamsa"
    end
  end
end

# Example usage
fuzz('xss-payload-fragment.txt')