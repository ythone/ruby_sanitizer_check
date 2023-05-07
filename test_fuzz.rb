require 'open3'
require './test_final_sanitize.rb'
def fuzz(input_file)
  # Run Radamsa on the input file
  #mutated_data, status = Open3.capture2("radamsa #{input_file}")
  count = 0
  # Open the input file and read its contents line by line
  File.foreach(input_file) do |line|
    # Run Radamsa on the current line
    mutation_option = ["ft=2","fo=2","fn","num=5","ld","lds","lr2","li","ls","lp","lr","lis","lrs","sr","sd","bd","bf","bi","br","bp","bei","bed","ber","uw","ui=2","xp=9","ab"]
    pattern_option = ["od","nd=2","bu"]
    for mutation in mutation_option do
      for pattern in pattern_option do
        mutated_data, status = Open3.capture2("radamsa -m #{mutation} -p #{pattern}", stdin_data: line)
    
        if status.success?
          # Do something with the mutated data
          data = mutated_data
          #puts "mutated data: #{data}"
          count = count + 1
          #puts "Mutated data: #{mutated_data.class}"
          #puts "Mutated data: #{mutated_data}"
          data_css=detect_xss_sinks_with_css(data)
          data_xpath=detect_xss_sinks_with_xpath(data)
          #sanitize_input(data)
          puts "#{count}--itme(s) fuzzed"
          if data_css !="" && data_xpath !=""
            puts "--->Possible XSS detected with css search:#{data_css}"
            puts "--->Possible XSS detected with xpath search:#{data_css}"
          end
        else
          puts "Error running Radamsa"
        end
      end
    end
  end
end

# Example usage
fuzz('xss-payload-formated.txt')