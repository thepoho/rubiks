require_relative 'camera.rb'
require_relative 'cube.rb'
require_relative 'robot.rb'
require_relative 'utilities.rb'

# scramble = File.read('test_scramble.txt')
# cube = Cube.new(scramble)
# puts Utilities.get_solve_string(cube.state)

colours = Camera.new.run

#Utilities.print_colours([:red, :blue, :green, :yellow, :white, :orange, :white, :white, :white])
Utilities.print_colours(colours)

