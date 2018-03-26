/*
CaBMI alpha script

WAL3

d03.26.18

*/


#include "pitches.h"

// Define analog pin
int sensorPin = 0;
long count = 0; //how many itterations over thresh
int counter = 0; // total Timeouts
int counter1 = 0;
// Setup

// df/f
const int numReadings = 100;
const int numReadings2 = 5; // smooth by 5 frames


// For bgnd
int readings[numReadings];      // the readings from the analog input
int readIndex = 0;              // the index of the current reading
int total = 0;                  // the running total
int average = 0;                // the average

// for ROI
int readings2[numReadings2];      // the readings from the analog input
int readIndex2 = 0;              // the index of the current reading
int total2 = 0;                  // the running total
int average2 = 0;                // the average


void setup() {
  // Init serial
  Serial.begin(9600);
 
  // initialize all the readings to 0:
  for (int thisReading = 0; thisReading < numReadings; thisReading++) {
    readings[thisReading] = 0;
  }

    for (int thisReading2 = 0; thisReading2 < numReadings2; thisReading2++) {
    readings2[thisReading2] = 0;
  }
  
}

// Main loop
void loop() {

  int s1 = (analogRead(sensorPin)-512);

    // subtract the last reading:
  total2 = total2 - readings2[readIndex2];
  // read from the sensor:
  readings2[readIndex2] = s1;
  // add the reading to the total:
  total2 = total2 + readings2[readIndex2];
  // advance to the next position in the array:
  readIndex2 = readIndex2 + 1;

  // if we're at the end of the array...
  if (readIndex2 >= numReadings2) {
    // ...wrap around to the beginning:
    readIndex2 = 0;
  };

// calculate the average:
  
// calculate the average:
  average2 = total2 / numReadings2;
  // send it to the computer as ASCII digits




  
    // subtract the last reading:
  total = total - readings[readIndex];
  // read from the sensor:
  readings[readIndex] = s1;
  // add the reading to the total:
  total = total + readings[readIndex];
  // advance to the next position in the array:
  readIndex = readIndex + 1;

  // if we're at the end of the array...
  if (readIndex >= numReadings) {
    // ...wrap around to the beginning:
    readIndex = 0;
  };

  

  

  // calculate the average:
  
// calculate the average:
  average = total / numReadings;
  // send it to the computer as ASCII digits


  
int OUT = 5000- (average2-average)*1000;

  Serial.print((analogRead(sensorPin)));
      Serial.print(",");
    Serial.print(average2);
    Serial.print(",");
    Serial.print(average);
  Serial.print(",");
    Serial.print(average2-average);
  Serial.print(",");
  Serial.print(OUT);
  Serial.println(",");


  // Auditory Cursor
  tone(8, OUT, 100);

  // Track cursor
  if (OUT > 10000) {
    digitalWrite(3, HIGH);
    count = count + 1;
  }
  else if (OUT < 3500 && count > 0) {
    count = count - 1;
  }

  delay(100);
  // stop the tone playing:
  noTone(8);
  digitalWrite(3, LOW);



  // Serial Communication: print and save data





  // Timeout
  if (count > 10) {
    digitalWrite(2, HIGH);
    delay(2000);
    digitalWrite(2, LOW);
    count = 0;
    counter = counter + 1;
  }
  delay(1);

  counter1 = counter1 + 1;
}



