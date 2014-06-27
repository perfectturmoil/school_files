require 'gruff'
require './extend_array'
noisy_decline = [10.3, 9.7, 8.9, 8.9, 8.9, 7.6, 7.8, 6.7, 6.4, 6.4, 6.5, 5.5, 5.4, 4.6, 4, 3.9, 3.1, 2.7, 3.1, 2.8, 2.1, 1.7, 0.9, 1, 0.3, 0.3,]
noisy_knee = [10.2, 9.2, 9.4, 8.7, 8.4, 7.9, 6.7, 6.4, 5.6, 5.1, 5.2, 4.7, 3.7, 3.8, 3.8, 4, 4.3, 3.5, 3.5, 3.9, 4, 3.9, 3.7, 3.9, 4.3, 3.9,]

clean_decline = []

# noisy_decline.each_index do |index|
#   if index == 0
#     push = noisy_decline[index]
#     clean_decline << push
#   elsif index == 1
#     push = (noisy_decline[index] + noisy_decline[index -1]) / 2
#     clean_decline << push
#   else
#     push = (noisy_decline[index] + noisy_decline[index -1] + noisy_decline[index -2]) / 3
#     clean_decline << push
#   end
# end

## CONFIRM THIS WORKS! 
clean_decline = noisy_decline.rolling_average(3)
## OMG CONFIRM THAT WORKED! MAKE SURE IMPORTING EXTEND_ARRAY DIDN'T HOSE 

graph = Gruff::Line.new
graph.title = 'Decline'
graph.data :Raw_Data, noisy_decline
graph.data :Clean_Data, clean_decline
graph.write('./graph.png')

clean_knee = noisy_knee.rolling_average
# noisy_knee.each_index do |index|
#   if index == 0
#     push = noisy_knee[index]
#     clean_knee << push
#   elsif index == 1
#     push = (noisy_knee[index] + noisy_knee[index -1]) / 2
#     clean_knee << push
#   else
#     push = (noisy_knee[index] + noisy_knee[index -1] + noisy_knee[index -2]) / 3
#     clean_knee << push
#   end
# end  


graph2 = Gruff::Line.new
graph2.title = 'Knee'
graph2.data :Raw_Data, noisy_knee
graph2.data :Clean_Data, clean_knee
graph2.write('./graph2.png')






#
#require 'gruff'
#g = Gruff::Line.new
#g.title = 'Wow!  Look at this!'
#g.labels = { 0 => '5/6', 1 => '5/15', 2 => '5/24', 3 => '5/30', 4 => '6/4',
             #5 => '6/12', 6 => '6/21', 7 => '6/28' }
#g.data :Jimmy, [25, 36, 86, 39, 25, 31, 79, 88]
#g.data :Charles, [80, 54, 67, 54, 68, 70, 90, 95]
#g.data :Julie, [22, 29, 35, 38, 36, 40, 46, 57]
#g.data :Jane, [95, 95, 95, 90, 85, 80, 88, 100]
#g.data :Philip, [90, 34, 23, 12, 78, 89, 98, 88]
#g.data :Arthur, [5, 10, 13, 11, 6, 16, 22, 32]
#g.write('exciting.png')