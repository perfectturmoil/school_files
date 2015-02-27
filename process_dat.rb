# Process .DAT file, create two arrays
# usage: x_points, y_points = ProcessDat::process_dat('/home/dan/school/data_files/short_data.dat')


module ProcessDat
  def self.process_dat(filename)
    fail "Hey, sorry, #{filename} isn't a file" unless File.exist?(filename)
    x_axis = []
    y_axis = []
    dat_file = File.open(filename, 'r')
    dat_file.each do |line|
      if match = /^(?<x_value>\d+)\s+(?<y_value>-?\d+\.?\d+)$/.match(line)
        #puts "X : #{match[:x_value]}   Y : #{match[:y_value]}"
        x_axis << match[:x_value].to_f
        y_axis << match[:y_value].to_f
      end
    end
    return x_axis, y_axis
  end
end
