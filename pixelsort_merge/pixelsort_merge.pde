int dimension = 200;
boolean initialFill = false;
boolean recordOutput = false;

// "Buffer" array for sorting. In fact this will be treated as the result buffer.
color[] pixelsB = new color[dimension*dimension];

// Merge sort state between loops
int width = 1;
int numberOfLists = dimension*dimension;
int index = 0;

void setup() {
  size(200,200);
  frameRate(1000);
  colorMode(HSB);
}

void draw() {
  if (!initialFill) {
    fillRandom();
    initialFill = true;
    return;
  }

  // Start merge sort outer loop
  if (width < numberOfLists) {
     mergeSortIteration();
    
    // ONLY capture frames if we are still sorting. Having saveFrame outside of this
    // block is a great way to fill your hard drive.
    if (recordOutput) {
      saveFrame("output-#####.png");
    }
  }
}

// Bottom-up sort, iterative rather than recursive so that it works better with the
// event-loop oriented nature of Processing. Perhaps it is possible to use the
// recursive versions with coroutines but this is beyond me at the moment.
// To allow each iteration of the sort to be rendered, this function can't use loops.
//
// https://en.wikipedia.org/wiki/Merge_sort
//
// I'm also using the on-screen pixel buffer as the working array to show the operations.
void mergeSortIteration() {
  if (index < numberOfLists) {
    bottomUpMerge(index, min(index+width, numberOfLists), min(index+2*width, numberOfLists));
    index = index + 2 * width;
    return;
  } else {
    index = 0;
    width *= 2;
  }
  
  arrayCopy(pixels, pixelsB);
}

void bottomUpMerge(int left, int right, int end) {
  int i = left;
  int j = right;
  
  for (int k = left; k < end; k++) {
    if (i < right && (j >= end || hue(pixelsB[i]) <= hue(pixelsB[j]))) {
      pixels[k] = pixelsB[i];
      i = i + 1;
    } else {
      pixels[k] = pixelsB[j];
      j = j + 1;    
    }
    
    // Have to update buffer pixels on every change otherwise the result
    // is left as several unmerged buffers.
    updatePixels();
  } 
}

// Functions for filling the pixels matrix with random colours.
// Fill both the on-screen pixel buffer and pixelsB with the same values.
void fillRandom() {
  loadPixels();  
  for (int i = 0; i < dimension*dimension; i++) {
    color c = randomColor();
    pixels[i] = c;
    pixelsB[i] = c;
  }
  updatePixels();
}

color randomColor() {
  return color(int(random(0,256)), 255, 255);
}
