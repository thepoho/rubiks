require 'yaml'
require_relative 'camera.rb'
require_relative 'cube.rb'
require_relative 'robot.rb'
require_relative 'utilities.rb'

# scramble = File.read('test_scramble.txt')
# cube = Cube.new(scramble)
# puts Utilities.get_solve_string(cube.state)

#colours = Camera.new.run

class Solve
  def self.run
    camera = Camera.new
    #sleep 5
    #return
if File.exist?('colours.yml')
  camera.set_colours YAML.load_file('colours.yml')
else
  puts "No colours.yml. Please run calibrate.rb"
  exit
end
#puts Utilities.c_to_r(colours)
viewed = {}
strs = []
r = Robot.new
File.delete('debug.log') rescue nil
[:u,:b,:d,:f,:l,:r].each_with_index do |x, idx|
  Process.spawn("python3 screen_text.py 'Analysing' '#{idx+1}/6'")
  r.get_to_camera(x)
  colours = camera.run(cp: "solve_#{x}")
  viewed[x] = Utilities.c_to_r(colours)
end


puts viewed.inspect

# need to rotate the viewed squares into the correct orientations
tmp = viewed[:u].each_slice(3).to_a
tmp = Utilities.rotate_array(tmp)
tmp = Utilities.rotate_array(tmp)
tmp = Utilities.rotate_array(tmp)
strs << tmp.flatten

tmp = viewed[:r].each_slice(3).to_a
tmp = Utilities.rotate_array(tmp)
tmp = Utilities.rotate_array(tmp)
strs << tmp.flatten

tmp = viewed[:f].each_slice(3).to_a
tmp = Utilities.rotate_array(tmp)
tmp = Utilities.rotate_array(tmp)
tmp = Utilities.rotate_array(tmp)
strs << tmp.flatten

tmp = viewed[:d].each_slice(3).to_a
tmp = Utilities.rotate_array(tmp)
tmp = Utilities.rotate_array(tmp)
tmp = Utilities.rotate_array(tmp)
strs << tmp.flatten

tmp = viewed[:l].each_slice(3).to_a
tmp = Utilities.rotate_array(tmp)
tmp = Utilities.rotate_array(tmp)
strs << tmp.flatten

tmp = viewed[:b].each_slice(3).to_a
tmp = Utilities.rotate_array(tmp)
strs << tmp.flatten

#[:u, :l, :f, :r, :b, :d].each do |x|
#  strs << viewed[x]
#end
strs = strs.flatten.join.upcase
puts strs


r.loose_grip_all
sleep(1)

solve_string = Utilities.get_solve_string(strs)
puts solve_string
if solve_string == "unsolvable cube!"
  `python3 screen_text.py "Unsolvable!"`
  r.loose_grip_all
  sleep 5
  return
else
  r.perform(solve_string)
end
r.loose_grip_all
#Utilities.print_colours([:red, :blue, :green, :yellow, :white, :orange, :white, :white, :white])

#Utilities.print_colours(colours)

#robot = Robot.new
#ARGV.each do |x|
#  robot.perform(x)
#end

  end
end
