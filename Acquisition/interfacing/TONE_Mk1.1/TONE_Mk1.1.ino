/*
CaBMI alpha script 

WAL3

d11.21.17

*/

#include "pitches.h"

// Define analog pin
int sensorPin = 0;
long count = 0; //how many itterations over thresh
int counter = 0; // total Timeouts
unsigned long previousMillis = 0;        // will store last time LED was updated
const long interval = 1000;  

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


// ROI input ( one for now)

   
   if(Serial.available()>0) // if there is data to read
   {
   int  melody=Serial.read(); // read data
   
   
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

   
   melody = melody*1000;
tone(10, melody, 1000);
digitalWrite(7, HIGH); //TTL sync
delay(100);
noTone(10);
digitalWrite(7, LOW);
   }
}
    


//
//
//// Auditory Cursor  
//tone(8, melody, 100);
//
//// Track cursor
//if (melody > 3500){
//  digitalWrite(3, HIGH);
//count = count+1;}
//else if (melody < 3500 && count > 0){
//  count = count-1;
//}
//
//    delay(100);
//    // stop the tone playing:
//    noTone(8);
//    digitalWrite(3, LOW); 
//
//
//
//// Serial Communication: print and save data
// Serial.print(count);
//  Serial.print(",");
//  Serial.print(melody);
//   Serial.print(",");
//   Serial.println(counter);
//
//
//// Timeout
//    if (count > 10){
//      digitalWrite(2, HIGH);
//      delay(2000);
//      digitalWrite(2, LOW);
//      count = 0;
//      counter = counter+1;
//    }
//    delay(50);
//  }



