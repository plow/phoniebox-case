#phoniebox-case
An OpenSCAD model for wooden [Phoniebox](http://phoniebox.de/) cases.

![alt text][logo]
[logo]: out.png "Logo Title Text 2"

## Install OpenSCAD
Install it on your OS according to [the instructions on the OpenSCAD website](http://www.openscad.org/downloads.html).


## Analyze the Model and Retrieve Case Part List

Use the following command to see and adjust the model in the OpenSCAD GUI:
```
openscad phoniebox_case.scad
```

Execute the following command to retrieve a list of case parts along with their dimensions:
```
openscad -o out.png phoniebox_case.scad
```

You can filter the list of parts with `grep -A 1`, e.g.:
```
openscad -o out.png phoniebox_case.scad 2>&1 | grep -A 1 WALL_RETAINER
```

## About Phoniebox
A Phoniebox is an audio player software that runs on a Raspberry Pi. It can be used entierly with RFID tags, however physical buttons are supported as well. See the following websites for further information:

* [Official Phoniebox Website](http://phoniebox.de/)
* [Phoniebox Opensource Project on Github](https://github.com/MiczFlor/RPi-Jukebox-RFID)