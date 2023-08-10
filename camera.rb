class Camera

  X_OFFSET_START = 450
  X_OFFSET_ADD   = 600

  Y_OFFSET_START = 50
  Y_OFFSET_ADD   = 500

  CROP = 100

  COLOUR_VALUES = {
    blue:   [[0,   10 ], [0,   150], [128, 255]],
    orange: [[225, 255], [85,  155], [0,   64 ]],
    white:  [[128, 255], [170, 255], [170, 255]],
    green:  [[25,  75 ], [128, 255], [0,  75  ]],
    red:    [[100, 255], [0,   50 ], [0,   100]],
    yellow: [[155, 255], [170, 255], [0,   10 ]],
  }

  COLOURS = {
    blue:   [0,0,255],
    orange: [255,128,0],
    white:  [255,255,255],
    green:  [0,255,0],
    red:    [255,0,0],
    yellow: [255,255,0],
  }

  def run
    capture
    crop
    colours
  end

  def capture
    # `libcamera-jpeg -o cache/capture.jpg`
  end

  def crop
    (0..2).each do |x|
      (0..2).each do |y|
        command = "convert cache/capture.jpg -crop #{CROP}x#{CROP}+#{X_OFFSET_START + (x*X_OFFSET_ADD)}+#{Y_OFFSET_START + (y * Y_OFFSET_ADD)} cache/#{x+(3*y)}.jpg"
        # puts command
        `#{command}`
      end
    end
  end

  def colours
    ret = []
    (0..2).each do |x|
      (0..2).each do |y|
        # hex_command = "convert #{x+y}.jpg -resize 1x1 txt:- | tail -n1 | awk '{print $3}'"
        command = "convert cache/#{(3*x)+(y)}.jpg -resize 1x1 txt:- | tail -n1 | awk '{print $2}'"
        # puts command
        str = `#{command}`
        # puts str
        values = str[1..-1].chop.split(",").map &:to_f
        classified = classify(values)
        puts "#{(3*x)+(y)}.jpg, #{values}, #{classified}"
        ret << classified
      end
    end

    ret
  end

  def distance(p1, p2)
    x = p2[0] - p1[0]
    y = p2[1] - p1[1]
    z = p2[2] - p1[2]
    Math.sqrt((x*x) + (y*y) + (z*z))
  end

  def classify(colour)
    found = 9999999
    ret   = :unknown
    COLOURS.each do |k,v|
      dist = distance(colour, v)
      if dist < found
        ret = k
        found = dist
      end
    end
    ret
  end

  def classify_old(colour)
    r,g,b = colour
    ret = :unknown
    COLOUR_VALUES.each do |k,v|
      next unless r > v[0][0] && r < v[0][1]
      next unless g > v[1][0] && g < v[1][1]
      next unless b > v[2][0] && b < v[2][1]
      return k
    end
    ret
  end

  def cleanup
    # `rm -f 1.jpg 2.jpg 3.jpg 4.jpg 5.jpg 6.jpg 7.jpg 8.jpg 9.jpg colours.txt`
  end
end
Camera.new.run
