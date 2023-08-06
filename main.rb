require_relative 'utilities.rb'

scramble = File.read('test_scramble.txt')
puts Utilities.get_solve_string(scramble)
