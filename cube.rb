class Cube
  # Orientations/faces  Facing camera is F
  # U R F L D B R

  @cube_state = ''
  @orientation = 'F'

  def initialise(cube_state)
    @cube_state = cube_state
  end
end
