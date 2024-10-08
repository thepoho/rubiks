# SPDX-FileCopyrightText: 2021 ladyada for Adafruit Industries
# SPDX-License-Identifier: MIT

"""
This demo will fill the screen with white, draw a black box on top
and then print Hello World! in the center of the display

This example is for use on (Linux) computers that are using CPython with
Adafruit Blinka to support CircuitPython libraries. CircuitPython does
not support PIL/pillow (python imaging library)!
"""

import sys
import board
import digitalio
from PIL import Image, ImageDraw, ImageFont
import adafruit_ssd1306

# Define the Reset Pin
oled_reset = digitalio.DigitalInOut(board.D4)

# Change these
# to the right size for your display!
WIDTH = 128
HEIGHT = 64  # Change to 64 if needed
BORDER = 5

# Use for I2C.
i2c = board.I2C()  # uses board.SCL and board.SDA
# i2c = board.STEMMA_I2C()  # For using the built-in STEMMA QT connector on a microcontroller
oled = adafruit_ssd1306.SSD1306_I2C(WIDTH, HEIGHT, i2c, addr=0x3C, reset=oled_reset)

# Use for SPI
# spi = board.SPI()
# oled_cs = digitalio.DigitalInOut(board.D5)
# oled_dc = digitalio.DigitalInOut(board.D6)
# oled = adafruit_ssd1306.SSD1306_SPI(WIDTH, HEIGHT, spi, oled_dc, oled_reset, oled_cs)

# Clear display.
oled.fill(0)
oled.show()

# Create blank image for drawing.
# Make sure to create image with mode '1' for 1-bit color.
image = Image.new("1", (oled.width, oled.height))

# Get drawing object to draw on image.
draw = ImageDraw.Draw(image)

# Draw a white background
#draw.rectangle((0, 0, oled.width, oled.height), outline=255, fill=255)

# Draw a smaller inner rectangle
#draw.rectangle(
#    (BORDER, BORDER, oled.width - BORDER - 1, oled.height - BORDER - 1),
#    outline=0,
#    fill=0,
#)

# Load default font.
#font = ImageFont.load_default()
#font = ImageFont.truetype("/home/poho/src/fonts/Roboto-Bold.ttf", 16, encoding="unic")
#font = ImageFont.truetype("/home/poho/src/fonts/Roboto-Regular.ttf", 16, encoding="unic")
font = ImageFont.truetype("/home/poho/src/fonts/RubikMonoOne-Regular.ttf", 12, encoding="unic")

gap = 12
starter = 4
x = 5
# Draw Some Text
idx = 0

#for text in sys.argv
for text in sys.argv[1:]:
  bbox = font.getbbox(text)
  (font_width, font_height) = bbox[2] - bbox[0], bbox[3] - bbox[1]

  y = starter + ((font_height + gap) * idx)
  draw.text((x, y), text, font=font, fill=255,)
  idx += 1
  #draw.text((x, starter), text, font=font, fill=255,)



#text = "> Solve"
#draw.text((x, starter), text, font=font, fill=255,)

#bbox = font.getbbox(text)
#(font_width, font_height) = bbox[2] - bbox[0], bbox[3] - bbox[1]

#text = "  Calibrate"
#y = starter + ((font_height + gap) * 1)
#draw.text((x, y), text, font=font, fill=255,)

#text = "  Shut down"
#y = starter + ((font_height + gap) * 2)
#draw.text((x, y), text, font=font, fill=255,)
#draw.text(
#    (oled.width // 2 - font_width // 2, oled.height // 2 - font_height // 2),
#    text,
#    font=font,
#    fill=255,
#)

# Display image
oled.image(image)
oled.show()

