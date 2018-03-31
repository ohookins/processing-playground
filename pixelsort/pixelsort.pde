int dimension = 200;
int x, y = 0;
boolean initialFill = false;
boolean sorted = false;
int speedFactor = 10;
boolean recordOutput = false;

void setup() {
  size(200, 200);
  //frameRate(100);
}

void draw() {
  if (!initialFill) {
    fillRandom();
    initialFill = true;
  }
  
  if (!sorted) {
    sortIteration();
  }
  
  if (recordOutput) {
    saveFrame("output-#####.png");
  }
}

void fillRandom() {
  loadPixels();
  
  for (int i = 0; i < dimension*dimension; i++) {
    pixels[i] = randomColor();
  }

  updatePixels();
}

void sortIteration() {
  loadPixels();

  sorted = true;
 
  for (int j = 0; j < speedFactor; j++) {
    for (int i = 0; i < (dimension*dimension-1); i++) {
      if (hue(pixels[i]) < hue(pixels[i+1])) {
        sorted = false;
        color temp = pixels[i];
        pixels[i] = pixels[i+1];
        pixels[i+1] = temp;
      }
    }
    
    if (sorted) {
      break;
    }
  }
  
  updatePixels();
}

color randomColor() {
  return color(int(random(0,256)), int(random(0,256)), int(random(0,256)));
}
