import sys
#from time import sleep
from adafruit_servokit import ServoKit
kit = ServoKit(channels=16)
kit.servo[int(sys.argv[1])].angle = int(sys.argv[2])
#kit.servo[0].angle = 180
#sleep(2.0)
#kit.servo[0].angle = 0
