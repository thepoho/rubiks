# External module imports
import RPi.GPIO as GPIO
import time

# Pin Definitons(broadcom for python):
pinOne   = 17 
pinTwo   = 27 
pinThree = 22 


# Pin Setup:
GPIO.setmode(GPIO.BCM) # Broadcom pin-numbering scheme
GPIO.setup(pinOne,   GPIO.IN, pull_up_down=GPIO.PUD_UP) # Button pin set as input w/ pull-up
GPIO.setup(pinTwo,   GPIO.IN, pull_up_down=GPIO.PUD_UP) # Button pin set as input w/ pull-up
GPIO.setup(pinThree, GPIO.IN, pull_up_down=GPIO.PUD_UP) # Button pin set as input w/ pull-up

# Initial state for LEDs:

print("Here we go! Press CTRL+C to exit")
try:
    while 1:
        if( GPIO.input(pinOne) == False): 
            print("pressed")
        else: # button is pressed:
            print("released")
        time.sleep(1)

except KeyboardInterrupt: # If CTRL+C is pressed, exit cleanly:
    GPIO.cleanup() # cleanup all GPIO

