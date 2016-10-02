/*
 * Now spawn the droplets at random locations, with a perspective trick,
 * to simulate raindrops.
 * If you move the mouse in the window it also affects the rate of rainfall.
 */

import java.util.AbstractList;

final color bgColor = color(0, 0, 0, 255);
final int DIMENSION = 400;
float spawnProbability = 0.2;
ArrayList<Droplet> droplets = new ArrayList<Droplet>();

// An expanding droplet that knows how to render itself. It is
// expected to be centered on the location of the mouse click.
class Droplet {
  color dropletColor;

  // initialSize is the same for all droplets
  // maxSize 
  final int initialSize = 1;
  final int maxSize = 100;

  // Origin coordinates which are randomly determined.
  int x;
  int y;

  int currentSize;
  
  // Some ratios to help calculate sizes and lifetimes
  float sizeRatio;
  float lifetimeRatio;

  // Flag to indicate whether the droplet can be cleaned up.
  public boolean alive = true;

  public Droplet() {
    x = round(random(0, DIMENSION));
    y = round(random(0, DIMENSION));
    
    // Base the ratios on the distance along y axis:
    // 0.0 is smallest and shortest lifetime
    // 1.0 is largest and longest lifetime
    sizeRatio = float(y)/DIMENSION;
    lifetimeRatio = 1 - sizeRatio;
  }

  public void draw() {
    // Exit early if we are awaiting cleanup.
    if (!alive) return;

    // Draw the droplet with a progressively dimming color (on alpha channel)
    dropletColor = color(255, 255, 255, 255 - currentSize*20*lifetimeRatio);
    noFill();
    stroke(dropletColor);
    strokeWeight(2);
    ellipse(x, y, currentSize, currentSize/3);

    // Remove the object from the collection if it has reached the maximum size.
    currentSize += 3*sizeRatio;
    if (currentSize > maxSize*sizeRatio) {
      alive = false;
    }
  }
}

void settings() {
  size(DIMENSION, DIMENSION);
}

void setup() {
  background(bgColor);
}

void draw() {
  // Clear the display
  background(bgColor);

  // Draw some simple background stuff
  drawBackground();
  
  // Randomly spawn new droplet somewhere in the window.
  if (random(0, 1) <= spawnProbability) {
    droplets.add(new Droplet());
  }

  // To avoid needing safe concurrent access to the droplet list, if any droplets
  // need cleaning up, we build a separate list in this loop for
  // later cleanup.
  ArrayList<Integer> cleanupList = new ArrayList<Integer>();

  // Iterate through each droplet, drawing them. The droplets
  // maintain their own state between calls.
  for (Droplet droplet : droplets) {
    if (droplet.alive) {
      droplet.draw();
    } else {
      // If the droplet is awaiting cleanup, record its index.
      cleanupList.add(droplets.indexOf(droplet));
    }
  }

  // Now clean up any candidate droplets
  for (Integer idx : cleanupList) {
    droplets.remove(idx);
  }
}

// Draw some simple shapes to try to make it look like a scene
void drawBackground() {
  strokeWeight(10);
  stroke(70,70,70);
  line(0,117,DIMENSION,117);
  stroke(30,30,30);
  line(0,120,DIMENSION,120);
  fill(color(35,35,35));
  noStroke();
  rect(0,0,DIMENSION,85);
  fill(color(100,100,100));
  ellipse(60,95,70,15);
  ellipse(200,95,70,15);
  ellipse(340,95,70,15);
  
  // Draw the current probability of rainfall
  textSize(20);
  fill(color(120,120,120));
  text("Rain probability: " + spawnProbability, 10,20);
}

// Moving the mouse around the window changes the probability of rain.
// Bottom == 1.0, Top == 0.0
void mouseMoved() {
  spawnProbability = float(mouseY)/DIMENSION;
}