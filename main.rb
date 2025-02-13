#set pull up/down
#
PIN_UP     = 27
PIN_DOWN   = 17
PIN_SELECT = 22
require_relative "calibrate.rb"
require_relative "solve.rb"
require_relative "robot.rb"



class Menu
  TEXTS = ["SOLVE", "CALIBRATE", "SHUT-DOWN"]
  def initialize
    @selected = 0
    @changed = true
  end

  def set_selected(num)
    @selected = num
    @changed = true
  end

  def move_up
    @selected -= 1
    @selected = 2 if @selected < 0
    @changed = true
  end

  def move_down
    @selected += 1
    @selected = 0 if @selected > 2
    @changed = true
  end

  def shutdown_selected?
    @selected == 2
  end

  def calibrate_selected?
    @selected == 1
  end

  def solve_selected?
    @selected == 0
  end

  def render(force: false)
    unless force
      return unless @changed
    end
    tmp = []
    TEXTS.each_with_index do |x, idx|
      if idx == @selected
        tmp << "* #{x}" 
      else
        tmp << "  #{x}" 
      end
    end 

    str = "\"#{tmp.join("\" \"")}\""
    `python3 screen_text.py #{str}`
    @changed = false
  end
end

class Input
  def initialize
    @old_states = {}
    @old_states[PIN_UP]     = false
    @old_states[PIN_DOWN]   = false
    @old_states[PIN_SELECT] = false
    @states = [0,0,0]
    @next_input = Time.now - 60

    puts "setting pull-ups"
    `raspi-gpio set #{PIN_UP},#{PIN_DOWN},#{PIN_SELECT} pu`
  end

  def read
    return if Time.now < @next_input
    output = `raspi-gpio get #{PIN_DOWN},#{PIN_UP},#{PIN_SELECT}`.split("\n")
    values = output.map{|x| x.match(/GPIO\s(\d{2}):\slevel=(\d)/)}
    changed = false
    values.each do |x|
      tmp = x[2] == "0"
      if tmp != @old_states[x[1].to_i]
        changed = true 
      end
      if tmp
        @old_states[x[1].to_i] = tmp
      end
    end
    if changed
      @next_input = Time.now + 0.5 #one second cooldown
    end
  end

  def was_pressed?(pin)
    ret = @old_states[pin]
    @old_states[pin] = false
    ret
    #TODO add a cooldown
  end
end

class Main

  def initialize
    @state = :menu
    @input = Input.new
    @menu = Menu.new
    Robot.new.lga
  end

  def run
# Process.spawn("python3 screen_text.py 'Calibrating' 'Please Wait'")
#             Calibrate.run
#             exit
    while 1 do
      if @state == :menu
        @input.read
        if @input.was_pressed?(PIN_UP)
          @menu.move_up
          @next_input = Time.now + 1
        elsif @input.was_pressed?(PIN_DOWN)
          @menu.move_down
          @next_input = Time.now + 1
        elsif @input.was_pressed?(PIN_SELECT)
          if @menu.shutdown_selected?
            `python3 screen_text.py "Shutting-" "Down" "Bye!" &`
            #exit
            `sudo shutdown -h now`
          elsif @menu.solve_selected?
            Process.spawn("python3 screen_text.py 'Solving' 'Please Wait'") 
            Solve.run
            @menu.render(force: true)
          elsif @menu.calibrate_selected?
            Process.spawn("python3 screen_text.py 'Calibrating' 'Please Wait'")
            Calibrate.run
            @menu.set_selected(0)
            @menu.render(force: true)
          end
        end
        @menu.render
      elsif @state == :calibrating
      elsif @state == :solving
      end
      sleep 0.1
    end
  end
end

Main.new.run
