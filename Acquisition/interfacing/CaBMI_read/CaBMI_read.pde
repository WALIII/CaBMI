/*
   ===========================================
   |           CaBMI  ABA  Rig              |
   ===========================================

 c: 11.21.2015
 by: WALIII

*/


import processing.serial.*;
Serial myPort; 
int spacer = 0;
String[] N = { "Pls", "work" ,"Mkay?"}; 
String[] TXT = {"","",""};
long[] currentMillis = {millis(),millis(),millis()};
long[] previousMillis = {0,0,0};
float[] timer = {0,0,0};
float[] BOX_VAL = { 1,1,1 }; 
float offset = 0;
void setup()
{
    size(410, 600, P3D);
  String portName = Serial.list()[1];


myPort = new Serial(this, portName, 9600); //set up your port to listen to the serial port
}


void serialEvent(Serial myPort){
  try {
 String val = myPort.readStringUntil('\n'); //The newline separator separates each Arduino loop. 
   if (val!= null) { 
    val = trim(val); //gets rid of any whitespace or Unicode nonbreakable space
    println(val); //Optional, useful for debugging. 
    float sensorVals[] = float(split(val, ',')); //parses the packet from Arduino and places the valeus into the sensorVals 

   
BOX_VAL[0] = sensorVals[0];
BOX_VAL[1] = sensorVals[1];
BOX_VAL[2] = sensorVals[2];
}}
  catch(RuntimeException e) {
    //e.printStackTrace();
  }
}



void draw()
{

CaBMI_draw();
}

void stop() {
  // Clear the buffer, or available() will still be > 0
      myPort.clear();
      // Close the port
  myPort.stop();
  super.stop();
}