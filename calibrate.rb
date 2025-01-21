require 'yaml'
require_relative 'camera.rb'
require_relative 'cube.rb'
require_relative 'robot.rb'
require_relative 'utilities.rb'

class Calibrate
  def self.run
#    sleep 5
#    return
    viewed = {}
    strs = []
    r = Robot.new
    camera = Camera.new
    File.delete('debug.log') rescue nil
    [:u,:b,:d,:f,:l,:r].each_with_index do |x, idx|
      if idx == 0
        Process.spawn("python3 screen_text.py 'Calibrating' 'camera'")
        viewed[:shutter] = camera.calibrate_shutter
      end
    #[:u].each do |x|
      Process.spawn("python3 screen_text.py 'Calibrating' '#{idx+1}/6'")

      r.get_to_camera(x)
      viewed[Utilities.face_to_colour(x)] = camera.get_averages(x)
      puts viewed.inspect
    #  break
    end
    puts viewed.inspect
    r.loose_grip_all
    File.open("colours.yml","w"){|f| f.puts viewed.to_yaml}
    Process.spawn("python3 screen_text.py 'Calibration' 'Complete!'")
    sleep 5
  end
end
