# # myArr = File.read('names_list.txt').lines.map { |name| name }.shuffle
#
# def get_names_list(num_of_names)
#   myArr = File.read('names_list.txt').lines.map { |name| name }.shuffle
#   delete_number = myArr.length - num_of_names
#   delete_number.times do
#     myArr.delete_at(0)
#   end
#   myArr
# end
# puts get_names_list(10)
#
# def get_rands(num_of_voters)
#   myArr = []
#   num_of_voters.times do
#     myArr << rand
#   end
#   myArr
# end
#
# p get_rands(10)
#
# def set_percentages
#   # clear
#   puts "\nWhat percentage of voters believe in each ideology?"
#   puts "Give percentages in the following order, separated by COMMAS!"
#   puts "\nLiberal, Conservative, Tea Party, Socialist, Other"
#   # prompt
#   myArr = gets.chomp.split(',')
#   myArr.map! { |ideology| ideology.strip.to_i }
#   myArr
# end
#
# p set_percentages

# def convert_percentages(array_of_percentages)
#   x = 1
#   while x < array_of_percentages.length do
#     array_of_percentages[x] += array_of_percentages[x-1]
#     x += 1
#   end
#   array_of_percentages
# end
#
# p convert_percentages([20, 20, 20, 20, 20])

# p "I went to the park".gsub(' ', '_')


# myhash = {
#   dog: "Daisy",
#   cat: "Kitty",
#   snake: "Garth"
# }
# p myhash.keys

p :dog.to_s
