require_relative 'cube.rb'
require_relative 'robot.rb'
require_relative 'utilities.rb'

scramble = File.read('test_scramble.txt')
cube = Cube.new(scramble)
puts Utilities.get_solve_string(cube.state)
