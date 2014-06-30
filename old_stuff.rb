# code removed from test2 - my original gross inline way of doing array averages
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