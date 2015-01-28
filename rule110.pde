// Rule 110 cellular automaton simulator
// By Aron Dennen January 28th 2015

// Controls:
// Left click the mouse to add an input row point
// Right click the mouse to erase an input row point
// Press a key to erase the input row

/* Globals */
final int boxWidth = 600, boxHeight = 600;
final int ofsX = 50, ofsY = 50;
final int inset = 1;

color [] topRowState;
int lastDotX; // X position of the last dot added

color drawColor = color(127, 255, 127);
color whiteColor = color(255);
color blackColor = color(0);

void setup() {
  size(700, 700);
  
  topRowState = new color[width];
  
  textSize(32);
  fill(color(0));
  text("Rule 110", (width/2) - 80, 35);
  
  textSize(14);
  text("Processing Sketch by Aron Dennen 2015", (width/2) - 150, height - 20);
  
  // Set the inital pixel
  loadPixels();
  clearFrame();
  saveTopRow(); // Initialize the top row array to white color
  int initialPixelCoordinate = ((ofsY+inset-1)*height) + ofsX+(boxWidth/2);
  pixels[ initialPixelCoordinate ] = drawColor;
  lastDotX = ofsX+(boxWidth/2);
  algorithm();
  updatePixels();
}

// Clear the outer frame area around the drawing area
void clearFrame() {
  for (int y = ofsY; y < (ofsY + boxHeight); y++) {
    for (int x = ofsX; x < (ofsX + boxWidth); x++) {
      pixels[ (y * height) + x ] = color(255);
    }
  }
}

// Save and restore top row
void saveTopRow() {
  for (int i = ofsX; i < ofsX + boxWidth; i++) {
      topRowState[i] = pixels[ ((ofsY+inset-1)*height) + i ];
  }
}
void restoreTopRow() {
  for (int i = ofsX; i < ofsX + boxWidth; i++) {
      pixels[ ((ofsY+inset-1)*height) + i ] = topRowState[i];
  }
}

void clearInputRow() {
  loadPixels();
  for (int i = ofsX; i < ofsX + boxWidth; i++) {
    pixels[ ((ofsY+inset-1)*height) + i ] = whiteColor;
  }
  saveTopRow(); // Save the cleared row state
  algorithm(); // Redraw the screen
  updatePixels();
}

// Rule 110 algorithm
void algorithm() {
  // Need to inset 1 pixel around the frame to keep the algorithm from drawing in the corner
  for (int y = ofsY+inset; y < (ofsY + boxHeight - inset); y++) {
    for (int x = ofsX+inset; x < (ofsX + boxWidth - inset); x++) {
      int pixelAbove = ((y-1) * height) + x;
      
      // True = not white
      boolean a = ( (pixels[pixelAbove-1] & 0xFFFFFF) != 0xFFFFFF ) ? true : false;
      boolean b = ( (pixels[pixelAbove] & 0xFFFFFF) != 0xFFFFFF) ? true : false;
      boolean c = ( (pixels[pixelAbove+1] & 0xFFFFFF) != 0xFFFFFF ) ? true : false;
      
      // Conditions for white, otherwise black
      color resultColor =
        ( (a && b && c) || (a && !b && !c) || (!a && !b && !c) ) ? whiteColor : blackColor;
        
      pixels[(y*height) + x] = resultColor;
    }
  }
}

// Allow movement of the last dot entered by the arrow keys
void draw() {
  boolean redrawFlag = false;
  
  if (keyPressed) {
    if (key == CODED) {
      if (keyCode == LEFT) {
        lastDotX--;
        redrawFlag = true;
      }
      else if (keyCode == RIGHT) {
        lastDotX++;
        redrawFlag = true;
      }
    }
  }
  
  if (redrawFlag) {
    // Bounds checking
    if (lastDotX < ofsX+inset) {
      lastDotX = ofsX;
      redrawFlag = false;
    } else if (lastDotX >= ofsX+boxWidth-inset) {
      lastDotX = ofsX+boxWidth-inset;
      redrawFlag = false;
    }
    else {
      // We're in bounds so update
      int pixelCoordinate = ((ofsY+inset-1)*height) + lastDotX;
      loadPixels();
      restoreTopRow();
      pixels[ pixelCoordinate ] = drawColor;
      algorithm();
      updatePixels();
    }
  }
}

// Only draw on mouse press or drag
void mousePressed() {
  mousePressOrDrag();
  //println( pixels[(mouseY * width) + mouseX] & 0xFFFFFF);
}
void mouseDragged() {
  mousePressOrDrag(); 
}
void mousePressOrDrag() {  
  if (mouseX > ofsX && mouseX < ofsX + boxWidth) {
    int pixelCoordinate = ((ofsY+inset-1)*height) + mouseX;
    saveTopRow();
    
    loadPixels();
    if (mouseButton == LEFT) {
      pixels[ pixelCoordinate ] = drawColor;
      lastDotX = mouseX;
    }
    else pixels[ pixelCoordinate ] = whiteColor;
    
    algorithm();
    updatePixels();
  }
}

void keyPressed() {
  // Clear the top input row when space is pressed
  if (key == ' ') {
    clearInputRow();
  }
}
