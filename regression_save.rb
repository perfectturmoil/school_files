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



numerator = x_axis.each_index.reduce(0) do |sum, index|
  sum + ((x_axis[index] - x_axis.average) * (noisy_decline[index] - noisy_decline.average))
end
puts numerator

# previous code is analgous to this. reduce handles tracking the intermediate sum, kinda rather 
# than just a simple itteration. I dunno.
# numerator = 0.0
# x_axis.each_index do |index|
  # numerator += (x_axis[index] - x_axis.average) * (noisy_decline[index] - noisy_decline.average)
# end

denominator = x_axis.each_index.reduce(0) { |sum, index| sum + (x_axis[index] - x_axis.average) ** 2}

puts denominator

slope = numerator / denominator
  
puts slope

intercept = noisy_decline.average - slope * x_axis.average

puts intercept