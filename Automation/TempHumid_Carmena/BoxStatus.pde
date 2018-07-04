// Assign Boxes and parameters for Boxes in this script. Run with ARGO_TBH

// c: 11.18.2015
// by: WALIII




void draw_ui() {

// ACTIVE BOXES //





 

//========[ TEMPERATURE HUMIDITY LOGGER  ]==========//



  background(0, 0, 0);
fill(0, 102, 153, 204);
textSize(25);
text("ARGO Imaging Recording Room:", 10, 30);
fill(0, 102, 153, 204);
textSize(32);
text("TEMPERATURE:", 10, 60);
  fill(0, 200, 200, 200);
text(T, 10, 90);
fill(0, 102, 153, 204);
text("HUMIDITY:", 10, 120);
  fill(0, 200, 200, 200);
text(H, 10, 150);
fill(200, 200, 200, 204);
textSize(12);
text("=============[ BOX  STATUS ]====================", 10, 190);


for (int i = 0; i < 6; i = i+1) {
int ii = i+1;
if(BOXa[i] == 1){
  if(BOX_VAL[i] ==0){
spacer = spacer+20;
  currentMillis[i] = millis();

  if(currentMillis[i] - previousMillis[i] >= 1000) {
    // save the last time you blinked the LED
    previousMillis[i] = currentMillis[i];
    timer[i] = timer[i]+1; }

N[0] = "BOX"; 
N[1] = str(ii); 
N[2] = "OPEN";
TXT[i]= join(N, " ");

fill(200, 0, 0, 204); textSize(32); text(TXT[i], 10, 220+60*i);
if(timer[i] > 5){
fill(0, 200, 0, 204); textSize(32); text(timer[i], 10, 250+60*i); }
else{
fill(200, 0, 0, 204); textSize(32); text(timer[i], 10, 250+60*i);}
  }

else{

N[0] = "BOX"; 
N[1] = str(ii); 
N[2] = "CLOSED";
TXT[i]= join(N, " ");
{ fill(0, 102, 153, 204); textSize(32); text(TXT[i], 10, 220+60*i);
if(timer[i] > 5){
fill(0, 200, 0, 204); textSize(32); text(timer[i], 10, 250+60*i); }
else{
fill(200, 0, 0, 204); textSize(32); text(timer[i], 10, 250+60*i);}
  }
}

}
}}