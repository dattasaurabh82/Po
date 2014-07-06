#include <Servo.h>

Servo pan;
//Servo tilt;
int panpos = 90;
//int tiltpos = 50;

void setup() 
{
  pan.attach(9);
  //tilt.attach(9);
  Serial.begin(19200);	// opens serial port, sets data rate to 9600 bps
  //Serial.println("ready");
 
}

void loop() 
{
 
  if (Serial.available() > 0) 
  {
    int data = Serial.read();	 // read the incoming byte:
    switch(data)
    {
	case 'd' :  if(panpos > 0) {panpos -=1;};  break;
        case 'a' :  if(panpos < 180) {panpos += 1;}; break;
        //case 'w' :  if(tiltpos > 0) {tiltpos -=1;}; break;
        //case 's' :  if(tiltpos < 180) {tiltpos += 1;};  break;
        default  : break;
    }
  }
  pan.write(panpos);
  //tilt.write(tiltpos);
}  

