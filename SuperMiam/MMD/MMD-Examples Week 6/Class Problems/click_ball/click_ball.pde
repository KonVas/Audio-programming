Ball b1;
Rect r1;
// int x, y;

void setup() {
  size(400, 400);
  b1 = new Ball();
  r1 = new Rect();
}

void draw() {
  //b1.display();
}

void mousePressed() {
  background(204);
  b1.display(mouseX, mouseY);
  r1.display(mouseX, mouseY);
}
