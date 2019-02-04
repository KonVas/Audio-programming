/* Click the box and it disappears


.... code below... 















*/

void setup() {
  size(400, 400);
  background(0);
  fill(200);
  noStroke();
}


void draw() {
  rect(100, 100, 25, 25);
}

void mousePressed() {
  if (mouseX > 100 && mouseX < 125 && mouseY>100 && mouseY<125) {
    fill(0);
  }
  else {
    fill(200);
  }
}