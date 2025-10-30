// ------------------------
// Geometric Gallery Prototype - Fullscreen with Controls
// Made by Charlie Allen :)
// ------------------------

// ------------------------
// GLOBAL MODE VARIABLES
// ------------------------
int mode = 0;       // Initial sketch mode (0 = titles)
int totalModes = 7; // Total modes including intro

// Transition / dip to white variables
boolean transitioning = false; // True if transitioning between sketches
float fadeAmt = 0;             // Fade opacity, essentially how much the white rectangle covers the screen
boolean fadingOut = true;      // Fade direction for transition, as in whether revealing the next sketch or hiding the previous one

// ------------------------
// SKETCH 1 - GRID PATTERN VARIABLES
// ------------------------
int mX_ = 90;              // Margin X
int mY_ = 90;              // Margin Y
int mX, mY;                // Calculated starting positions within grid
int gridSize = 40;         // Distance between cells
int boxSize = 40;          // Base rectangle size
float sW = 2;              // Stroke weight
boolean gridReady = false; // Indicator of the grid setup being complete

// ------------------------
// SKETCH 2 - RADIAL PATTERN VARIABLES
//-------------------------
float x;                            // Length of radial lines
float strokeW = 4;                  // Stroke weight of radial lines
float angleVar = 360;               // Angle increment (shrinks over time during animation)
boolean radialInitialised = false;  // Indicator of completion

// ------------------------
// SKETCH 1 - SUNSET PATTERN VARIABLES
// ------------------------
int sunsetLines = 40;               // Number of moving lines
float[] y = new float[sunsetLines]; // Y positions of moving lines
float sunsetSW;                     // Stroke weight of the lines
float sunsetSpacing;                // Line spacing, as calculated during setup

// ------------------------
// SKETCH 4 – COLOUR QUADS VARIABLES
// ------------------------
color[] colArray = {                // Palette of colours for quads
  color(255, 255, 255),
  color(200, 5, 20),
  color(55, 188, 25),
  color(15, 35, 250),
  color(125, 235, 250),
  color(240, 245, 15),
  color(160, 60, 235)
};
int quadGrid = 100;                 // Grid spacing for quads
int quadMargin = 150;               // Margin from edges
float quadD;                        // Maximum offset value for quad vertices
boolean quadDrawn = false;          // Indicator of quads being drawn

// ------------------------
// SKETCH 5 – COLOUR LINE CIRCLE VARIABLES
// ------------------------
boolean colourCircleSetup = false;  // True if setup complete
boolean colourCircleDrawn = false;  // True if sketch is drawn

// ------------------------
// SKETCH 6 – ELLIPSE RINGS VARIABLES
// ------------------------
boolean ellipseRingsDrawn = false;  // True if drawn

// ------------------------
// TITLES/TEXT VARIABLES
// ------------------------
float t = 0;                // Animation time for circles
float fade = 0;             // Text fade
boolean fadingIn = true;    // Text fade direction
PFont font;                 // Font for using in titles
float instructionTimer = 0; // Delay for controls instructions
float t3 = 0;

// ------------------------
// PER-MODE INDICATORS
// ------------------------
boolean[] modeDrawn;        // Keeps track of whether static tracks are drawn or not
boolean[] modeAnimated;     // Indicates which sketches are animated

// ------------------------
// SETUP FUNCTION
// ------------------------
void setup() {              // All self-explanatory
  fullScreen();
  rectMode(CENTER);
  textAlign(CENTER, CENTER);
  font = createFont("Helvetica", 48);
  noStroke();
  frameRate(60);

// Setup for mode statuses
  modeDrawn = new boolean[totalModes];
  modeAnimated = new boolean[totalModes];

// Animated mode indicator setup
  modeAnimated[0] = true;
  modeAnimated[1] = false;
  modeAnimated[2] = true;
  modeAnimated[3] = true;
  modeAnimated[4] = false;
  modeAnimated[5] = false;
  modeAnimated[6] = false;

  initGridPattern();
  setupSunsetPattern();
}

// ------------------------
// GRID PATTERN SETUP FUNCTION
// Calculates margins, stroke weight, and ability to detect if grid is "ready"
// ------------------------
void initGridPattern() {
  gridSize = max(1, gridSize);
  boxSize = gridSize;
  mX = (width - gridSize * floor((width - mX_ * 2 - boxSize * 2) / gridSize)) / 2;
  mY = (height - gridSize * floor((height - mY_ * 2 - boxSize * 2) / gridSize)) / 2;
  sW = map(boxSize, 40, 400, 2, 10);
  gridReady = true;
  modeDrawn[1] = false; // Resets the "drawn" indicator
}

// ------------------------
// SUNSET PATTERN SETUP FUNCTION
// Initialises moving line positions and stroke weight
// ------------------------
void setupSunsetPattern() {
  for (int n = 0; n < sunsetLines; n++) {
    y[n] = height / (float)sunsetLines * n;
  }
  sunsetSW = height / (float)sunsetLines / 2;
}

// ------------------------
// MAIN DRAW LOOP
// Handles transitions, static modes, and animated modes
// ------------------------
void draw() {
  if (transitioning) {
    handleTransition();   // Enables the transition between sketches
    return;
  }
// Static sketches (initially draw once)
  if (!modeAnimated[mode]) {
    if (modeDrawn[mode]) return;
    drawModeOnce(mode);
    modeDrawn[mode] = true;
    return;
  }

// Animated sketches
  if (mode == 0) drawIntro();
  else if (mode == 2) drawRadialPattern();
  else if (mode == 3) drawSunsetPattern();
}

// ------------------------
// DRAW STATIC MODE ONCE
// Chooses sketch based on current mode
// ------------------------
void drawModeOnce(int m) {
  if (m == 1) drawGridPattern();
  else if (m == 4) { setupColourQuads(); drawColourQuads(); }
  else if (m == 5) { setupColourLineCircle(); drawColourLineCircle(); }
  else if (m == 6) drawEllipseRings();
  else if (m == 0) drawIntro();
  else if (m == 2) drawRadialPattern();
  else if (m == 3) drawSunsetPattern();
}

// ------------------------
// MODE 0 – INTRO
// Animated breating circles with fade-in title text
// ------------------------
void drawIntro() {
  background(0, 15, 35);
  pushMatrix();
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
  popMatrix();

  instructionTimer++;
  if (instructionTimer > 120) {
    fill(255, 180);
    textSize(20);
    text("Press SPACE → next sketch | Press ENTER → regenerate sketch", width/2, height - 50);
  }

  if (fadingIn) fade += 2;
  if (fade >= 255) fadingIn = false;
  if (!fadingIn && fade > 0) fade -= 0.5;
  t += 0.02;
}

// ------------------------
// MODE 1 – GRID PATTERN
// Rectangles on a loose grid, with randomised rotation and size
// ------------------------
void drawGridPattern() {
  if (!gridReady) initGridPattern();
  background(255);

// Layer 1 - base coloured rectangles
  for (int x = mX; x <= width - mX; x += gridSize) {
    for (int y = mY; y <= height - mY; y += gridSize) {
      pushMatrix();
      translate(x, y);
      rotate(random(TWO_PI));
      noStroke();
      fill(230, 56, 56);
      rect(0, 0, random(boxSize * 1.4), random(boxSize * 1.4));
      popMatrix();
    }
  }

// Layer 2 - secondary rectangles with stroke and inner fills
  for (int x = mX; x <= width - mX; x += gridSize) {
    for (int y = mY; y <= height - mY; y += gridSize) {
      pushMatrix();
      translate(x, y);
      rotate(random(TWO_PI));
      strokeWeight(sW);
      stroke(25, 44, 60);
      fill(173, 240, 240);
      rect(0, 0, random(boxSize * 0.85), random(boxSize * 0.85));
      fill(22, 23, 60);
      rect(0, 0, random(boxSize * 0.85), random(boxSize * 0.85));
      popMatrix();
    }
  }
}

// ------------------------
// MODE 2 – RADIAL PATTERN
// Short animaiton of converging lines rotating around centre
// ------------------------
void drawRadialPattern() {
  background(0, 15, 35);
  pushMatrix();
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
  popMatrix();
  if (angleVar > 1) angleVar -= 1;
  else angleVar = 1;
  strokeW = map(angleVar, 0, 51, 0, 128);
}

// ------------------------
// MODE 3 – SUNSET PATTERN
// Horizontal moving lines with circular mask to create illusion of internal shape
// ------------------------
void drawSunsetPattern() {
  background(#4f1964);

  // Moving horizontal lines
  for (int n = 0; n < sunsetLines; n++) {
    float alpha = map(y[n], 0, height, 0, 255);
    stroke(#F10000, alpha);
    strokeWeight(sunsetSW);
    line(0, y[n], width, y[n]);
    y[n] += 0.5;
    if (y[n] > height) y[n] = 0;
  }

  float cx = width/2.0;
  float cy = height/2.0;
  float d = height + height/6.0;
  float r = d/2.0;

  // Circular mask border
  stroke(#4f1964);
  strokeWeight(height/2.7);
  noFill();
  ellipse(cx, cy, d, d);

  // Additional mask to keep only circular interior visible, necessitated by fullscreen
  noStroke();
  fill(#4f1964);
  rectMode(CORNER);
  // top, bottom, left, right masks
  rect(0, 0, width, cy - r);
  rect(0, cy + r, width, height - (cy + r));
  rect(0, cy - r, cx - r, 2*r);
  rect(cx + r, cy - r, width - (cx + r), 2*r);
}

// ------------------------
// MODE 4 – COLOUR QUADS
// Randomly squiggled quads on a grid
// ------------------------
void setupColourQuads() { quadD = quadGrid * 0.6; }

void drawColourQuads() {
  setupColourQuads();
  background(15, 20, 30);
  noFill();
  for (int i = quadMargin; i <= width - quadMargin; i += quadGrid) {
    for (int j = quadMargin; j < height - quadMargin; j += quadGrid) {
      int c = (int)random(colArray.length);
      stroke(colArray[c]);
      strokeWeight(3);
      for (int k = 0; k < 7; k++) {
        float x1 = -random(quadD), y1 = -random(quadD);
        float x2 = random(quadD),  y2 = -random(quadD);
        float x3 = random(quadD),  y3 = random(quadD);
        float x4 = -random(quadD), y4 = random(quadD);
        pushMatrix();
        translate(i, j);
        quad(x1, y1, x2, y2, x3, y3, x4, y4);
        popMatrix();
      }
    }
  }
}

/// ------------------------
// MODE 5 – COLOUR LINE CIRCLE
// Overlapping lines radiating from centre with random colours
// ------------------------
void setupColourLineCircle() { colourCircleSetup = true; }

void drawColourLineCircle() {
  background(random(255), random(255), random(255));
  translate(width/2, height/2);
  for (int n = 0; n < 30; n++) {
    stroke(random(255), random(255), random(255));
    for (int a = 0; a < 360; a++) {
      float x1 = random(50, 150);
      float x2 = random(150, 350);
      pushMatrix();
      rotate(radians(a));
      strokeCap(CORNER);
      strokeWeight(4);
      line(x1, 0, x2, 0);
      popMatrix();
    }
  }
}

// -----------------------
// TRANSITIONS
// Creates a smooth fade in/out between sketches
// -----------------------
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
      modeDrawn[mode] = false;
      if (mode == 1) gridReady = false;
      if (mode == 2) { angleVar = 360; radialInitialised = false; }
      if (mode == 3) setupSunsetPattern();
      if (mode == 4) quadDrawn = false;
      if (mode == 5) { colourCircleSetup = false; colourCircleDrawn = false; }
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

// -----------------------
// MODE 6 – ELLIPSE RINGS
// Seperated rings of coloured ellipses
// -----------------------
void drawEllipseRings() {
  background(#282828);
  translate(width/2, height/2);
  float rStep = 30;
  float rMax = min(width, height)/2 - 50;
  for (float r=0; r<rMax; r+=rStep) {
    float c = 2*PI*r;
    float cSegment = map(r, 0, rMax, rStep*3/4, rStep/2);
    float aSegment = floor(c/cSegment);
    float ellipseSize = map(r, 0, rMax, rStep*3/4-1, rStep/4);
    for (float a=0; a<360; a+=360/aSegment) {
      fill(random(255), random(255), random(255));
      pushMatrix();
      rotate(radians(a));
      ellipse(r, 0, ellipseSize, ellipseSize);
      popMatrix();
    }
  }
}

// ------------------------
// CONTROLS
// SPACE = next sketch, ENTER = regenerate current sketch
// ------------------------
void keyPressed() {
  if (key == ' ' && !transitioning) {
    transitioning = true;
    fadeAmt = 0;
  } else if (keyCode == ENTER) {
    if (mode == 1) modeDrawn[1] = false;
    else if (mode == 2) angleVar = 360;
    else if (mode == 3) setupSunsetPattern();
    else if (mode == 4) { modeDrawn[4] = false; quadDrawn = false; }
    else if (mode == 5) { modeDrawn[5] = false; colourCircleSetup = false; colourCircleDrawn = false; }
    else if (mode == 6) { modeDrawn[6] = false; ellipseRingsDrawn = false; }
    loop();
  }
}
