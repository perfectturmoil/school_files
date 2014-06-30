require 'gruff'
require './extend_array'
noisy_decline = [10.3, 9.7, 8.9, 8.9, 8.9, 7.6, 7.8, 6.7, 6.4, 6.4, 6.5, 5.5, 5.4, 4.6, 4, 3.9, 3.1, 2.7, 3.1, 2.8, 2.1, 1.7, 0.9, 1, 0.3, 0.3,]
noisy_knee = [10.2, 9.2, 9.4, 8.7, 8.4, 7.9, 6.7, 6.4, 5.6, 5.1, 5.2, 4.7, 3.7, 3.8, 3.8, 4, 4.3, 3.5, 3.5, 3.9, 4, 3.9, 3.7, 3.9, 4.3, 3.9,]
x_axis = (0...26).to_a

clean_decline = noisy_decline.rolling_average(3)
#TODO: not a terrible idea to double check that rolling_average does work right
x_labels = {}
x_axis.each_index do |index|
  x_labels[index] = x_axis[index].to_s
end

graph = Gruff::Line.new
graph.title = 'Decline'
graph.labels = x_labels
#INFO: values of labels hash mush be not integers. dumb. 
graph.data :Raw_Data, noisy_decline
graph.data :Clean_Data, clean_decline 
graph.write('./graph.png')

clean_knee = noisy_knee.rolling_average

graph2 = Gruff::Line.new
graph2.title = 'Knee'
graph2.data :Raw_Data, noisy_knee
graph2.data :Clean_Data, clean_knee
graph2.write('./graph2.png')