require './extend_array'

noisy_decline = [10.3, 9.7, 8.9, 8.9, 8.9, 7.6, 7.8, 6.7, 6.4, 6.4, 6.5, 5.5, 5.4, 4.6, 4, 3.9, 3.1, 2.7, 3.1, 2.8, 2.1, 1.7, 0.9, 1, 0.3, 0.3,]
clean_decline = noisy_decline.rolling_average(3)
x_axis = (0...26).to_a

# for each pair (length of one of the arrays)
# do (x[thisone] - x.average)*(y[this_one] - y.average)
# add em.

# NOTE: I may want to consider having a single hash 
# represent the wave from, rather than two arrays.
# however, the two arrays will probably be
# a lot more compatible with most things

class ArrayRegression
  def initialize(y_array, x_array)
    @x_array = x_array
    @y_array = y_array
    @x_array_average = x_array.average
    @y_array_average = y_array.average
    raise 'X and Y arrays must match' if @x_array.length != y_array.length
  end

  def slope
    numerator = @x_array.each_index.reduce(0) do |sum, index|
      sum + ((@x_array[index] - @x_array_average) * (@y_array[index] - @y_array_average))
    end

    denominator = @x_array.each_index.reduce(0) { |sum, index| sum + (@x_array[index] - @x_array_average) ** 2}

    (numerator / denominator)
  end

  def intercept
    # this doesn't seem like it should work. slope should not be scoped here? self.scope?
    # apparently it does. I should ask someone 
    @y_array_average - slope * @x_array_average
  end

end

regressed = ArrayRegression.new(noisy_decline, x_axis)

puts "Equation: Y = #{regressed.slope} * X + #{regressed.intercept}"

# 
# numerator = x_axis.each_index.reduce(0) do |sum, index|
  # sum + ((x_axis[index] - x_axis.average) * (noisy_decline[index] - noisy_decline.average))
# end
# puts numerator
# 
# # previous code is analgous to this. reduce handles tracking the intermediate sum, kinda rather 
# # than just a simple itteration. I dunno.
# # numerator = 0.0
# # x_axis.each_index do |index|
  # # numerator += (x_axis[index] - x_axis.average) * (noisy_decline[index] - noisy_decline.average)
# # end
# 
# denominator = x_axis.each_index.reduce(0) { |sum, index| sum + (x_axis[index] - x_axis.average) ** 2}
# 
# puts denominator
# 
# slope = numerator / denominator
#   
# puts slope
# 
# intercept = noisy_decline.average - slope * x_axis.average
# 
# puts intercept