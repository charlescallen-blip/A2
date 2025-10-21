// ========================
// "Geometric Gallery Prototype" - Fullscreen
// ========================

int mode = 0;          // 0 = intro, 1 = grid, 2 = radial, 3 = placeholder
int totalModes = 4;

// Transition variables
boolean transitioning = false;
float fadeAmt = 0;
boolean fadingOut = true;

// Sketch 1 (Grid)
int mX_ = 90; 
int mY_ = 90;
int mX, mY;
int grid = 40;
int sizeBox = 40;
float[][] rectSizes;
boolean gridInitialized = false;

// Sketch 2 (Radial)
float x;
float strokeW = 4;
float angleVar = 360;

// Sketch 3 (Placeholder)
float t3 = 0;

// Intro
float t = 0;
float fade = 0;
boolean fadingIn = true;
PFont font;

void setup() {
  fullScreen();           // fullscreen mode
  rectMode(CENTER);
  textAlign(CENTER, CENTER);
  font = createFont("Helvetica", 48);  // slightly bigger for fullscreen
  mX = mX_;
  mY = mY_;
  noStroke();
  frameRate(60);
}

void draw() {
  if (!transitioning) {
    if (mode == 0) drawIntro();
    else if (mode == 1) drawGridPattern();
    else if (mode == 2) drawRadialPattern();
    else if (mode == 3) drawPlaceholder();
  } else {
    handleTransition();
  }
}

// ========================
// MODE 0 – Intro / Title Card
// ========================
void drawIntro() {
  background(0, 15, 35);
  translate(width/2, height/2);
  noFill();
  stroke(255, 180);
  for (int i = 0; i < 6; i++) {
    float r = sin(t + i * 0.4) * 100 + 250;
    strokeWeight(2);
    ellipse(0, 0, r, r);
  }
  fill(255, fade);
  textFont(font);
  textSize(72);
  text("Geometric Gallery Prototype", 0, -50);
  textSize(36);
  text("a collection of algorithmic sketches by Charlie Allen", 0, 50);
  if (fadingIn) fade += 2;
  if (fade >= 255) fadingIn = false;
  if (!fadingIn && fade > 0) fade -= 0.5;
  t += 0.02;
}

// ========================
// MODE 1 – Grid Pattern
// ========================
void drawGridPattern() {
  background(255);
  
  if (!gridInitialized) {
    int cols = (width - 2 * mX) / grid + 1;
    int rows = (height - 2 * mY) / grid + 1;
    rectSizes = new float[cols][rows];
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        rectSizes[i][j] = random(sizeBox * 0.5, sizeBox);
      }
    }
    gridInitialized = true;
  }

  int i = 0;
  for (int x = mX; x <= width - mX; x += grid) {
    int j = 0;
    for (int y = mY; y <= height - mY; y += grid) {
      pushMatrix();
      translate(x, y);
      rotate(radians(y));
      strokeWeight(2);
      stroke(25, 55, 60);
      fill(170, 205, 210, 180);
      rect(0, 0, rectSizes[i][j], rectSizes[i][j]);
      fill(22, 55, 60, 220);
      rect(0, 0, rectSizes[i][j] * 0.8, rectSizes[i][j] * 0.8);
      popMatrix();
      j++;
    }
    i++;
  }
}

// ========================
// MODE 2 – Radial Pattern
// ========================
void drawRadialPattern() {
  background(0, 15, 35);
  translate(width/2, height/2);
  for (int angle = 0; angle <= 360; angle += angleVar) {
    if (angleVar <= 11) x = random(300, 350);
    else x = 350;
    pushMatrix();
    rotate(radians(angle));
    stroke(238);
    strokeWeight(strokeW);
    line(x, 0, width, 0);
    popMatrix();
  }
  if (angleVar > 1) angleVar -= 1;
  else angleVar = 1;
  strokeW = map(angleVar, 0, 51, 0, 128);
}

// ========================
// MODE 3 – Placeholder
// ========================
void drawPlaceholder() {
  background(245);
  translate(width/2, height/2);
  fill(25, 55, 60);
  textFont(font);
  textSize(48);
  text("Sketch 3: Untitled (WIP)", 0, 0);
  noFill();
  stroke(25, 55, 60);
  strokeWeight(3);
  ellipse(0, 0, 300 + 80 * sin(t3), 300 + 80 * sin(t3));
  t3 += 0.05;
}

// ========================
// Transition handler
// ========================
void handleTransition() {
  if (fadingOut) {
    fadeAmt += 10;
    fill(255, constrain(fadeAmt, 0, 255));
    noStroke();
    rectMode(CORNER);
    rect(0, 0, width, height);
    if (fadeAmt >= 255) {
      mode = (mode + 1) % totalModes;
      fadingOut = false;
      if (mode == 1) gridInitialized = false;
      if (mode == 2) angleVar = 360;
    }
  } else {
    fadeAmt -= 10;
    fill(255, constrain(fadeAmt, 0, 255));
    noStroke();
    rectMode(CORNER);
    rect(0, 0, width, height);
    if (fadeAmt <= 0) {
      transitioning = false;
      fadingOut = true;
      fadeAmt = 0;
    }
  }
}

// ========================
// Controls
// ========================
void keyPressed() {
  if (key == ' ' && !transitioning) {
    transitioning = true;
    fadeAmt = 0;
  }
}
