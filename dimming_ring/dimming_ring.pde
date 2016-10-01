/* While playing Pokémon Go, I wondered how hard it would be to recreate
 * the proximity ring that orbits most objects, in Processing. Turns out,
 * it's not so hard (at least in the simplest, least flexible implementation
 * of it).
 */

int minDiameter = 20;
int maxDiameter = 300;
int currentDiameter = 20;

color bgColor = color(200, 200, 200);
color ringColor = color(200, 0, 0, 255);

int DIMENSION = 400;

void settings() {
  size(DIMENSION, DIMENSION);
}

void setup() {
  noStroke();
  background(bgColor);
}

void draw() {
  // Clear the display
  background(bgColor);
  
  // Draw the outer ring with a progressively dimming color (on alpha channel)
  ringColor = color(200, 0, 0, 255 - currentDiameter/1.2);
  fill(ringColor);
  ellipse(DIMENSION/2, DIMENSION/2, currentDiameter, currentDiameter);
  
  // Fill the inner to make the first ellipse appear as a ring
  fill(bgColor);
  ellipse(DIMENSION/2, DIMENSION/2, currentDiameter - 20, currentDiameter - 20);

  // Reset the size when we get to the maximum
  currentDiameter += 2;
  if (currentDiameter > maxDiameter) {
      currentDiameter = minDiameter;
  }
}