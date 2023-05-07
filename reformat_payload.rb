# Open the input file for reading and the output file for writing
File.open("xss-payload-list.txt", "r") do |input_file|
    File.open("xss-payload-formated.txt", "w") do |output_file|
  
      # Iterate through each line in the input file
      input_file.each_line do |line|
  
        # Check if the line has less than 50 characters
        if line.length <= 49
  
          # Write the line to the output file
          output_file.write(line)
        end
      end
    end
  end