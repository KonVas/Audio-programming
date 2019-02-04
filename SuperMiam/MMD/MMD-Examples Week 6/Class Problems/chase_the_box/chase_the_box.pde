/* Click the box and it moves to another part of the screen


.... code below... 















*/

int x, y;

void setup() {
  size(400, 400);
  background(0);
  fill(200);
  noStroke();
  x = int(random(width));
  y = int(random(height));
}


void draw() {
  rect(x, y, 25, 25);
}

void mousePressed() {
  if (mouseX > x && mouseX < (x+25) && mouseY> y && mouseY<(y+25)) {
    //fill(0);
    background(0);
    x = int(random(width));
    y = int(random(height));
  }
  /*else {
    fill(200);
  }*/
}