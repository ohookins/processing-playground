int dimension = 256;
int x, y = 0;
boolean initialFill = false;
boolean sorted = false;
int speedFactor = 10;
boolean recordOutput = false;

void setup() {
  size(256, 256);
  colorMode(HSB);
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
        swapPixels(i, i + 1);
      }
    }
    
    if (sorted) {
      break;
    }
  }
  
  updatePixels();
}

void swapPixels(int a, int b) {
  color temp = pixels[a];
  pixels[a] = pixels[b];
  pixels[b] = temp;
}

color randomColor() {
  return color(int(random(0,256)), 255, 255);
}
