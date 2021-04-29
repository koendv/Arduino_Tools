# Arduino_Tools for Raspberry

## Beta

Fork of STM32 upload tools for Arduino IDE v2 on raspberry pi os.

To use, install the following packages:
```
sudo apt-get install stlink-tools stm32flash dfu-util
```
Optionally install the following package:
```
sudo apt-get install stlink-gui
```

Start Arduino IDE 2.0.0. From the menu choose *File->Preferences*. In *Additional boards manager URLSs*, add the following url:

 ```https://raw.githubusercontent.com/koendv/BoardManagerFiles/master/package_stmicroelectronics_index.json```


## Compiling the IDE

 Binaries of arduino IDE 2.0.0 for raspberry can be downloaded [here](https://github.com/koendv/arduino-ide-raspberrypi). 