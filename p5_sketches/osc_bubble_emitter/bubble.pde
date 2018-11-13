public class Bubble {

  public PVector vel;
  public PVector acc;
  public PVector pos;
  public float step;
  
  public Bubble() {
    step = 0;
    acc = new PVector(-0.2, -0.1);
    pos = new PVector(0, 0);
    vel = new PVector(random(6, 10), 0);
  }

  public void update() {
    // change speed
    vel.x += acc.x;
    vel.y += acc.y;
    // change position    
    pos.x += vel.x;
    pos.y += vel.y;
  }

  public void draw() {
    imageMode(CENTER);
    step += 0.001;
    float xpos = pos.x;
    float ypos = pos.y;
    float disp = noise(step);
    xpos = xpos * disp;
    image(img, xpos, ypos); //, 150, 150);
  }
} // class
