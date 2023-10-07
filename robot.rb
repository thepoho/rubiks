class Robot
  require_relative "robot_mover_module.rb"
  include RobotMoverModule
  #
  # Orientations/faces  initially facing camera is U
  # Test with white at camera, orange at front
  # U L F R B D
 
  IDX = {
    u: 0, #white   UP
    l: 1, #blue    LEFT
    f: 2, #orange  FRONT
    r: 3, #green   RIGHT
    b: 4, #red     BACK
    d: 5, #yellow  DOWN
  }
  #U = 0 #white
  #L = 1 #blue
  #F = 2 #orange
  #R = 3 #green
  #B = 4 #red
  #D = 5 #yellow
  def initialize
    @orientation = [
      IDX[:u],
      IDX[:l],
      IDX[:f],
      IDX[:r],
      IDX[:b],
      IDX[:d],
    ]
    super()
  end


  MAIN_GRIPPER = 3
  REAR_GRIPPER = 5
  GRIPPER_FACES = [MAIN_GRIPPER, REAR_GRIPPER]
  CAMERA_FACE = 0

  def perform(moves)
    moves.split.each do |x|
      puts "#{x}"
      perform_move(x)
    end
    loose_grip_all
  end

  def perform_move(face)
    reverse = face.include? "'"
    face = face[0].to_sym
    gripper = get_to_gripper(face)
    if which_gripper?(face) == MAIN_GRIPPER
      twist_face_right
      unless reverse
        twist_face_right
        twist_face_right
      end
    else
      twist_face_left
      unless reverse
        twist_face_left
        twist_face_left
      end
    end
  end

  def get_to_camera(face)
    return if is_in_camera?(face)
  end

  def get_to_gripper(face)
    return if is_in_gripper?(face)
    if @orientation[IDX[face]] == IDX[:u] 
      translate_left
      translate_left
    elsif @orientation[IDX[face]] == IDX[:f] 
      translate_left
    elsif @orientation[IDX[face]] == IDX[:r] 
      translate_right
    elsif @orientation[IDX[face]] == IDX[:l] 
      translate_right
      translate_right
    end
  end
  
  def which_gripper?(face)
    #puts @orientation.inspect
    if GRIPPER_FACES.include?(@orientation[IDX[face]])
      return @orientation[IDX[face]]
    end
  end
  def is_in_gripper?(face)
    !!which_gripper?(face)
  end

  def get_to_camera(face)
    return if(is_in_camera?(face))
    if @orientation[IDX[face]] == IDX[:b]
      translate_left
    elsif @orientation[IDX[face]] == IDX[:d]
      translate_left
      translate_left
    elsif @orientation[IDX[face]] == IDX[:f]
      translate_left
      translate_left
      translate_left
    elsif @orientation[IDX[face]] == IDX[:r]
      translate_right
      translate_left
      translate_left
    elsif @orientation[IDX[face]] == IDX[:l]
      translate_right
      translate_left
    end
  end
  def is_in_camera?(face)
    @orientation[IDX[face]] == CAMERA_FACE
  end

  def translate_left
    new_orientation = [
      @orientation[IDX[:b]], #back goes to up spot
      @orientation[IDX[:l]], #left stays as is
      @orientation[IDX[:u]], #up goes to front spot
      @orientation[IDX[:r]], #right stays as is
      @orientation[IDX[:d]], #down goes to back spot
      @orientation[IDX[:f]], #front goes to down spot
    ]
    @orientation = new_orientation
    rotate_direction_left
  end

  def translate_right
    new_orientation = [
      @orientation[IDX[:u]], #up stays the same
      @orientation[IDX[:b]], #left gets back
      @orientation[IDX[:l]], #front gets left
      @orientation[IDX[:f]], #right gets front
      @orientation[IDX[:r]], #back gets right
      @orientation[IDX[:d]], #down stays the same
    ]
    @orientation = new_orientation
    rotate_direction_right
  end
end
