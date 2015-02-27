class Array
  def average
    # INFO: general application of reduce requires the set to be acted on, an initial
    # value, and the operation to apply when reducing the array (or whatever)
    # to a single value. Seems theg operation symbol must be special, need to look into that
    self.reduce(:+).to_f / self.count.to_f
  end

  def chunk_average(roll_count = 3)
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

  def rolling_average(roll_count = 3)
    a_return = self.dup

    a_return.each_index do |index|
      if index < roll_count
        a_return[index] = a_return.slice(0, index + 1).average
      else
        a_return[index] = a_return.slice(index - roll_count + 1, roll_count).average
      end
    end
    a_return
  end

  def rolling_average!(roll_count = 3)
    self.each_index do |index|
      if index < roll_count
        self[index] = self.slice(0, index + 1).average
      else
        self[index] = self.slice(index - roll_count + 1, roll_count).average
      end
    end
    self
  end
end

def test_array_extension
  my_array = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0]
  puts "#{my_array}\n\n"
  puts 'three point chunk:'
  puts "#{my_array.chunk_average(3)}\n\n"
  three_point_chunk = [1.0, 1.5, 2.0, 3.0, 4.0, 5.0]
  puts "#{three_point_chunk}"
  puts 'two point chunk'
  puts "#{my_array.chunk_average(2)}\n\n"
  two_point_chunk = [1.0, 1.5, 2.5, 3.5, 4.5, 5.5]
  puts "#{two_point_chunk}"

  puts 'three point roll:'
  puts "#{my_array.rolling_average(3)}\n\n"
  three_point_roll = [1.0, 1.5, 1.8333333333333333, 2.444444444444444, 3.092592592592593, 3.845679012345679]
  puts "#{three_point_chunk}"



end