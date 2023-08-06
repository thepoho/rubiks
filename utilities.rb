class Utilities

  def self.get_solve_string(scramble)
    `bin/kociemba #{scramble}`
  end
end
