class Robot
  # Orientations/faces  initially facing camera is U
  # Test with white at camera, orange at front
  # U L F R B D
 
  IDX = {
    u: 0, #white
    l: 1, #blue
    f: 2, #orange
    r: 3, #green
    b: 4, #red
    d: 5, #yellow
  }
  #U = 0 #white
  #L = 1 #blue
  #F = 2 #orange
  #R = 3 #green
  #B = 4 #red
  #D = 5 #yellow
  @orientation = [
    IDX[:u],
    IDX[:l],
    IDX[:f],
    IDX[:r],
    IDX[:b],
    IDX[:d],
  ]
  #@orientation = [U L F R B D]
  MAIN_GRIPPER = 3
  REAR_GRIPPER = 5
  GRIPPER_FACES = [MAIN_GRIPPER, REAR_GRIPPER]

  #SERVOS
  SERVO_LEFT_GRIPPER  = 0
  SERVO_RIGHT_GRIPPER = 1
  SERVO_LEFT_ROTATOR  = 2
  SERVO_RIGHT_ROTATOR = 3

  LEFT_GRIPPER_UNGRIPPED  = 180
  LEFT_GRIPPER_GRIPPED    = 130
  RIGHT_GRIPPER_UNGRIPPED = 180
  RIGHT_GRIPPER_GRIPPED   = 125
  LEFT_GRIPPER_STRAIGHT   = 180
  LEFT_GRIPPER_ROTATED    = 50
  RIGHT_GRIPPER_STRAIGHT  = 180
  RIGHT_GRIPPER_ROTATED   = 50

  def initialize
    ungrip_all
    loose_grip_all
  end

  def perform(face)
    reverse = face.include? "'"
    face = face[0].to_sym
    get_to_gripper(face)
  end

  def get_to_gripper(face)
    return if is_in_gripper?(face)
    if @orientation[IDX[face]] == IDX[:u] 
      
    end
  end

  alias_method :rdl, :rotate_direction_left
  def rotate_direction_left
    schlep = 0.5
    grip_all
    sleep(schlep)
    ungrip_left
    sleep(schlep)
    twist_right
    sleep(schlep)
    grip_left
    sleep(schlep)
    ungrip_right
    sleep(schlep)
    untwist_right
    sleep(schlep)
    grip_right
    sleep(schlep)
    loose_grip_all
  end

  def is_in_gripper?(face)
    GRIPPER_FACES.include?(@orientation[IDX[face]])
  end


  alias_method :ua, :ungrip_all
  alias_method :ga, :grip_all
  alias_method :lga, :loose_grip_all
  alias_method :lgl, :loose_grip_left
  alias_method :lgr, :loose_grip_right
  alias_method :ul, :ungrip_left
  alias_method :gl, :grip_left
  alias_method :ur, :ungrip_right
  alias_method :gr, :grip_right
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
end
