# Arduino_Tools for Raspberry

## Beta

Fork of STM32 upload tools for Arduino IDE v2 on raspberry pi os.

To use, start Arduino IDE 2.0.0. From the menu choose *File->Preferences*. In *Additional boards manager URLSs*, add the following url:

 ```https://raw.githubusercontent.com/koendv/BoardManagerFiles/master/package_stmicroelectronics_index.json```

Install the following packages:
```
sudo apt-get install stlink-tools stm32flash dfu-util
```
Optionally install the following package:
```
sudo apt-get install stlink-gui
```
## Compiling the IDE

At this moment, arduino IDE 2.0.0 is in beta. 
To compile the arduino ide on raspberry, type:

```
apt-get install libxkbfile-dev
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
nvm install 12.22.1
npm install --global yarn
git clone https://github.com/arduino/arduino-ide
cd arduino-ide
yarn
yarn rebuild:electron
yarn start
```


