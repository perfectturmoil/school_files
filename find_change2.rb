require './extend_array'
require './regression'

noisy_decline = [10.3, 9.7, 8.9, 8.9, 8.9, 7.6, 7.8, 6.7, 6.4, 6.4, 6.5, 5.5, 5.4, 4.6, 4, 3.9, 3.1, 2.7, 3.1, 2.8, 2.1, 1.7, 0.9, 1, 0.3, 0.3,]
clean_decline = noisy_decline.rolling_average(3)

noisy_knee = [10.2, 9.2, 9.4, 8.7, 8.4, 7.9, 6.7, 6.4, 5.6, 5.1, 5.2, 4.7, 3.7, 3.8, 3.8, 4, 4.3, 3.5, 3.5, 3.9, 4, 3.9, 3.7, 3.9, 4.3, 3.9,]
clean_knee = noisy_knee.rolling_average(3)
x_axis = (0...26).to_a

def find_change_points(y_axis, x_axis, number_of_chunks = 5, change_threshold = 1)
  # Breaks y_axis and x_axis into chunks, finds slope of each chunk.
  # Then compares slopes to determine if that chunk represents
  # a change

  raise "not an array" unless y_axis.kind_of?(Array)
  raise "not an array" unless x_axis.kind_of?(Array)

  chunk_length = (y_axis.length / number_of_chunks).floor

  chunk_slopes= []

  (0..number_of_chunks-1).each do |chunk|
    start_point = chunk_length * chunk
    # don't need end point
    # end_point = chunk_length * chunk + chunk_length - 1

    y_chunk = y_axis.slice(start_point, chunk_length)
    x_chunk = x_axis.slice(start_point, chunk_length)
    
    chunk_regression = ArrayRegression.new(y_chunk, x_chunk)
    chunk_slopes[chunk] = chunk_regression.slope
  end

  puts chunk_slopes
  # from here. Chunk slopes each_index do |slope_index|
  # (actually 1..chunk_slopes.length -1).each do |slope_ index|
  # if chunk_slopes[slope_index] different from chunk_slopes[index-1]
  # maybe incorporate chunk_slopes [index+1] 
  # then its an inflection, and document accordingly. Probably return
  # the X value, maybe the index (may want to pivot the function to 
    # use that rather than the chunk array thing - make it work first


end

find_change_points(clean_knee, x_axis, 3, 1)
