module RobotMoverModule

  #SERVOS
  SERVO_LEFT_GRIPPER  = 0
  SERVO_RIGHT_GRIPPER = 1
  SERVO_LEFT_ROTATOR  = 2
  SERVO_RIGHT_ROTATOR = 3

  LEFT_GRIPPER_UNGRIPPED  = 180
  LEFT_GRIPPER_GRIPPED    = 118
  RIGHT_GRIPPER_UNGRIPPED = 180
  RIGHT_GRIPPER_GRIPPED   = 121
  LEFT_GRIPPER_STRAIGHT   = 180
  LEFT_GRIPPER_ROTATED    = 50
  RIGHT_GRIPPER_STRAIGHT  = 180
  RIGHT_GRIPPER_ROTATED   = 40

  SLEEP_TIME = 0.3
  def initialize
    loose_grip_all
  end

  def rotate_direction_left
    grip_all
    sleep(SLEEP_TIME)
    ungrip_left
    sleep(SLEEP_TIME)
    twist_right
    sleep(SLEEP_TIME)
    grip_left
    sleep(SLEEP_TIME)
    ungrip_right
    sleep(SLEEP_TIME)
    untwist_right
    sleep(SLEEP_TIME)
    grip_right
    sleep(SLEEP_TIME)
    loose_grip_all
  end

  def rotate_direction_right
    grip_all
    sleep(SLEEP_TIME)
    ungrip_right
    sleep(SLEEP_TIME)
    twist_left
    sleep(SLEEP_TIME)
    grip_right
    sleep(SLEEP_TIME)
    ungrip_left
    sleep(SLEEP_TIME)
    untwist_left
    sleep(SLEEP_TIME)
    grip_left
    sleep(SLEEP_TIME)
    loose_grip_all
  end

  def twist_face_left
    grip_all
    sleep(SLEEP_TIME)
    twist_left
    sleep(SLEEP_TIME)
    ungrip_left
    sleep(SLEEP_TIME)
    untwist_left
    sleep(SLEEP_TIME)
    grip_left
    sleep(SLEEP_TIME)
    loose_grip_all
  end
  
  def twist_face_right
    grip_all
    sleep(SLEEP_TIME)
    twist_right
    sleep(SLEEP_TIME)
    ungrip_right
    sleep(SLEEP_TIME)
    untwist_right
    sleep(SLEEP_TIME)
    grip_right
    sleep(SLEEP_TIME)
    loose_grip_all
  end

  def ungrip_left
    cmd(SERVO_LEFT_GRIPPER, LEFT_GRIPPER_UNGRIPPED)
  end

  def grip_left
    loose_grip_left
    cmd(SERVO_LEFT_GRIPPER, LEFT_GRIPPER_GRIPPED)
    loose_grip_left
    cmd(SERVO_LEFT_GRIPPER, LEFT_GRIPPER_GRIPPED)
  end

  def ungrip_right
    cmd(SERVO_RIGHT_GRIPPER, RIGHT_GRIPPER_UNGRIPPED)
  end

  def grip_right
    loose_grip_right
    cmd(SERVO_RIGHT_GRIPPER, RIGHT_GRIPPER_GRIPPED)
    loose_grip_right
    cmd(SERVO_RIGHT_GRIPPER, RIGHT_GRIPPER_GRIPPED)
  end

  def twist_left
    cmd(SERVO_LEFT_ROTATOR, LEFT_GRIPPER_ROTATED)
  end

  def untwist_left
    cmd(SERVO_LEFT_ROTATOR, LEFT_GRIPPER_STRAIGHT)
  end

  def twist_right
    cmd(SERVO_RIGHT_ROTATOR, RIGHT_GRIPPER_ROTATED)
  end

  def untwist_right
    cmd(SERVO_RIGHT_ROTATOR, RIGHT_GRIPPER_STRAIGHT)
  end

  def grip_all
    grip_left
    grip_right
  end
  def ungrip_all
    ungrip_left
    ungrip_right
  end
  def untwist_all
    untwist_left
    untwist_right
  end
  def loose_grip_all
    loose_grip_left
    loose_grip_right
  end

  def loose_grip_left
    cmd(SERVO_LEFT_GRIPPER,  LEFT_GRIPPER_GRIPPED+10)
  end

  def loose_grip_right
    cmd(SERVO_RIGHT_GRIPPER, RIGHT_GRIPPER_GRIPPED+10)
  end

  def slow_grip
    # not used
    flatten_all
    ungrip_all
    steps = 10.to_f
    left_pos, right_pos = LEFT_GRIPPER_UNGRIPPED, RIGHT_GRIPPER_UNGRIPPED
    left_step  = (LEFT_GRIPPER_UNGRIPPED - LEFT_GRIPPER_GRIPPED) / steps
    right_step = (RIGHT_GRIPPER_UNGRIPPED - RIGHT_GRIPPER_GRIPPED) / steps
    (0..9).each do |x|
      left_value  = (LEFT_GRIPPER_UNGRIPPED - (left_step * x)).to_i
      right_value = (RIGHT_GRIPPER_UNGRIPPED - (right_step * x)).to_i
      if left_value < LEFT_GRIPPER_GRIPPED
        "left value too high #{left_value}"
        break
      end
      if right_value < RIGHT_GRIPPER_GRIPPED
        "right value too high #{right_value}"
        break
      end
      cmd(SERVO_LEFT_GRIPPER, left_value)
      cmd(SERVO_RIGHT_GRIPPER, right_value)
      sleep(0.3)
    end
  end


  def cmd(servo, angle)
    `python3 ~/src/rubiks/lib/servo.py #{servo} #{angle}`
  end
  alias_method :rdl, :rotate_direction_left
  alias_method :rdr, :rotate_direction_right
  alias_method :tfl, :twist_face_left
  alias_method :tfr, :twist_face_right
  alias_method :uga, :ungrip_all
  alias_method :ga,  :grip_all
  alias_method :lga, :loose_grip_all
  alias_method :lgl, :loose_grip_left
  alias_method :lgr, :loose_grip_right
  alias_method :ugl, :ungrip_left
  alias_method :gl,  :grip_left
  alias_method :ugr, :ungrip_right
  alias_method :gr,  :grip_right
  alias_method :tr,  :twist_right
  alias_method :utr, :untwist_right
  alias_method :tl,  :twist_left
  alias_method :utl, :untwist_left
end