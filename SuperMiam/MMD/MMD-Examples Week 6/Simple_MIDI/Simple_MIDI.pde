import themidibus.*; 

MidiBus newBus; 

int alpha = 0;

void setup() {
  MidiBus.list();
  newBus = new MidiBus(this, 0, 1);
  size(600, 400);
  background(0);
  smooth();
  noStroke();
  fill(0);
}

void draw() {
  background(0);
  fill(255, 255, 255, alpha);
  ellipse(100, 100, 100, 100);
          // println(alpha);
}

void noteOn(int channel, int pitch, int velocity) {
  // Receive a noteOn
    if (pitch == 60) {
      alpha = velocity*2;
      println("note");
      }
}
  
void noteOff(int channel, int pitch, int velocity) {
  // Receive a noteOn
    if (pitch == 60) {
      alpha = 0;
  }
}