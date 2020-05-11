class Plane {
  int life;
  PImage model, blurredModel;
  float x, y;
  boolean dead;
  ArrayList<Bullet> bullets;
  Shield s;
  
  Plane() {
    this.model = loadImage("plane.png");
    model.resize(132, 184); // 132 184
    blurredModel = model.copy();
    blurredModel = initBlurred(model);
    this.life = 5;
    this.bullets = new ArrayList<Bullet>();
    dead = false;
    s = new Shield();
  }
  
  void move() {
    x = (mouseX - model.width/2);
    y = (mouseY - model.height/2);
    if (!blurred) {
      image(model, x, y);
    } else {
      image(blurredModel, x, y);
    }
    
    s.display();
  }
  
}
