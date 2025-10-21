// ========================
// "Geometric Gallery Prototype" - Fullscreen with Controls
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
float instructionTimer = 0; // delay for showing instructions

void setup() {
  fullScreen();
  rectMode(CENTER);
  textAlign(CENTER, CENTER);
  font = createFont("Helvetica", 48);
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
  
  // Ambient breathing circles
  noFill();
  stroke(255, 180);
  for (int i = 0; i < 6; i++) {
    float r = sin(t + i * 0.4) * 100 + 250;
    strokeWeight(2);
    ellipse(0, 0, r, r);
  }
  
  // Fading title text
  fill(255, fade);
  textFont(font);
  textSize(72);
  text("Geometric Gallery Prototype", 0, -50);
  textSize(36);
  text("a collection of algorithmic sketches by Charlie Allen", 0, 50);
  
  // Delay instruction overlay
  instructionTimer += 1; // counts frames
  if (instructionTimer > 120) { // ~2 seconds delay
    fill(255, 180);
    textSize(20);
    text("Press SPACE → next sketch | Press ENTER → regenerate sketch", 0, height/2 - 50);
  }
  
  // Animate fade-in/out
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
      float[][] rotations; // store rotation for each rect

      noStroke();
      fill(230, 60, 80); // red
      rect(0, 0, rectSizes[i][j] * 0.8, rectSizes[i][j] * 0.8);

      strokeWeight(2);
      stroke(25, 55, 60); // dark
      fill(170, 205, 210); // blue
      rect(0, 0, rectSizes[i][j] * 0.8, rectSizes[i][j] * 0.8);

      fill(25, 55, 60); // darker blue
      rect(0, 0, rectSizes[i][j] * 0.55, rectSizes[i][j] * 0.55);
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
      instructionTimer = 0; // reset for intro if returning
      if (mode == 1) gridInitialized = false;
      if (mode == 2) angleVar = 360;
      if (mode == 3) t3 = 0;
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
  } else if (keyCode == ENTER) {
    // regenerate current sketch
    if (mode == 1) gridInitialized = false;
    if (mode == 2) angleVar = 360;
    if (mode == 3) t3 = 0;
  }
}
