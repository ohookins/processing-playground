class Point2D {
  int x;
  int y;
  color col;
  
  Point2D(int x, int y, color col) {
    this.x = x;
    this.y = y;
    this.col = col;
  }
}

ArrayList<Point2D> points;
int MAX_POINTS = 100;
int DIMENSION = 500;
int DESIRED_FPS = 60;
boolean DEBUGGING = false;

int currentX = 0;
int currentY = 0;

int lastFrameMillis = 0;
float maxDesiredMillis = 1000 / DESIRED_FPS;

void setup() {
  // can't define this dynamically :(
  size(500, 500);
  points = new ArrayList<Point2D>();
  
  // reset background ONCE
  background(0);
}

// should actually use dist()
float distanceBetween(int x1, int y1, int x2, int y2) {
  return sqrt(pow(x1-x2, 2) + pow(y1-y2, 2));
}

float deltaTime() {
  return millis() - lastFrameMillis;
}

// Calculate and draw one pixel of voronoi based on distance to nearest point.
// This is very inefficient as it compares to every single point rather than just those
// in the nearby vicinity with a bounding box or whatever.
void drawVoronoi() {
  // Loop until we are at the frame rate budget or have finished drawing all pixels.
  while (true) {
    Point2D bestPoint = points.get(0);
    float currentBestDistance = Float.MAX_VALUE;
    for (Point2D p : points) {
        float d = distanceBetween(currentX, currentY, p.x, p.y);
        
        if (d < currentBestDistance) {
          bestPoint = p;
          currentBestDistance = d;
        }
    }
    
    // Draw the pixel as the colour of the nearest point.
    // For some reason set() didn't work although it should be equivalent.
    pixels[currentY*DIMENSION+currentX] = bestPoint.col;
    
    // Move to the next pixel
    currentX = (currentX + 1) % DIMENSION;
    if (currentX == 0) {
      currentY = (currentY + 1) % DIMENSION;
    }
  
    // Exit if we have exceeded the budget
    if (deltaTime() >= maxDesiredMillis) return;
    
    // Exit if we have reached the beginning again
    if (currentX == 0 && currentY == 0) return;
  }
}

// Once points are established, start to randomly move them.
void movePoints() {
  if (points.size() < MAX_POINTS) return;

  for (int i = 0; i < points.size(); i++) {
    Point2D p = points.get(i);
    p.x = p.x + round(random(-1, 1));
    p.y = p.y + round(random(-1, 1));
    points.set(i, p);
    // TODO: Delete point if it goes off-screen and replace with another.
    // Or wrap to the other side.
  }
}

void drawPoints() {
  if (!DEBUGGING) return;
  
  // Draw center of each cell
  for (Point2D p : points) {
    strokeWeight(2);
    stroke(255,255,255);
    point(p.x, p.y);
  }
}

void draw() {  
  // Record the time we started drawing this frame
  lastFrameMillis = millis();
  
  // Generate random points
  if (points.size() < MAX_POINTS) {
    int x = int(random(DIMENSION));
    int y = int(random(DIMENSION));
    color col = color(int(random(255)), int(random(255)), int(random(255)));
    Point2D p = new Point2D(x, y, col);
    
    points.add(p);
  }
  
  movePoints();
  
  drawPoints();
  
  loadPixels();
  
  drawVoronoi();
  
  updatePixels();
}
