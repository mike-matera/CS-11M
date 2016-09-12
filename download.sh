#! /bin/bash

if [ -z "$1" ]; then 
    echo "usage: $0 <file.hex>"
    echo "You must specify a file to download."
    exit 1
fi

if [ \! -f "$1" ]; then 
    echo "usage: $0 <file.hex>"
    echo "I can't find the file you gave me."
    exit 1
fi

host=`uname`
if [ $host == "Darwin" ]; then
  echo "Using the OSX version"
  arduino_install=/Applications/Arduino.app/Contents/Java
  avrdude=$arduino_install/hardware/tools/avr/bin/avrdude
  avrdude_conf=$arduino_install/hardware/tools/avr/etc/avrdude.conf
  arduino_conf=~/Library/Arduino15/preferences.txt
else 
  echo "Using the Linux version"
  # Try to find the Arduino installation. 
  arduino=`which arduino`
  if [ -z $arduino ]; then 
    echo "I can't find the Arduino program, please put it in your path."
    exit 2
  fi
  echo "Found Arduino in $arduino"

  # Try to locate AVRDude. 
  arduino_root=`dirname $arduino`

  # It might be in the Arduino installation dirctory
  avrdude="$arduino_root/hardware/tools/avr/bin/avrdude"
  avrdude_conf="$arduino_root/hardware/tools/avr/etc/avrdude.conf"

  if [ \! -x $avrdude ]; then 
    # See if it's in the path. 
    avrdude=`which avrdude`
    avrdude_conf="/etc/avrdude.conf"
  fi 

  # Try to locate Arduino's preferences.
  arduino_conf=~/.arduino15/preferences.txt 
fi

if [ \! -x $avrdude ]; then
  echo "I can't find the AVRDude program."
  exit 3
fi
echo "Found AVRDude in $avrdude"

if [ \! -f $avrdude_conf ]; then
  echo "I can't find the AVRDude configuration."
  exit 4
fi
echo "Found AVRDude configuration in $avrdude_conf"

if [ \! -f $arduino_conf ]; then
  echo "I can't find Arduino's configuration file."
  exit 5
fi
echo "Found Arduino's configuration in $arduino_conf"

serial=$(grep serial.port= $arduino_conf | sed 's/.*=\(.*\)/\1/')
arch=atmega328p

echo "Serial port: $serial"
echo "Processor: $arch"

cmd="$avrdude -C$avrdude_conf -v -p$arch -carduino -P$serial -b115200 -D -Uflash:w:$1:i"
echo "Running command: $cmd"
$cmd
