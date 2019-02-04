import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import oscP5.*; 
import netP5.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Bouncing_Ball_B extends PApplet {

  
  

  OscP5 oscP5;
  NetAddress myRemoteLocation;

  int pos = 100;
  int direction = 5;
  int lftrgt = -20;
  int directionB = 5;

  public void setup() {
    background(0);
    
    
    stroke(255);
    /*first start oscP5, listening for incoming messages at port 12000*/
    oscP5 = new OscP5(this, 12000);
    print(oscP5);
    /* myRemoteLocation is a NetAddress, which takes 2 parameters,
    an ip address and a port number. myRemoteLocation is used as parameter in oscP5.send() when sending osc packets to another computer, device, application.
    */
    myRemoteLocation = new NetAddress("127.0.0.1", 57120);
  };

  public void draw() {
    background(0);
    //direction = direction / 4;
    line(0, 400, 720, 400);
    ellipse(lftrgt, pos, 10, 10); // use "pos" variable as ball's "y" value
    pos += direction; // add 5 to ball's "y" value on each loop
      if((pos>399) || (pos<101)) {
        /* "||" in the above line means "or"; in other words, if "pos" (the ball's "y"
        position) is greater than 399 OR less than 101, execute the following line */
      direction *= -1; // change direction
  };

  lftrgt += directionB;
    if((lftrgt < -20) || (lftrgt > 720)) {
      directionB *= -1;
      //send an osc message everytime the ball changes direction
      OscMessage myMessage = new OscMessage("/ballLR");
      myMessage.add(random(127));
      /*this below will send the message*/
      oscP5.send(myMessage, myRemoteLocation);
    };
  }
  public void settings() {  size(720, 480);  smooth(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Bouncing_Ball_B" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
