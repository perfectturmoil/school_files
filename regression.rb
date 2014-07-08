require './extend_array'

noisy_decline = [10.3, 9.7, 8.9, 8.9, 8.9, 7.6, 7.8, 6.7, 6.4, 6.4, 6.5, 5.5, 5.4, 4.6, 4, 3.9, 3.1, 2.7, 3.1, 2.8, 2.1, 1.7, 0.9, 1, 0.3, 0.3,]
clean_decline = noisy_decline.rolling_average(3)

noisy_knee = [10.2, 9.2, 9.4, 8.7, 8.4, 7.9, 6.7, 6.4, 5.6, 5.1, 5.2, 4.7, 3.7, 3.8, 3.8, 4, 4.3, 3.5, 3.5, 3.9, 4, 3.9, 3.7, 3.9, 4.3, 3.9,]
clean_knee = noisy_knee.rolling_average(3)
x_axis = (0...26).to_a

# for each pair (length of one of the arrays)
# do (x[thisone] - x.average)*(y[this_one] - y.average)
# add em.

# NOTE: I may want to consider having a single hash 
# represent the wave from, rather than two arrays.
# however, the two arrays will probably be
# a lot more compatible with most things

class ArrayRegression
  # Performs Linear Regression. slope and intercept methods to be used like: 
  # Y = #{self.slope} * X + #{self.intercept}"
  attr_reader :slope
  attr_reader :intercept
  attr_reader :r_squared
  def initialize(y_array, x_array)
    
    @x_array = x_array
    @y_array = y_array
    @x_array_average = x_array.average
    @y_array_average = y_array.average
    raise 'X and Y arrays must match' if @x_array.length != y_array.length
    @slope = generate_slope
    @intercept = generate_intercept
    @r_squared = generate_r_squared
  end

  # TODO: rather than slope and intercept method, I should have instance variables with 
  # an attribute reader and private methods. Then I call private methods in the initialize

  def generate_slope
    numerator = @x_array.each_index.reduce(0) do |sum, index|
      sum + ((@x_array[index] - @x_array_average) * (@y_array[index] - @y_array_average))
    end

    denominator = @x_array.each_index.reduce(0) { |sum, index| sum + (@x_array[index] - @x_array_average) ** 2}

    (numerator / denominator)
  end

  def generate_intercept
    # this doesn't seem like it should work. slope should not be scoped here? self.scope?
    # apparently it does. I should ask someone 
    @y_array_average - slope * @x_array_average
  end


  # attempting to add r squared calculation
  def generate_r_squared
    # from http://en.wikipedia.org/wiki/Coefficient_of_determination :
    # r squared = 1 - SSres / SStot
    # SSres = sum of (Y[i] - regression[i]) ^ 2
    # SStot = sum (Y[i] - Y average) ^ 2
    squared_sum_residuals = @y_array.each_index.reduce(0) do |sum, index|
      sum + ( @y_array[index] - (slope * @x_array[index] + intercept ) ) **2
    end

    squared_sum_totals = @y_array.each_index.reduce(0) do |sum, index|
      sum + ( @y_array[index] - @y_array_average) ** 2
    end

    (1 - ( squared_sum_residuals / squared_sum_totals ) ).to_f
  end
  private :generate_intercept, :generate_slope, :generate_r_squared
end

regressed_noisy_decline = ArrayRegression.new(noisy_decline, x_axis)
puts "Equation for noisy decline: Y = #{regressed_noisy_decline.slope} * X + #{regressed_noisy_decline.intercept}"
puts "R Squared for noisy decline: #{regressed_noisy_decline.r_squared}"


regressed_clean_decline = ArrayRegression.new(clean_decline, x_axis)
puts "Equation for clean decline: Y = #{regressed_clean_decline.slope} * X + #{regressed_clean_decline.intercept}"
puts "R Squared for clean decline: #{regressed_clean_decline.r_squared}"
 
 

regressed_noisy_knee = ArrayRegression.new(noisy_knee, x_axis)
puts "Equation for noisy knee: Y = #{regressed_noisy_knee.slope} * X + #{regressed_noisy_knee.intercept}"
puts "R Squared for noisy knee: #{regressed_noisy_knee.r_squared}"
 

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