/*
  CaBMI alpha script
  WAL3
  d07.15.20
  undated 06/24/2020
*/

#include "pitches.h"

// Define analog pin
int sensorPin = 0;
long count = 0; //how many itterations over thresh
int counter = 0; // total Timeouts
unsigned long previousMillis = 0;        // will store last time LED was updated
const long interval = 1000;
int REWARD = 0;
int reward_interval = 50; //  will need to be calibrated
int TS1 = 0;
int TS2 = 0;
int PlayTone = 0;

// Setup
void setup() {
  // Init serial
  pinMode(10, OUTPUT); // Tone
  pinMode(7, OUTPUT); // TTL sync
  pinMode(5, OUTPUT); // Aquisition trigger
  pinMode(9, OUTPUT); // Water reward

  Serial.begin(9600);
}


// Main loop
void loop() {


  // ROI input ( one for now)
  int currentMillis = millis();


  if (Serial.available() > 0) // if there is data to read
  {
    int  melody = Serial.read(); // read data


    // send Reward TTL
    if (melody == 171) {
      TS1 = millis();
      REWARD = 1;
      digitalWrite(9, HIGH);
      digitalWrite(7, HIGH);
    }

    if (REWARD == 1 && currentMillis - TS1 >= reward_interval) {
      digitalWrite(9, LOW);
      digitalWrite(7, LOW);
      REWARD = 0;
    }

    // Aquisition Begin!
    if (melody == 170) {
      int currentMillis = millis();
      digitalWrite(5, HIGH);
      delay(100);
      digitalWrite(5, LOW);
    }


    melody = melody*100;
    // Play Tone ( with delay)
    tone(10, melody, 30);
    
    
    delay(30);
    noTone(10);


//    // Play tone ( no Delay) 
//    tone(10, melody, 32);
//    if (PlayTone == 0) {
//      PlayTone = 1;
//      TS2 = millis();
//    }
//
//    if (PlayTone == 1 && currentMillis - TS2 >= 32) {
//      PlayTone = 0;
//      noTone(10);
//    }


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
