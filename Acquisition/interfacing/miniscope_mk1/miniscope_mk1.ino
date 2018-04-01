/*
===============================================================================
                      CaBMI Miniscope/Macroscope script
===============================================================================

WAL3
d03.26.18

*/

#include "pitches.h"

// Define analog pin
int sensorPin = 0;
long count = 0; //how many itterations over thresh
int counter = 0; // total Timeouts
int counter1 = 0;
int swtch = 1;
// Setup

// Smoothing factor
const int numReadings = 100; // running average of background...
const int numReadings2 = 5; // smooth incoming aquisition by 5 frames


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

  int s1 = (analogRead(sensorPin)-512); // take the difference of the voltage


  // subtract the last reading:
  total = total - readings[readIndex];
  total2 = total2 - readings2[readIndex2];

  // read from the sensor:
  readings[readIndex] = s1;
  readings2[readIndex2] = s1;

  // add the reading to the total:
  total = total + readings[readIndex];
  total2 = total2 + readings2[readIndex2];

  // advance to the next position in the array:
  readIndex = readIndex + 1;
  readIndex2 = readIndex2 + 1;


  // if we're at the end of the array...
  if (readIndex2 >= numReadings2) {
    // ...wrap around to the beginning:
    readIndex2 = 0;
  };
  if (readIndex >= numReadings) {
    // ...wrap around to the beginning:
    readIndex = 0;
  };


// calculate the average:
  average = total / numReadings;
  average2 = total2 / numReadings2;


// Calculate auditory cursor
int OUT = 5000- (average2-average)*1000;


// Send data out to serial

// Auditory Cursor

tone(8, OUT, 100);



// Track cursor
if (swtch == 0){
if (OUT > 10000) {
  digitalWrite(3, HIGH);
  count = count + 1;
  int swtch = 1;
  int status =1;
}}
else if (swtch == 1){
  if (OUT < 6000){
  int  swtch = 0;
  int status = 0;
  }
  else{
    int status = -1;
    // Do nothing.. need to reset
  }}


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


// Serial Communication: print and save data

    Serial.print((analogRead(sensorPin)));
      Serial.print(",");
      Serial.print(OUT);
      Serial.print(",");
      Serial.print(test235
      yyy);
      Serial.print(",");
      Serial.print(average2-average);
      Serial.println(",");







  delay(100);
  // stop the tone playing:
  noTone(8);
  digitalWrite(3, LOW);





}
