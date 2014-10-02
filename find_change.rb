require './extend_array'
require './regression'

noisy_decline = [10.3, 9.7, 8.9, 8.9, 8.9, 7.6, 7.8, 6.7, 6.4, 6.4, 6.5, 5.5, 5.4, 4.6, 4, 3.9, 3.1, 2.7, 3.1, 2.8, 2.1, 1.7, 0.9, 1, 0.3, 0.3,]
clean_decline = noisy_decline.rolling_average(3)

noisy_knee = [10.2, 9.2, 9.4, 8.7, 8.4, 7.9, 6.7, 6.4, 5.6, 5.1, 5.2, 4.7, 3.7, 3.8, 3.8, 4, 4.3, 3.5, 3.5, 3.9, 4, 3.9, 3.7, 3.9, 4.3, 3.9,]
clean_knee = noisy_knee.rolling_average(3)
x_axis = (0...26).to_a

def find_change_points(signal, x_axis, number_of_chunks = 5, threshold = 0.5)
  # Breaks array into chunks, compares the slopes. Returns an array of the index
  # (start, middle) that it appears to change. 
  # TODO: Consider implementing something R2'd
  raise "signal not an array" unless signal.kind_of?(Array)
  raise "x axis not an array" unless x_axis.kind_of?(Array)
  change_indexes = []
  length_of_chunk = (signal.length / number_of_chunks).floor

  (1..number_of_chunks-2).each do |chunk_count| # Changed this to -2 from -1, because slope_stack[2] was NaN on last itteration
    slope_stack = []
    [-1, 0, 1].each do |offset|
      test_signal = signal.slice( (chunk_count + offset) * length_of_chunk, length_of_chunk)
      test_x = x_axis.slice( (chunk_count + offset) * length_of_chunk, length_of_chunk)
      slope_stack << ArrayRegression.new(test_signal, test_x).slope 
    end

    pre_minus = slope_stack[0] - slope_stack[0] * threshold
    pre_plus = slope_stack[0] + slope_stack[0] * threshold
    post_minus = slope_stack[2] - slope_stack[2] * threshold
    post_plus = slope_stack[2] + slope_stack[2] * threshold

    puts "testing if #{slope_stack[1]} is bewteen #{pre_minus} and #{pre_plus}"
    puts "then if #{slope_stack[1]} is bewteen #{post_minus} and #{post_plus}"
    puts slope_stack[2]
    # TODO: slopes being negative is screwing me up. Also, my slope numbers are real small, data may be too noisy?
    if not slope_stack[1].between?(slope_stack[0] - slope_stack[0] * threshold, slope_stack[0] + slope_stack[0] * threshold)
      if slope_stack[1].between?(slope_stack[2] - slope_stack[2] * threshold, slope_stack[2] + slope_stack[2] * threshold)
        change_indexes << chunk_count * length_of_chunk
      end
    end 
  end
  
  puts change_indexes
end



find_change_points(clean_knee, x_axis, 5, 0.5)