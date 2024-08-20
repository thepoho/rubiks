# rubiks by poho

## To run
1. Put the cube in with white facing camera, orange facing you
1. `ruby calibrate.rb`
1. `ruby main.rb`

## Prerequisites
```
sudo apt-get update
sudo apt install -y libyaml-dev gcc git libssl-dev make zlib1g-dev imagemagick i2c-tools python3-pip
sudo pip3 install adafruit-circuitpython-servokit

```

## Debug Mode

Start an `irb` console and use
```
load("robot.rb") && r = Robot.new
```

Then can use
```
r.uga #un-grip all
r.lga #loose-grip all
r.ga  #grip-all

# full commanhd listing in robot_mover_module
  alias_method :rdl, :rotate_direction_left
  alias_method :rdr, :rotate_direction_right
  alias_method :tfl, :twist_face_left
  alias_method :tfr, :twist_face_right
  alias_method :uga, :ungrip_all
  alias_method :ga,  :grip_all
  alias_method :lga, :loose_grip_all
  alias_method :lgl, :loose_grip_left
  alias_method :lgr, :loose_grip_right
  alias_method :ugl, :ungrip_left
  alias_method :gl,  :grip_left
  alias_method :ugr, :ungrip_right
  alias_method :gr,  :grip_right
  alias_method :tr,  :twist_right
  alias_method :utr, :untwist_right
  alias_method :tl,  :twist_left
  alias_method :utl, :untwist_left


```
## Ruby 3.2.2
```
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo 'eval "$(~/.rbenv/bin/rbenv init - bash)"' >> ~/.bashrc #ubuntu
echo 'eval "$(~/.rbenv/bin/rbenv init - bash)"' >> ~/.bash_profile #others
git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build
rbenv install 3.2.2
```

##Kociemba solver.
Clone python version
https://github.com/muodov/kociemba
in `kociemba/ckociemba` run `make` and you'll have a binary to call in the bin dir

## Camera
```
libcamera-hello --tuning-file /usr/share/libcamera/ipa/raspberrypi/ov5647.json
libcamera-jpeg -o test.jpg
 ```


## ImageMagick
```
libcamera-jpeg -o test.jpg
rm -f 1.jpg 2.jpg 3.jpg 4.jpg 5.jpg 6.jpg 7.jpg 8.jpg 9.jpg colours.txt

convert test.jpg -crop 300x300+700+90   1.jpg
convert test.jpg -crop 300x300+1200+90  2.jpg
convert test.jpg -crop 300x300+1800+90  3.jpg

convert test.jpg -crop 300x300+700+600   4.jpg
convert test.jpg -crop 300x300+1200+600  5.jpg
convert test.jpg -crop 300x300+1800+600  6.jpg

convert test.jpg -crop 300x300+700+1200   7.jpg
convert test.jpg -crop 300x300+1200+1200  8.jpg
convert test.jpg -crop 300x300+1800+1200  9.jpg


convert 1.jpg -resize 1x1 txt:- | tail -n1 | awk '{print $3}' >> colours.txt
convert 1.jpg -resize 1x1 txt:- | tail -n1 | awk '{print $2}' >> colours.txt
convert 2.jpg -resize 1x1 txt:- | tail -n1 | awk '{print $3}' >> colours.txt
convert 2.jpg -resize 1x1 txt:- | tail -n1 | awk '{print $2}' >> colours.txt
convert 3.jpg -resize 1x1 txt:- | tail -n1 | awk '{print $3}' >> colours.txt
convert 3.jpg -resize 1x1 txt:- | tail -n1 | awk '{print $2}' >> colours.txt

convert 4.jpg -resize 1x1 txt:- | tail -n1 | awk '{print $3}' >> colours.txt
convert 4.jpg -resize 1x1 txt:- | tail -n1 | awk '{print $2}' >> colours.txt
convert 5.jpg -resize 1x1 txt:- | tail -n1 | awk '{print $3}' >> colours.txt
convert 5.jpg -resize 1x1 txt:- | tail -n1 | awk '{print $2}' >> colours.txt
convert 6.jpg -resize 1x1 txt:- | tail -n1 | awk '{print $3}' >> colours.txt
convert 6.jpg -resize 1x1 txt:- | tail -n1 | awk '{print $2}' >> colours.txt

convert 7.jpg -resize 1x1 txt:- | tail -n1 | awk '{print $3}' >> colours.txt
convert 7.jpg -resize 1x1 txt:- | tail -n1 | awk '{print $2}' >> colours.txt
convert 8.jpg -resize 1x1 txt:- | tail -n1 | awk '{print $3}' >> colours.txt
convert 8.jpg -resize 1x1 txt:- | tail -n1 | awk '{print $2}' >> colours.txt
convert 9.jpg -resize 1x1 txt:- | tail -n1 | awk '{print $3}' >> colours.txt
convert 9.jpg -resize 1x1 txt:- | tail -n1 | awk '{print $2}' >> colours.txt

```
