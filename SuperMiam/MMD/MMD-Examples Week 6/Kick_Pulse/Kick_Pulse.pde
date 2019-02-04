import themidibus.*;

kick k1;
hat h1;
MidiBus newBus;

int alpha = 0, hAlpha = 0;
int kShow = 0, hShow = 0; // show / hide shapes
int x1, x2;

void setup() {
  MidiBus.list();
  newBus = new MidiBus(this, 0, 1);
  size(600, 400);
  background(0);
  noStroke();
  k1 = new kick(width/2, height/2);
  h1 = new hat(0, height);
}

void draw() {
  background(0);
  if (kShow == 1) {
  k1.display();
  }
  if (kShow == -1) {
    k1.display();
    k1.fade();
  }
  if (hShow == 1) {
  h1.display(x1, x2);
  }
  if (hShow == -1) {
    h1.display(x1, x2);
    h1.fade();
  }

}

void noteOn(int channel, int pitch, int velocity) {
  if (pitch == 60) {
    kShow = 1;
    alpha = velocity*2;
  }
  if (pitch == 61) {
    //x1 = 300;
    x1 = 290+int(random(20));
    x2 = x1;
    hAlpha = 255;
    hShow = 1;
  }
}

void noteOff(int channel, int pitch, int velocity) {
  if (pitch == 60) {
    kShow = -1;
  }
  if (pitch == 61) {
    hShow = -1;
    // println("noteoff");
  }
  
}