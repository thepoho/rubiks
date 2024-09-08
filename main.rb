#set pull up/down
#
PIN_UP     = 27
PIN_DOWN   = 17
PIN_SELECT = 22



class Menu
  TEXTS = ["SOLVE", "CALIBRATE", "SHUT-DOWN"]
  def initialize
    @selected = 0
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

  def render
    return unless @changed
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
    #puts @old_states.inspect
    output = `raspi-gpio get #{PIN_DOWN},#{PIN_UP},#{PIN_SELECT}`.split("\n")
    values = output.map{|x| x.match(/GPIO\s(\d{2}):\slevel=(\d)/)}
    #puts output.inspect
    changed = false
    values.each do |x|
      tmp = x[2] == "0"
      changed = true if tmp != @old_states[x[1]]
      if tmp
        @old_states[x[1].to_i] = tmp
      end
    end
    if changed
      @next_input = Time.now + 0.5 #one second cooldown
    end
    #puts @old_states.inspect
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
    @next_input = Time.now - 59
  end

  def run

    while 1 do
      if @state == :menu
        @menu.render
        if Time.now > @next_input
          if @input.was_pressed?(PIN_UP)
            @menu.move_up
          elsif @input.was_pressed?(PIN_DOWN)
            @menu.move_down
          elsif @input.was_pressed?(PIN_SELECT)
           #TODO 
          end
          @next_input = Time.now + 1
        end
      elsif @state == :calibrating
      elsif @state == :solving
      end
      @input.read
      sleep 0.1
    end
  end
end

Main.new.run
