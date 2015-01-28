// Rule 110 cellular automaton simulator
// By Aron Dennen January 28th 2015

// Controls:
// Left click the mouse to add an input row point
// Right click the mouse to erase an input row point
// Press a key to erase the input row

/* Globals */
int boxWidth = 600, boxHeight = 600;
int ofsX = 50, ofsY = 50;
int inset = 1;

color drawColor = color(127, 255, 127);
color whiteColor = color(255);
color blackColor = color(0);

void setup() {
  size(700, 700);
  
  textSize(32);
  fill(color(0));
  text("Rule 110", (width/2) - 80, 35);
  
  textSize(14);
  text("Processing Sketch by Aron Dennen 2015", (width/2) - 150, height - 20);
  
  // Set the inital pixel
  loadPixels();
  clearFrame();
  pixels[ ((ofsY+inset-1)*height) + ofsX+(boxWidth/2) ] = drawColor;
  algorithm();
  updatePixels();
}

// Clear the outer frame around the drawing area
void clearFrame() {
  for (int y = ofsY; y < (ofsY + boxHeight); y++) {
    for (int x = ofsX; x < (ofsX + boxWidth); x++) {
      pixels[ (y * height) + x ] = color(255);
    }
  }
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

// Don't draw anything in the loop
void draw() {
  // not used
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
  color drawColor = color(127, 255, 127);
  color eraseColor = color(255);
  
  if (mouseX > ofsX && mouseX < ofsX + boxWidth) {
    loadPixels();
    if (mouseButton == LEFT) {
      pixels[ ((ofsY+inset-1)*height) + mouseX ] = drawColor;
    }
    else pixels[ ((ofsY+inset-1)*height) + mouseX ] = whiteColor;
    
    algorithm();
    updatePixels();
  }
}


void keyPressed() {
  // Clear the top input row when a key is pressed
  loadPixels();
  for (int i = ofsX; i < ofsX + boxWidth; i++) {
    pixels[ ((ofsY+inset-1)*height) + i ] = whiteColor;
  }
  algorithm();
  updatePixels();
}
