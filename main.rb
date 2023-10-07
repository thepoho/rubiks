require_relative 'camera.rb'
require_relative 'cube.rb'
require_relative 'robot.rb'
require_relative 'utilities.rb'

# scramble = File.read('test_scramble.txt')
# cube = Cube.new(scramble)
# puts Utilities.get_solve_string(cube.state)

#colours = Camera.new.run

#puts Utilities.c_to_r(colours)
strs = []
r = Robot.new
[:u,:b,:d,:f,:r,:l].each do |x|
  r.get_to_camera(x)
  colours = Camera.new.run
  strs << Utilities.c_to_r(colours)
end

strs = strs.flatten
puts strs.inspect
r.lga
#Utilities.print_colours([:red, :blue, :green, :yellow, :white, :orange, :white, :white, :white])

#Utilities.print_colours(colours)

#robot = Robot.new
#ARGV.each do |x|
#  robot.perform(x)
#end
