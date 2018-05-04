/*
CaBMI alpha script

WAL3

d11.21.17

*/

#include "pitches.h"
String readString, servo1, servo2;
// Define analog pin
int sensorPin = 0;
long count = 0; //how many itterations over thresh
int counter = 0; // total Timeouts
      int n1; //declare as number
      int n2;
unsigned long currentMillis = millis();
int melody;
unsigned long previousMillis = 0;        // will store last time LED was updated

int t1 = 0;


// Setup
void setup() {

 // Init serial
pinMode(10,OUTPUT);
pinMode(7,OUTPUT);
pinMode(5,OUTPUT);
pinMode(9,OUTPUT);

  Serial.begin(9600);

}


// Main loop
void loop() {

currentMillis = millis();
// ROI input ( one for now)

  while (Serial.available()) {
    delay(4);
    if (Serial.available() >0) {
      char c = Serial.read();  //gets one byte from serial buffer
      readString += c; //makes the string readString
    }
  }

  if (readString.length() >0) {

      // expect a string like 07002100 containing the two servo positions
      servo1 = readString.substring(0, 3); //get the first four characters
      servo2 = readString.substring(3, 6); //get the next four characters




      char carray1[4]; //magic needed to convert string to a number
      servo1.toCharArray(carray1, sizeof(carray1));
      n1 = atoi(carray1);

      char carray2[4];
      servo2.toCharArray(carray2, sizeof(carray2));
      n2 = atoi(carray2);

melody = n1;
int beat = n2;
    readString="";





   // send Reward TTL
   if (melody == 99){
   int currentMillis = millis();
    digitalWrite(9, HIGH);
delay(100);
    digitalWrite(9, LOW);
   }

   // Aquisition Begin!
      if (melody == 98){
   int currentMillis = millis();
    digitalWrite(5, HIGH);
delay(100);
    digitalWrite(5, LOW);
   }


   melody = melody*10;
   int V = 40+round(beat*.5);
   if (t1 == 0) {
    tone(10, melody, 100);
    digitalWrite(7, HIGH); //TTL sync
   t1 = 1;
   }

 if (currentMillis - previousMillis >= V & t1 == 1){
     previousMillis = currentMillis;
digitalWrite(7, LOW);
noTone(10);
t1 =0; }

//
delay(1);
   }}


//}
