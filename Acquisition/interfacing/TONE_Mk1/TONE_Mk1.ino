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
// Setup
void setup() {
 // Init serial
 Serial.begin(9600);
}

// Main loop
void loop() {


// ROI input ( one for now)
 int melody = 5000-(analogRead(sensorPin)^2)*3;

// Auditory Cursor  
tone(8, melody, 100);

// Track cursor
if (melody > 5500){
  digitalWrite(3, HIGH);
count = count+1;}
else if (melody < 3500 && count > 0){
  count = count-1;
}

    delay(100);
    // stop the tone playing:
    noTone(8);
    digitalWrite(3, LOW); 



// Serial Communication: print and save data
 Serial.print(count);
  Serial.print(",");
  Serial.print(melody);
   Serial.print(",");
   Serial.println(counter);


// Timeout
    if (count > 10){
      digitalWrite(2, HIGH);
      delay(2000);
      digitalWrite(2, LOW);
      count = 0;
      counter = counter+1;
    }
    delay(5);
  }



