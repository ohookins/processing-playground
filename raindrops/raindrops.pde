/*
 * Now spawn the droplets at random locations, with a perspective trick,
 * to simulate raindrops.
 */

import java.util.AbstractList;

final color bgColor = color(0, 0, 0, 255);
final int DIMENSION = 400;
final float spawnProbability = 0.2;
ArrayList<Droplet> droplets = new ArrayList<Droplet>();

// An expanding proximity droplet that knows how to render itself. It is
// expected to be centered on the location of the mouse click.
class Droplet {
  color dropletColor = color(255, 255, 255, 255);

  // Origin coordinates and size of the droplet, which are randomly determined.
  int x;
  int y;
  final int maxSizeFactor = 30;
  final int maxSize = 50;
  int currentSize;
  int initialSize;

  // Flag to indicate whether the droplet can be cleaned up.
  public boolean alive = true;

  public Droplet() {
    x = round(random(0, DIMENSION));
    y = round(random(0, DIMENSION));

    // Initial current size depending on how close the droplet was spawned to
    // the bottom edge.
    currentSize = initialSize = maxSize - round(maxSize*((float(DIMENSION-y)/DIMENSION)));
  }

  public void draw() {
    // Exit early if we are awaiting cleanup.
    if (!alive) return;

    // Draw the droplet with a progressively dimming color (on alpha channel)
    dropletColor = color(255, 255, 255, 255 - currentSize*2);
    noFill();
    stroke(dropletColor);
    strokeWeight(2);
    ellipse(x, y, currentSize, currentSize/4);

    // Remove the object from the collection if it has reached the maximum size.
    currentSize += 1;
    if (currentSize > initialSize*maxSizeFactor) {
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

  // Randomly spawn new droplet somewhere in the window.
  if (random(0, 1) <= spawnProbability) {
    droplets.add(new Droplet());
  }

  // To avoid needing safe concurrent access to the droplet list, if any droplets
  // need cleaning up, we build a separate list dudroplet this loop for
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