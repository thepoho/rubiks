require 'yaml'
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
File.delete('debug.log') rescue nil
[:u,:b,:d,:f,:l,:r].each_with_index do |x, idx|
  if idx == 0
    puts "Calibrating shutter"
    Camera.new.calibrate_shutter
    puts "Calibration complete"
  end
#[:u].each do |x|
  r.get_to_camera(x)
  viewed[Utilities.face_to_colour(x)] = Camera.new.get_averages
  puts viewed.inspect
#  break
end
puts viewed.inspect
r.loose_grip_all
File.open("colours.yml","w"){|f| f.puts viewed.to_yaml}
