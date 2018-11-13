import ddf.minim.analysis.*;
import ddf.minim.*;
import oscP5.*;
import netP5.*;

OscP5 oscp5;
NetAddress dest;

int OSC_SEND_TO = 12345;

// this IP address connects to same computer
String destination = "127.0.0.1";

// this is the broadcast IP it will send the message to 
// all computers in the 192.168.8.xx network.
//String destination = "192.168.8.255";


Minim minim;  
AudioInput in;
FFT fft;

float []kfactor;
int kindex;

void setup() {
  size(400, 300);
  
  // start oscP5, listening for incoming messages at port in number
  oscp5 = new OscP5(this, 54321);
  dest = new NetAddress(destination, OSC_SEND_TO);

  // create a buffer to store calculation of blowing strength
  kfactor = new float[width];
  
  // initialize the audio part
  minim = new Minim(this);  // this initializes the audio engine
  in = minim.getLineIn();  // this captures microphone input
  fft = new FFT(in.bufferSize(), in.sampleRate()); // this performs analysis on the frequency domain
}

// dispatch the message as an OSC message
void osc_dispatch_value(float val) {
  OscMessage msg = new OscMessage("/blowforce");
  msg.add(val); // add a parameter to our message
  // send the message
  oscp5.send(msg, dest); 
}

int get_index() {
  if(kindex == 0) return 0;
  if(kindex > width-1) return (width % kindex);
   else return kindex;
}

int inc_index() {
  kindex++;
  if(kindex > width) kindex = 0;
  return kindex;
}

void draw() {
  background(0);
  stroke(255);
 
  // draw the waveforms so we can see what we are monitoring
  for(int i = 0; i < in.bufferSize() - 1; i++)
  {
    line( i, 50 + in.left.get(i)*50, i+1, 50 + in.left.get(i+1)*50 );
    line( i, 150 + in.right.get(i)*50, i+1, 150 + in.right.get(i+1)*50 );
  }
  
  String monitoringState = in.isMonitoring() ? "enabled" : "disabled";
  text( "Input monitoring is currently " + monitoringState + ".", 5, 15 );
  
  stroke(255, 255, 0);
  
  // perform a forward FFT on the samples in jingle's mix buffer,
  // which contains the mix of both the left and right channels of the file
  fft.forward( in.mix );
  
  for(int i = 0; i < fft.specSize(); i++) {
    // draw the line for frequency band i, scaling it up a bit so we can see it
    line( i, height, i, height - fft.getBand(i)*8 );
  }
  
  float blowp = 0;
  for(int j = 0; j < 3; j++) {
    blowp = blowp + fft.getBand(j);
    //blowp = blowp / 30;
  }
  blowp = blowp / 30;
  //println(blowp);
  
  int idx = get_index();
  kfactor[idx] = blowp;
  inc_index();

    stroke(0, 255, 0);
    
  // draw the blowing-detection buffer
  for(int i = 0; i < width-1; i++) {
    line( i, 250 + kfactor[i]*50, i+1, 250 - kfactor[i+1]*50 );
  } // for
  
  if(blowp > 0.5) {
    println("Sending stuff");
    osc_dispatch_value(blowp);
  }
} // draw