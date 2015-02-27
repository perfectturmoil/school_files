# Process .DAT file, return x_axis array, y_axis_array (empty arrays if no rows matched)
# might also work with a CSV, it looks for a numbery thing, either some white space 
# or a comma, and a numbery thing. One sample file has multiple columns of data, this will
# only get the first. 

# usage: x_points, y_points = ProcessDat.process_dat('/home/dan/school/data_files/50ugCNTwithcells.dat')

module ProcessDat
  def self.process_dat(filename)
    testing = false
    fail "Hey, sorry, #{filename} isn't a file" unless File.exist?(filename)
    x_axis = []
    y_axis = []
    dat_file = File.open(filename, 'r')
    dat_file.each do |line|
      if match = /^(?<x_value>-?\d+\.?\d+)(\s+|,)(?<y_value>-?\d+\.?\d+)/.match(line)
        puts "X : #{match[:x_value]}   Y : #{match[:y_value]}" if testing 
        x_axis << match[:x_value].to_f
        y_axis << match[:y_value].to_f
      end
    end
    return x_axis, y_axis
  end
end
# puts ProcessDat.process_dat('/home/dan/school/data_files/50ugCNTwithcells.dat')

# I put a comment down here