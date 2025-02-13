class Camera

  X_OFFSET_START = 500
  X_OFFSET_ADD   = 600

  Y_OFFSET_START = 50
  Y_OFFSET_ADD   = 500

  CROP = 100

  #COLOUR_VALUES = {
  #  blue:   [[0,   10 ], [0,   150], [128, 255]],
  #  orange: [[225, 255], [85,  155], [0,   64 ]],
  #  white:  [[128, 255], [170, 255], [170, 255]],
  #  green:  [[25,  75 ], [128, 255], [0,  75  ]],
  #  red:    [[100, 255], [0,   50 ], [0,   100]],
  #  yellow: [[155, 255], [170, 255], [0,   10 ]],
  #}

  COLOURS_OLD = {
  white:  [109, 104, 102],
  red:    [88, 2, 0],
  yellow: [135, 129, 0],
  orange: [164, 34, 1],
  blue:   [0, 14, 57],
  green:  [13, 72, 4],
  }

  #COLOURS = YAML.load_file('colours.yml')

  BRIGHTNESS_LOWER = 65
  BRIGHTNESS_UPPER = 80

  @colours = {}
  @shutter = 5_000

  def set_colours(data)
    @colours = data
    @shutter = data[:shutter]
  end

  def show_colours
    @colours
  end

  def run(cp: nil)
    #puts "not capturing camera"
    capture(shutter: @shutter, cp: cp)
    crop(cp: cp)
    colours(cp: cp)
  end

  def get_averages(face)
    colour =  Robot.face_to_colour(face)
    puts "Face is #{face}, colour is #{colour}"
    capture(shutter: @shutter, cp: "cal_#{colour}")
    crop(colour)
    colours(calibrating: true)
  end
  
  def calibrate_shutter

    return
    brightness = -1
    @shutter = 30_000
    loops = 0
    loop do
      filename = "calibration.jpg"
      capture(shutter: @shutter, filename: filename)
      brightness = get_image_brightness(filename)
      puts "Shutter: #{@shutter}, brightness: #{brightness}"
      break if brightness >= BRIGHTNESS_LOWER && brightness <= BRIGHTNESS_UPPER
      if brightness < BRIGHTNESS_LOWER
        @shutter += 5_000
      else
        @shutter -= 1_000
      end
      loops += 1
      if loops > 25
        puts "Failed to get brightness"
        exit
      end
    end
    puts "Shutter is #{@shutter}"
    @shutter
  end

  def capture(shutter: 5000, gain: 0.5, filename: 'capture.jpg', cp: nil)
    gain = 9
    #`libcamera-jpeg -n -t1 -o cache/capture.jpg`
    #`python3 ~/src/rubiks/lib/led.py 1`
    cmd = "libcamera-still  --shutter #{shutter} --awb indoor --gain #{gain}  --immediate -o cache/#{filename}"
    cmd = "libcamera-still --awb indoor --immediate -o cache/#{filename}"
    cmd = "libcamera-still --awb indoor --immediate --saturation 0.4 -o cache/#{filename}"
    `#{cmd}`
    puts cmd
    if cp
      `cp cache/#{filename} cache/#{cp}.jpg`
    end
    #`python3 ~/src/rubiks/lib/led.py 0`
  end

  def get_image_brightness(image)
    command = "convert cache/#{image} -colorspace hsb -resize 1x1 txt:- | tail -n1 | awk '{print $2}'"
    str = `#{command}`
    #(60.1895,56.0891%,3.89258%)
    str[1..-1].chop.split(",").last.gsub("%","").to_f
  end

  def get_image_average(image)
    command = "convert cache/#{image} -resize 1x1 txt:- | tail -n1 | awk '{print $2}'"
    str = `#{command}`
    values = str[1..-1].chop.split(",").map &:to_f
  end

  def crop(colour = nil, cp: nil)
    (0..2).each do |x|
      (0..2).each do |y|
        command = "convert cache/capture.jpg -crop #{CROP}x#{CROP}+#{X_OFFSET_START + (x*X_OFFSET_ADD)}+#{Y_OFFSET_START + (y * Y_OFFSET_ADD)} cache/#{x+(3*y)}.jpg"
        `#{command}`
        if colour
          `cp cache/#{x+(3*y)}.jpg cache/face_#{colour}_#{x+(3*y)}.jpg`
        end
        if cp
          `cp cache/#{x+(3*y)}.jpg cache/#{cp}_#{x+(3*y)}.jpg`
        end
      end
    end
  end

  def colours(calibrating: false, cp: nil)
    all = []
    ret = []
    (0..2).each do |x|
      (0..2).each do |y|
        num = (3*x)+(y)
        command = "convert cache/#{num}.jpg -resize 1x1 txt:- | tail -n1 | awk '{print $2}'"
        str = `#{command}`
        values = str[1..-1].chop.split(",").map &:to_f
        if calibrating
          all[num] = values
        else
          classified = classify(num, values)
        end
        txt =  "#{(3*x)+(y)}.jpg, #{values}, #{classified || nil}"
        puts txt
        File.open('debug.log','a') {|f| f.puts txt}
        #if cp
        #  `cp cache/#{num}.jpg cache/#{cp}_1x1_#{num}.jpg`
        #end
        ret << classified
      end
    end
    pp all
    return all if calibrating
    ret
  end

  def distance(p1, p2)
    x = p2[0] - p1[0]
    y = p2[1] - p1[1]
    z = p2[2] - p1[2]
    Math.sqrt((x*x) + (y*y) + (z*z))
  end

  def classify(pos, rgb)
    found = 9999999
    ret   = :unknown
    @colours.each do |k,v|
      next if k == :shutter
      dist = distance(rgb, v[pos])
      if dist < found
        ret = k
        found = dist
      end
    end
    ret
  end

#  def classify_old(colour)
#    r,g,b = colour
#    ret = :unknown
#    COLOUR_VALUES.each do |k,v|
#      next unless r > v[0][0] && r < v[0][1]
#      next unless g > v[1][0] && g < v[1][1]
#      next unless b > v[2][0] && b < v[2][1]
#      return k
#    end
#    ret
#  end

  def cleanup
    # `rm -f 1.jpg 2.jpg 3.jpg 4.jpg 5.jpg 6.jpg 7.jpg 8.jpg 9.jpg colours.txt`
  end
end
