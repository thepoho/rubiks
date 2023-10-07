require_relative 'camera.rb'
require_relative 'cube.rb'
require_relative 'robot.rb'
require_relative 'utilities.rb'

# scramble = File.read('test_scramble.txt')
# cube = Cube.new(scramble)
# puts Utilities.get_solve_string(cube.state)

#colours = Camera.new.run

#puts Utilities.c_to_r(colours)
viewed = {}
strs = []
r = Robot.new
[:u,:b,:d,:f,:l,:r].each do |x|
#[:f,:l,:r].each do |x|
  r.get_to_camera(x)
  colours = Camera.new.run
  viewed[x] = Utilities.c_to_r(colours)
end

puts viewed.inspect

[:u, :l, :f, :r, :b, :d].each do |x|
  strs << viewed[x]
end
strs = strs.flatten.join.upcase
puts strs

solve_string = Utilities.get_solve_string(strs)
puts solve_string
puts "BOOOOO" if solve_string == "unsolvable cube!"
r.loose_grip_all
#Robot.new.perform(solve_string)
#Utilities.print_colours([:red, :blue, :green, :yellow, :white, :orange, :white, :white, :white])

#Utilities.print_colours(colours)

#robot = Robot.new
#ARGV.each do |x|
#  robot.perform(x)
#end
