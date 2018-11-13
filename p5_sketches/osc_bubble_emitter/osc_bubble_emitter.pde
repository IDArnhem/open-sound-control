import java.util.*;
import oscP5.*;
import netP5.*;
  
OscP5 oscp5;
PImage img;

// network port to listen to incoming messages to
int OSC_LISTEN_ON = 12345; 

float step = 0;
float blowf = 0;
long lastUpdated = 0;

int MAX_BUBBLES = 500;
List <Bubble>bubbles;
int bidx = 0; // index pointing to the current bubble
PVector source;

void setup() {
  size(1024, 600);
  frameRate(25);

  // start oscP5, listening for incoming messages at port in OSC_LISTEN_ON variable
  oscp5 = new OscP5(this, OSC_LISTEN_ON);

  // this the point in the screen where all the 
  // bubbles originate from
  source = new PVector();
  source.set(0, height / 2);

  // create an array to store all the bubbles
  bubbles = new ArrayList<Bubble>();
  for(int i = 0; i < MAX_BUBBLES; i++) {
    Bubble b = new Bubble();
    // at first we put the bubbles outside of the visible canvas
    b.pos.set( -200, -200 );
    bubbles.add(b);
  }

  // load the image from disk that will be the basis for our bubbles
  img = loadImage("bubble005.png");
}

void draw() {
  background(0);
  stroke(255);

  // timeout since a blowing action was last detected
  // we keep bubbling for a few milliseconds longer
  if( millis() > (lastUpdated + 120) ) {
    blowf = 0;
  }

  // if somebody is blowing (or if the blowf is greater than zero)
  if(blowf > 0) {
    Bubble cb = bubbles.get(bidx++);
    cb.pos.set( source );
    // make new speed of bubble proportional to blowing force
    // and give it some randomness so not all bubbles are the same
    float vx = map(blowf, 0.0, 10, 20, 44) * random(1.0, 1.82);
    // spread the bubbles on the Y axis a little
    cb.vel.set(vx, random(-8, 5));
    
    // if the index of our current bubble has reached the end
    // go back to the beginning of our bubble list
    if( bidx >= bubbles.size() ) bidx = 0;
  }
  
  // update and draw all bubbles
  for(Bubble b : bubbles) {
    b.update();
    b.draw();
  }
} // draw

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