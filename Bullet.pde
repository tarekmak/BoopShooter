class Bullet {
  float x, y;
  boolean done = false; 
  PImage model, blurredModel;
  
  Bullet(float x, float y) {
    this.model = bulletModel.copy();//loadImage("bullet.png");
    
    model.resize(200, 200);
    this.blurredModel = blurredBulletModel.copy();
    this.x = (x - model.width/2 - model.width * 3/64);
    this.y = (y - model.height/2);
  }
  
  void move() {
    if (y > -50 && !done) {
      y -= 5;
      if (!blurred) {
        image(model, x, y);
      } else {
        image(blurredModel, x, y);
      }
    } else {
      done = true;
    }
  }
}
