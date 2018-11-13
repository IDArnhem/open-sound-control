import java.util.*;
import oscP5.*;
import netP5.*;
  
OscP5 oscp5;
PImage img;

int OSC_LISTEN_ON = 12345;

int BALLOON_MIN_SIZE = 40;
int BALLOON_MAX_SIZE = 400;

float step = 0;
float blowf = 0;
long lastUpdated = 0;

int MAX_BUBBLES = 100;
List <Bubble>bubbles;
int bidx = 0; // index pointing to the current bubble
PVector source;

void setup() {
  size(1024, 600);
  frameRate(25);

  // start oscP5, listening for incoming messages at port in OSC_LISTEN_ON variable
  oscp5 = new OscP5(this, OSC_LISTEN_ON);

  source = new PVector();
  source.set(0, height / 2);

  bubbles = new ArrayList<Bubble>();
  for(int i = 0; i < MAX_BUBBLES; i++) {
    Bubble b = new Bubble();
    b.pos.set( -200, -200 );
    bubbles.add(b);
  }
  
  img = loadImage("bubble005.png");
}

void draw() {
  background(0);
  stroke(255);

  if( millis() > (lastUpdated + 120) ) {
    blowf = 0;
  }
  
  if(blowf > 0) {
    Bubble cb = bubbles.get(bidx++);
    cb.pos.set( source );
    float vx = map(blowf, 0.0, 10, 20, 44) * random(1.0, 1.82);
    cb.vel.set(vx, random(-8, 5));
    if( bidx >= bubbles.size() ) bidx = 0;
  }
  
  // update and draw all bubbles
  for(Bubble b : bubbles) {
    b.update();
    b.draw();
  }
}

// every time an OSC message is received by this sketch, it will be processed 
// by this method
void oscEvent(OscMessage msg) {
  if(msg.addrPattern().contains("/blowforce")) {
    blowf = msg.get(0).floatValue();
    lastUpdated = millis();

    // print the address pattern and the typetag of the received OscMessage */
    print("### received blow force");
    print(" addrpattern: " + msg.addrPattern());
    println(" typetag: " + blowf);
  } else {
    // unknown
    print("### unknown message");
    print(" addrpattern: " + msg.addrPattern());
    println(" typetag: " + msg.typetag());
  }
}