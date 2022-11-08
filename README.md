# Ultrasonic_Fruit-_Quality_Inspector

This is the officila Git Rrepository for the ulltrasound fruit quality inspector framework. The tutorial on how to use the framework can be found below. 

A.1 Tutorial on how to use the framework

This tutorial explains how the ultrasound fruit quality inspector can be used. The framework can be found on the GitHub repository of this research -git.

A.1.1 Step 1 -Cloning

Clone the framework into your local PC or Raspberry Pi Zero. The repository is made up of four directories that are API directory, bin directors, source directory and data directory.

A.1.2 Step 2 -Installations

Dowload / install the following software if you don’t have them on your PC/Raspberry Pi. 1. Putty 2. Arduino skecth. 3. Teensyduino 4. Winscp 5. Jupyter Notebook 5. Create a Postman account(it is free)
77

A.1.3 Step 3 - Connecting the hardware

For coonecting the hardware you need jumper wires. To coonect the hardware circuits you can follow the detailed schematic ciruits that were give in the design section.

A.1.4 Step 4 - Data acquisition using Teensy 3.6

Data acquisition using Teensy 3.6 is done manually it is not intergrated into the API. Follow instruction on the Teensy official websote on how to use Teensy with Arduino skecth. Once all is perfectly set open the Teensyserver.ino in the src directory. Verify the code and upload it on Teensy 3.6. Open the serial port and change the board rate to COM Teensy and the board to Teensy 3.6. The image below shows how to upload the code on Teensy 3.6.
Figure A.1: The Simulation Results of a band pass filter in LtSpice
Follow the instruction on the console of the software to start sampling. Copy the output of the console to a textfile and use the data processing jupyter notebook to process the recived echo into a csv file that is ready for further data processing.

A.1.5 Step 5 Data acquisition using Raspberry Pi

The data acquisition using raspberry pi can be done using the API. Make sure that you have your Postman account all set. Start the server on the pi using node server.js commands. The local server is going to be start on your Rasberry Pi.
78

A.1.6 Step 6 Working with the API

To run the server you can either use the terminal or the Postman API. The node.js is running bashfiles, so make sure before starting requests you go tho the API directory under the route directory and put the correct directories of the bash files that are being used by the API to communicate with the local host. An example of the command that is used to run the bashfile. curl -i -H ”Accept: application/json” -X GET ’http://raspberrypi.local:8484/instructions/sample’
if you are using the postman replace sample with the Raspberry Pi IP address. All other resources that were shown in the resource structure in design can be requested using the same method as above. To make the Raspberry Pi to communicate with the PC that has other functions you are supposed to start the client’s server( run this command server.js on your PC terminal- assuming you are using Linux) Once the client is listening you can use the API to sample, to do data processing and to do image recontrsution on the PC. The API has the following commands that it is using : GET,PUT, POST,DELETE and HEAD. To add a new command follow the instructions that were described in the design
