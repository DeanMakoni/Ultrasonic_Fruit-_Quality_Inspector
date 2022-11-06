#include <Wire.h>
#define SLAVE_ADDRESS 0x08
byte data_to_echo = 0;
#include <PWM.h>

//use pin 11 on the Mega instead, otherwise there is a frequency cap at 31 Hz
int led = 9;                // the pin that the LED is attached to
int brightness = 0;         // how bright the LED is
int fadeAmount = 5;         // how many points to fade the LED by
int32_t frequency = 35; //frequency (in Hz)
unsigned long starttime;
unsigned long endtime;

void setup() 
{
  Wire.begin(SLAVE_ADDRESS);
  Wire.onReceive(receiveEvent);
  Wire.onRequest(sendData);

  InitTimersSafe(); 

  //sets the frequency for the specified pin
  bool success = SetPinFrequencySafe(led, frequency);
  
  //if the pin frequency was set successfully, turn pin 13 on
  if(success) {
    pinMode(13, OUTPUT);
    digitalWrite(13, HIGH);    
  }
}
void loop() { }
void receiveData(int bytecount)
{
  for (int i = 0; i < bytecount; i++) {
    data_to_echo = Wire.read();
  }
}
void sendData()
{
  Wire.write(data_to_echo);
}

void receiveEvent(int howMany) {

  starttime = millis();
  endtime = starttime;

  while ((endtime - starttime) <=1000) { // loop through all but the last
    //char c = Wire.read(); // receive byte as a character
    //digitalWrite(ledPin, c);
     //use this functions instead of analogWrite on 'initialized' pins
  pwmWrite(led, brightness);

  brightness = brightness + fadeAmount;

  if (brightness == 0 || brightness == 255) {
    fadeAmount = -fadeAmount ; 
  }     
   //delay(30);
  //exit(0);
  endtime = millis();
  }
  exit(0);
}
