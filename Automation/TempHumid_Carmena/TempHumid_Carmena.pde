/*
   ===========================================
   |        ARGO Behavioral Rig              |
   ===========================================

 c: 11.18.2015
 by: WALIII

  Hardware:
  * Temperature and Humidity sensors connected to Arduino input pins
  * Digital Switches on each box ( BOX01 thoguh BOX06)
  * Arduino connected to computer via USB cord

  Software:
  * Arduino programmer
  * Processing (download the Processing software here: https://www.processing.org/download/
  * Download the Software Serial library from here: http://arduino.cc/en/Reference/softwareSerial



*/

import processing.serial.*;

Table dataTable; //table where we will read in and store values. You can name it something more creative!
Table table;
Serial myPort; 
//int[] BOXa = {0,0,0,0,0,0 }; 
//String[] BIRD_ID = {"","","","","",""}; 
int numReadings = 5; //keeps track of how many readings you'd like to take before writing the file.
int readingCounter = 0; //counts each reading to compare to numReadings.
  String currentday = str(day());
int spacer = 0;
float H = 0;
float T = 0;
//float[] BOX_VAL = { 1,1,1,1,1,1 }; 
//long[] currentMillis = {millis(),millis(),millis(),millis(),millis(),millis()};
//long[] previousMillis = {0,0,0,0,0,0};
//float[] timer = {0,0,0,0,0,0};
String[] N = { "Pls", "work" ,"Mkay?"}; 
String[] TXT = {"","","","","",""};
String fileName;// = str(year()) + str('_')+ str(month()) + str('_')+ str(day());
int i = 0;

void setup()
{
    size(410, 600, P3D);
  String portName = Serial.list()[1];
table = new Table();

myPort = new Serial(this, portName, 9600); //set up your port to listen to the serial port


  table.addColumn("id"); //This column stores a unique identifier for each record. 
  //the following adds columns for time.
  table.addColumn("year");
  table.addColumn("month");
  table.addColumn("day");
  table.addColumn("hour");
  table.addColumn("minute");
  table.addColumn("second");

  //the following are dummy columns for each data value. 
  table.addColumn("Humidity");
  table.addColumn("Temperature (Celcius)");
table.addColumn("Temperature (Fahrenheit)");
//table.addColumn("BOX 01 DoorStatus");
//table.addColumn("BOX 02 DoorStatus");
//table.addColumn("BOX 03 DoorStatus");
//table.addColumn("BOX 04 DoorStatus");
//table.addColumn("BOX 05 DoorStatus");
//table.addColumn("BOX 06 DoorStatus");

//MULTIDAY TABLE
dataTable = new Table();
dataTable.addColumn("id");
dataTable.addColumn("year");
dataTable.addColumn("month");
dataTable.addColumn("day");
dataTable.addColumn("MAX Humidity");
dataTable.addColumn("MIN Humidity");
dataTable.addColumn("MAX Temperature (Celcius)");
dataTable.addColumn("MIN Temperature (Celcius)");
//dataTable.addColumn("BOX 01 social time");
//dataTable.addColumn("BOX 02 social time");
//dataTable.addColumn("BOX 03 social time");
//dataTable.addColumn("BOX 04 social time");
//dataTable.addColumn("BOX 05 social time");
//dataTable.addColumn("BOX 06 social time");
}

void serialEvent(Serial myPort){
  
 String val = myPort.readStringUntil('\n'); //The newline separator separates each Arduino loop. 
   if (val!= null) { 
    val = trim(val); //gets rid of any whitespace or Unicode nonbreakable space
    println(val); //Optional, useful for debugging. 
    float sensorVals[] = float(split(val, ',')); //parses the packet from Arduino and places the valeus into the sensorVals 

    TableRow newRow = table.addRow(); //add a row for this new reading
    newRow.setInt("id", table.lastRowIndex());//record a unique identifier (the row's index)
//BOX_VAL[0] = sensorVals[3];
//BOX_VAL[1] = sensorVals[4];
//BOX_VAL[2] = sensorVals[5];
//BOX_VAL[3] = sensorVals[6];
//BOX_VAL[4] = sensorVals[7];
//BOX_VAL[5] = sensorVals[8];

    //record time stamp
newRow.setInt("year", year());
newRow.setInt("month", month());
newRow.setInt("day", day());
newRow.setInt("hour", hour());
newRow.setInt("minute", minute());
newRow.setInt("second", second());

    ////record sensor information. Customize the names so they match your sensor column names.
newRow.setFloat("Humidity", sensorVals[0]);
newRow.setFloat("Temperature (Celcius)", sensorVals[1]);
newRow.setFloat("Temperature (Fahrenheit)", sensorVals[2]);
//newRow.setFloat("BOX 01 DoorStatus", sensorVals[3]);
//newRow.setFloat("BOX 02 DoorStatus", sensorVals[4]);
//newRow.setFloat("BOX 03 DoorStatus", sensorVals[5]);
//newRow.setFloat("BOX 04 DoorStatus", sensorVals[6]);
//newRow.setFloat("BOX 05 DoorStatus", sensorVals[7]);
//newRow.setFloat("BOX 06 DoorStatus", sensorVals[8]);

readingCounter++; //optional, use if you'd like to write your file every numReadings reading cycles
    T = sensorVals[1];
    H = sensorVals[0];
    ////saves the table as a csv in the same folder as the sketch every numReadings.
    //if (readingCounter % numReadings ==0)//The % is a modulus, a math operator that signifies remainder after division. The if statement checks if readingCounter is a multiple of numReadings (the remainder of readingCounter/numReadings is 0)

     fileName = str(year()) + str('_')+ str(month()) + str('_')+ str(day()); //this filename is of the form year+month+day+readingCounter

    String[] animals = new String[3];
animals[0] = "/Users/ARGO/Documents/test_log";
animals[1] = fileName;
animals[2] = ".csv";

String filename = join(animals, "");
      //println(filename);

saveTable(table, filename); //Woo! save it to your computer. 

// multi-day tracking
    String compareday = str(day());
    if (currentday.equals(compareday) == false)
    {
      print(currentday);
      print("  vs  ");
      println(str(day()));
     currentday = str(day());
//
    TableRow newRow2 = dataTable.addRow(); //add a row for this new reading
    newRow2.setInt("id", dataTable.lastRowIndex());//record a unique identifier (the row's index)
    int maxH = 0;
    int maxC = 0;
    int minH = 100;
    int minC = 100;

        for(TableRow row : table.rows()) {
            maxH = max(maxH, row.getInt("Humidity"));
            maxC = max(maxC, row.getInt("Temperature (Celcius)"));
            minH = min(minH, row.getInt("Humidity"));
            minC = min(minC, row.getInt("Temperature (Celcius)"));
        }

    println("Max humiditiy: " + maxH);
    println("Max temp (C): " + maxC);


    newRow2.setInt("year", year());
    newRow2.setInt("month", month());
    newRow2.setInt("day", day());
    newRow2.setFloat("MAX Humidity", maxH);
    newRow2.setFloat("MIN Humidity", minH);
    newRow2.setFloat("MAX Temperature (Celcius)", maxC);
    newRow2.setFloat("MIN Temperature (Celcius)", minC);
    //newRow2.setFloat("BOX 01 social time", timer[0]);
    //newRow2.setFloat("BOX 02 social time", timer[1]);
    //newRow2.setFloat("BOX 03 social time", timer[2]);
    //newRow2.setFloat("BOX 04 social time", timer[3]);
    //newRow2.setFloat("BOX 05 social time", timer[4]);
    //newRow2.setFloat("BOX 06 social time", timer[5]);
//timer[0] = 0; timer[1] = 0; timer[2] = 0; timer[3] = 0; timer[4] = 0; timer[5] = 0;


   //saveTable(table, "/Users/ARGO/Documents/DATA/new2.csv");

    saveTable(dataTable, "/Users/glab/Documents/DATA/LOGS/Aggregate_Data.csv");
 table.clearRows();
  }
   }
}

void draw()
{
draw_ui();
//  // Add Visualization here one day...
GetBoxInfo();
}

void stop() {
  // Clear the buffer, or available() will still be > 0
      myPort.clear();
      // Close the port
  myPort.stop();
  super.stop();
}