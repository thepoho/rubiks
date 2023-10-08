class Utilities

  def self.get_solve_string(scramble)
    ret = `bin/kociemba #{scramble}`
    ret = ret.rstrip
    ret.gsub("1\n2\n3\n","").downcase
  end

  def self.print_colours(colours)
    str = ""
    colours.each_with_index do |x, idx|
      str += self.send(x)
      str += self.send(x)
      str += " "
      if (idx+1)%3 == 0
        puts str
        puts str
        puts " "
        str = ""
      end
    end
  end
  def self.red;         "\e[41m \e[0m" end
  def self.green;       "\e[42m \e[0m" end
  def self.orange;      "\e[45m \e[0m" end
  def self.yellow;      "\e[43m \e[0m" end
  def self.blue;        "\e[44m \e[0m" end
  def self.white;       "\e[47m \e[0m" end

  def self.c_to_r(arr)
    translations = {
      white:  'u',
      orange: 'f',
      yellow: 'd',
      blue:   'l',
      green:  'r',
      red:    'b'
    }
    arr.map{|x| translations[x]}
  end

  def self.rotate_array(arr)
    # rotates 3x3  array 90 degrees clockwise
   [
     [arr[2][0],arr[1][0],arr[0][0]],
     [arr[2][1],arr[1][1],arr[0][1]],
     [arr[2][2],arr[1][2],arr[0][2]],
   ] 
  end
end

