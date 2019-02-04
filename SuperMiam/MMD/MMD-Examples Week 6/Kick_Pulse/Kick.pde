class kick {
  // fields
  int x;
  int y;
  float size;
  // constructor
  kick (int _x, int _y) {
    x = _x;
    y = _y;
  }
  
  // methods
  
  void display() {
    noStroke();
    size = 100+random(10);
    fill(255, 255, 255, alpha);
    ellipse(x, y, size, size);
  }
  
  void fade() {
    if (alpha > 0) {
      alpha-=7;
    }
  }
}