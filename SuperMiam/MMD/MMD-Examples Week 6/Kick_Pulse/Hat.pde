class hat {
  // fields;
  int x1, x2;
  int y1, y2;
  
  // constructor
  hat (int _y1, int _y2) {
    y1 = _y1;
    y2 = _y2;
  }
  // methods
  void display(int x1, int x2) {
    noFill();
    stroke(255, 255, 255, hAlpha);
    line(x1, y1, x2, y2);
  }
  
  void fade() {
    if (hAlpha > 0) {
      hAlpha -= 20;
    }
}
}