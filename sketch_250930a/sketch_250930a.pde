int mX_ = 90;
int mY_ = 90;
int mX, mY;
int grid = 40;
int size = 40;
float sW = 2;

void setup() {
  size(900, 900);
  surface.setLocation(987, 70);
  rectMode(CENTER);
  noLoop();
  
  size = grid;
  mX = (width-grid*floot((width
}

void draw() {
  background(255);

// two for() loops that create a grid of rectangles with their own origin  
  for (int x=mX; x<=width-mX; x+=grid) {
    for (int y=mY; y<=height-mY; y+=grid) {
      pushMatrix();
      translate(x, y);
      rotate(radians(y));
      
      noStroke();
      fill(230
      
      strokeWeight(2);
      stroke(25,55,60);    // black (more like grey(gray?) tbh not dark enough)
      fill(170,  205, 210); // blue(?) ish? not really also tbh
      rect(0, 0, random(size), random(size));
      
      fill(22, 55, 60); // blue
      rect(0, 0, random(size), random(size));
      popMatrix();
    }
  }
}

// pause the loop
void keyPressed(){
  if(key==' ') redraw();
}
