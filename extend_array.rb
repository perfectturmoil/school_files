class Array
  def average
    # INFO: general application of reduce requires the set to be acted on, an initial
    # value, and the operation to apply when reducing the array (or whatever)
    # to a single value. Seems theg operation symbol must be special, need to look into that
    self.reduce(:+).to_f / self.count.to_f
  end

  def rolling_average(roll_count = 3)
    a_return = []
    self.each_index do |index|
#      if index == 0
#        a_return << self[index]
#      elsif index < roll_count
#        a_return << self.slice(0,index).average
      if index < roll_count
        a_return << self.slice(0, index + 1).average
      else
        a_return << self.slice(index - roll_count + 1, roll_count).average
      end
    end
    a_return
  end
end

def test_array_extension
  my_array = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0]
  puts "#{my_array}\n\n"
  puts 'three point:'
  puts "#{my_array.rolling_average(3)}\n\n"
  three_point_rolling = [1.0, 1.5, 2.0, 3.0, 4.0, 5.0]
  puts "#{three_point_rolling}"
  puts 'two point'
  puts "#{my_array.rolling_average(2)}\n\n"
  two_point_rolling = [1.0, 1.5, 2.5, 3.5, 4.5, 5.5]
  puts "#{two_point_rolling}"
end