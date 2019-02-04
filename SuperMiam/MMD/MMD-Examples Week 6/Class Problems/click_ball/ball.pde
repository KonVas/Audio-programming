class Ball {
  // int x, y;
  Ball() {
  }
  /*
  void drop() {
    if (y<400) {
      y++;
    }
  }
  */
  void display(int x, int y) {
    ellipse(x, y, 100, 100);
  }
}