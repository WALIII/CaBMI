// Assign Boxes and parameters for Boxes in this script. Run with ARGO_TBH

// c: 11.18.2015
// by: WALIII




void CaBMI_draw() {

// ACTIVE BOXES //




 

//========[ TEMPERATURE HUMIDITY LOGGER  ]==========//



  background(0, 0, 0);
fill(0, 102, 153, 204);
textSize(25);
text("CaBMI Operant Control Panel", 10, 30);
fill(0, 102, 153, 204);
textSize(32);
text("Recent Hits:", 10, 60);
  fill(0, 200, 200, 200);
text(BOX_VAL[0], 10, 90);
fill(0, 102, 153, 204);
text("Cursor Value:", 10, 120);
  fill(0, 200, 200, 200);
text(BOX_VAL[1], 10, 150);
fill(200, 200, 200, 204);
text("Total Hits:", 10, 180);
  fill(0, 200, 200, 200);
text(BOX_VAL[2], 10, 210);
fill(200, 200, 200, 204);



textSize(12);
text("     ==============[ THRESHOLD ]", 10, 380);




//////
if (offset ==0){
offset = BOX_VAL[1];}

float C = (BOX_VAL[1]-offset)/5 ;
  // Cursoe
  for(int i = 0; i < 1; i = i+1){
    if (BOX_VAL[1] > 3500){
      stroke(0, 240, 0);}
      else{
   stroke(240, 0, 0);}
   strokeWeight(40);  // Thicker
   strokeCap(SQUARE);
   line(55+60*i, 520, 55+60*i, 510-C);
  }
   
   
   
   strokeWeight(1);  // Thicker
   
   
   
   stroke(200, 200, 200);
  line(20, 280, 20, 520);
  //line(20, 320, 60, 320);
  //stroke(0, 0, 0);
  line(20, 520, 180, 520);
  
  // Dashed lines
  for(int i = 1; i < 6; i = i+1){
    stroke(200, 200, 200);
   line(20, 580-60*i, 25, 580-60*i);
   if (i<3){
   line(25+60*i, 520, 25+60*i, 525);}
  }


/////



}