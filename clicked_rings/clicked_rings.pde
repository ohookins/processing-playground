/*
 * This version of proximity rings allows you to place them with the
 * mouse pointer. Its main flaw is that overlapping rings overwrite
 * each other (I lazily used the alpha channel instead of actually
 * fading properly to the background colour). If the alpha channel
 * was used properly, they could overlap gracefully.
 */

import java.util.AbstractList;

final color bgColor = color(0, 0, 0, 255);
final int DIMENSION = 400;
ArrayList<ProximityRing> proximityRings = new ArrayList<ProximityRing>();

// An expanding proximity ring that knows how to render itself. It is
// expected to be centered on the location of the mouse click.
class ProximityRing {
  final int minDiameter = 10;
  final int maxDiameter = 100;
  int currentDiameter = 10;
  color ringColor = color(255, 255, 255, 255);
  
  // Origin coordinates of the ring
  int x;
  int y;
  
  public ProximityRing(int x, int y) {
    this.x = x;
    this.y = y;
  }
  
  public void draw() {
    // Draw the outer ring with a progressively dimming color (on alpha channel)
    ringColor = color(255, 255, 255, 255 - currentDiameter*3.5);
    noFill();
    stroke(ringColor);
    strokeWeight(5);
    ellipse(x, y, currentDiameter, currentDiameter);
    
    // Reset the size when we get to the maximum
    currentDiameter += 1;
    if (currentDiameter > maxDiameter) {
      currentDiameter = minDiameter;
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
  
  // Iterate through each ring, drawing them. The rings
  // maintain their own state between calls.
  for (ProximityRing ring : proximityRings) {
    ring.draw();
  }
}

// Create a new ring wherever the mouse is clicked
void mousePressed() {
  println("Mouse pressed at: " + mouseX + "," + mouseY);
  proximityRings.add(new ProximityRing(mouseX, mouseY));
}