PImage maineImage;
Table pixelTable;
int rowCount;
int year; 
PFont font1,font2; 
String ptext=""; 



Table dataTable;
float dataMin = MAX_FLOAT;
float dataMax = MIN_FLOAT;
int X1,X2,Y1,Y2;

void setup() {
  size(500, 800);
  maineImage = loadImage("maine-transparent.png");
  X1=width/6; 
  Y1=height/8;
  X2=X1+maineImage.width;
  Y2 =maineImage.height+height/8;
  
  //the pixel table is calcuated by going to the right however many pixels and then down how many
  //even many the specific town is
  pixelTable = new Table("pixels.tsv");
  rowCount = pixelTable.getRowCount();
  
  // Read the data table
  dataTable = new Table("random.tsv");
  
  font1 = loadFont("Arial-BoldMT-30.vlw");
  font2 = loadFont("Tunga-Bold-30.vlw");

  
  
    // Find the minimum and maximum values
  for (int row = 0; row < rowCount; row++) {
    float value = dataTable.getFloat(row, 1);
    if (value > dataMax) {
      dataMax = value;
    }
    if (value < dataMin) {
      dataMin = value;
    }
  }
}

// Global variables set in drawData() and read in draw()
float closestDist;
String closestText;
float closestTextX;
float closestTextY;

void draw() {
  background(240);
  image(maineImage, X1, Y1);
  //ellipse();
  // Drawing attributes for the ellipses   
  smooth();
  fill(192, 0, 0);
  noStroke();

  drawOverlay();
   
   closestDist = width*height;

  for (int row = 0; row < rowCount; row++) {
    String abbrev = dataTable.getRowName(row);
    float x = pixelTable.getFloat(abbrev, 1);
    float y = pixelTable.getFloat(abbrev, 2);
   
    drawData(x, y, abbrev);
   // println("drew data at" +"X= "+ x+ " and Y= " + y + "");
   
   if (closestDist != width*height) {
    fill(0);
    textAlign(CENTER);
    textSize(40);
    ptext = closestText; 
  }
 }


  

}

void drawOverlay() {
  //these are the blocks for the tabs of different graph types
    
    year = 2010;
    textSize(30);
    textAlign(CENTER);
    textFont(font1,20);
    fill(255); 
    rect(0,0,width,Y1);
    rect(0,Y2,width,height);
    fill(0,128,255);
    text("Days of snowfall vs Average Snowfall \n 1980-2013",width/2,40);
    fill(0,128,255);
    textAlign(CENTER);
    textFont(font2, 10);
    textSize(30);
    text(ptext, width/2, 650);
     


}
void drawData(float x, float y, String abbrev) {
  float value = dataTable.getFloat(abbrev, 1);
  float value2 = dataTable.getFloat(abbrev, 2);
  float value3 = dataTable.getFloat(abbrev, 3);  
  float value4 = value/value3; 
  float radius = 0;
  radius = map(value, 0, dataMax, 1.5, 15);
  ellipseMode(RADIUS);
   fill(255,255,250-(value4*60));
  ellipse(X1+x, Y1+y, radius, radius);

  float d = dist(x+X1, y+Y1, mouseX, mouseY);
  // Because the following check is done each time a new
  // circle is drawn, we end up with the values of the
  // circle closest to the mouse.
  if ((d < radius + 2) && (d < closestDist)) {
    closestDist = d;
    String name = dataTable.getString(abbrev, 0);
    closestText = name + " \n" +"Snowfall: " +value +"in "+ "(" +value2+"cm)" + "\n Days of snowfall: " + value3 + "\n Snowfall per day: " + nf(value4,0,2) + " inches";
    closestTextX = x+X1;
    closestTextY = y+Y1-radius-4;
  }
}

 void mousePressed() {
   
   //used for getting the pixels for the plot points since we arent
   //using the long and lat
   println("X= " +(mouseX-X1) + "  Y= " + (mouseY-Y1));
 }
