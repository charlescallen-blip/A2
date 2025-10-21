// ========================
// Geometric Gallery Prototype - Fullscreen with Controls
// ========================

int mode = 0;          // 0 = intro, 1 = grid, 2 = radial, 3 = sunset, 4 = color quads
int totalModes = 5;

// Transition variables
boolean transitioning = false;
float fadeAmt = 0;
boolean fadingOut = true;

// ========================
// Sketch 1 – Grid Pattern
// ========================
int mX_ = 90; 
int mY_ = 90;
int mX, mY;
int gridSize = 40;
int sizeBox = 40;
float[][] rectSizes;
boolean gridInitialized = false;

// ========================
// Sketch 2 – Radial Pattern
// ========================
float x;
float strokeW = 4;
float angleVar = 360;

// ========================
// Sketch 3 – Sunset Pattern
// ========================
int sunsetLines = 40;
float[] y = new float[sunsetLines];
float sW;
float spacing;

// ========================
// Sketch 4 – Color Quads
// ========================
color[] colArray = {
  color(255, 255, 255), // white
  color(200, 5, 20),    // red
  color(55, 188, 25),   // green
  color(15, 35, 250),   // blue
  color(125, 235, 250), // light blue
  color(240, 245, 15),  // yellow
  color(160, 60, 235)   // purple
};
int quadGrid = 100;
int quadMargin = 150;
float quadD;

// ========================
// Intro variables
// ========================
float t = 0;
float fade = 0;
boolean fadingIn = true;
PFont font;
float instructionTimer = 0;

// Placeholder timer for mode-specific setups
float t3 = 0;

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

// ========================
// Main draw
// ========================
void draw() {
  if (!transitioning) {
    if (mode == 0) drawIntro();
    else if (mode == 1) drawGridPattern();
    else if (mode == 2) drawRadialPattern();
    else if (mode == 3) drawSunsetPattern();
    else if (mode == 4) drawColorQuads();
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

  instructionTimer += 1;
  if (instructionTimer > 120) {
    fill(255, 180);
    textSize(20);
    text("Press SPACE → next sketch | Press ENTER → regenerate sketch", 0, height/2 - 50);
  }

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
    int cols = (width - 2 * mX) / gridSize + 1;
    int rows = (height - 2 * mY) / gridSize + 1;
    rectSizes = new float[cols][rows];
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        rectSizes[i][j] = random(sizeBox * 0.5, sizeBox);
      }
    }
    gridInitialized = true;
  }

  int i = 0;
  for (int xPos = mX; xPos <= width - mX; xPos += gridSize) {
    int j = 0;
    for (int yPos = mY; yPos <= height - mY; yPos += gridSize) {
      pushMatrix();
      translate(xPos, yPos);

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
// MODE 3 – Sunset Pattern
// ========================
void setupSunsetPattern() {
  spacing = height / sunsetLines;
  sW = spacing * 0.8;
  for (int n = 0; n < sunsetLines; n++) {
    y[n] = n * spacing;
  }
}

void drawSunsetPattern() {
  if (t3 == 0) setupSunsetPattern();
  t3 += 1;

  background(#061324);

  for (int n = 0; n < sunsetLines; n++) {
    float alpha = map(y[n], 0, height, 50, 255);
    stroke(#F10000, alpha);
    strokeWeight(sW);
    line(0, y[n], width, y[n]);

    y[n] += 2;
    if (y[n] > height) y[n] = 0;
  }

  fill(#061324);
  noStroke();
  ellipse(width/2, height/2, height + height/6, height + height/6);
}

// ========================
// MODE 4 – Color Quads
// ========================
void setupColorQuads() {
  quadD = quadGrid * 0.6;
}

void drawColorQuads() {
  if (t3 == 0) setupColorQuads();
  t3 += 1;

  background(15, 20, 30);
  noFill();

  for (int i = quadMargin; i <= width - quadMargin; i += quadGrid) {
    for (int j = quadMargin; j < height - quadMargin; j += quadGrid) {
      int colArrayNum = (int)random(colArray.length);
      stroke(colArray[colArrayNum]);
      strokeWeight(3);
      for (int k = 0; k < 7; k++) {
        float x1 = -random(quadD);
        float y1 = -random(quadD);
        float x2 = random(quadD);
        float y2 = -random(quadD);
        float x3 = random(quadD);
        float y3 = random(quadD);
        float x4 = -random(quadD);
        float y4 = random(quadD);

        pushMatrix();
        translate(i, j);
        quad(x1, y1, x2, y2, x3, y3, x4, y4);
        popMatrix();
      }
    }
  }
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
      instructionTimer = 0;
      t3 = 0; // reset mode setup flag
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
  } else if (keyCode == ENTER) {
    if (mode == 1) gridInitialized = false;
    if (mode == 2) angleVar = 360;
    if (mode == 3 || mode == 4) t3 = 0;
  }
}
