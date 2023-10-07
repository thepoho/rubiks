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
  COL = {
    0 => :w,
    1 => :b,
    2 => :o,
    3 => :g,
    4 => :r,
    5 => :y,
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


  attr_accessor :orientation

  MAIN_GRIPPER = 3
  REAR_GRIPPER = 5
  GRIPPER_FACES = [MAIN_GRIPPER, REAR_GRIPPER]
  CAMERA_FACE = 0

  def idx
    IDX
  end

  def face_orientation(face)
    # Give it a face from starting orientation
    # and it will tell you which way it is facing
    #IDX.invert[@orientation[IDX[face]]]
    IDX.invert[@orientation.index(IDX[face])]
  end

  def print
    puts "Colours"
    puts [" ", COL[@orientation[IDX[:u]]], ""].join(" ")
    puts [:l, :f, :r, :b].map{|x| COL[@orientation[IDX[x]]]}.join(" ")
    puts [" ", COL[@orientation[IDX[:d]]], ""].join(" ")
    puts "Faces"
    puts [" ", IDX.invert[@orientation[IDX[:u]]], ""].join(" ")
    puts [:l, :f, :r, :b].map{|x| IDX.invert[@orientation[IDX[x]]]}.join(" ")
    puts [" ", IDX.invert[@orientation[IDX[:d]]], ""].join(" ")
    puts "Orientations"
    puts @orientation.inspect
  end

  def perform(moves)
    moves.split.each do |x|
      puts "#{x}"
      perform_move(x)
    end
    loose_grip_all
  end

  def perform_move(face)
    reverse = face.include? "'"
    double  = face.include? "2"
    face = face[0].to_sym
    gripper = get_to_gripper(face)
    if which_gripper?(face) == MAIN_GRIPPER
      twist_face_right
      if double
        twist_face_right
      end
      unless reverse
        twist_face_right
        twist_face_right
      end
    else
      twist_face_left
      if double
        twist_face_left
      end
      unless reverse
        twist_face_left
        twist_face_left
      end
    end
  end

  def get_to_gripper(face)
    return if is_in_gripper?(face)
    fo = face_orientation(face)
    if fo == :u
      translate_left
      translate_left
    elsif fo == :f
      translate_left
    elsif fo == :r 
      translate_right
    elsif fo == :l
      translate_right
      translate_right
    end
  end
  
  def which_gripper?(face)
    fo = face_orientation(face)
    if fo == :r
     MAIN_GRIPPER
    elsif fo == :d
     REAR_GRIPPER
    end 
  end

  def is_in_gripper?(face)
    !!which_gripper?(face)
  end

  def get_to_camera(face)
    if(is_in_camera?(face))
      grip_all
      return
    end
    fo = face_orientation(face)
    if fo == :b 
      translate_left
    elsif fo == :d
      translate_left
      translate_left
    elsif fo == :f
      translate_left
      translate_left
      translate_left
    elsif fo == :r
      translate_right
      translate_left
      translate_left
      translate_left
    elsif fo == :l
      translate_right
      translate_left
    end
  end

  def is_in_camera?(face)
    face_orientation(face) == :u
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
      @orientation[IDX[:f]], #left gets front
      @orientation[IDX[:r]], #front gets right
      @orientation[IDX[:b]], #right gets bacn
      @orientation[IDX[:l]], #back gets left
      @orientation[IDX[:d]], #down stays the same
    ]
    @orientation = new_orientation
    rotate_direction_right
  end
end
