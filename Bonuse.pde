abstract class Bonuse {
  float x, y;
  boolean out;
  float speedHor, speedVer;
  PImage model, blurredModel;
  
  Bonuse() {
    this.x = random(1, width);
    this.y = -30;
    this.speedHor = random(2*difficulty, 3*difficulty);
    float rand = random(1);
    if (rand < .5) {
      this.speedVer = random(-3*difficulty, -2*difficulty);
    } else {
      this.speedVer = random(2*difficulty, 3*difficulty);
    }
    out = false;
  }
  
  boolean isHit() {
    if (p1 != null) {
      for (int i = 0; i < p1.bullets.size(); i++) {
        if (dist(p1.bullets.get(i).x + p1.bullets.get(i).model.width/2, p1.bullets.get(i).y + p1.bullets.get(i).model.height/4, x + model.width/2, y + model.height/2) < dist(x + model.width/2, y + model.height/2, x + model.width, y + model.height/2)) {
         // out = true;
          p1.bullets.get(i).done = true;
          return true;
        }
      }
    }
    return false;
  }
  
  
  boolean HitPlayer() {
    //Setting up the hitbox of the plane (values were gotten from paint)
    if (p1 != null && dist(p1.x + p1.model.width/2, p1.y + p1.model.height/2, x + model.width/2, y + model.height/2) < dist(x + model.width/2, y + model.height/2, x + model.width, y + model.height/2) 
        || dist(p1.x + p1.model.width/2, p1.y, x + model.width/2, y + model.height/2) < dist(x + model.width/2, y + model.height/2, x + model.width, y + model.height/2)
        || dist(p1.x, p1.y + p1.model.height/2 + p1.model.height * 9/46, x + model.width/2, y + model.height/2) < dist(x + model.width/2, y + model.height/2, x + model.width, y + model.height/2)
        || dist(p1.x + p1.model.width, p1.y + p1.model.height/2 + p1.model.height * 9/46, x + model.width/2, y + model.height/2) < dist(x + model.width/2, y + model.height/2, x + model.width, y + model.height/2)
        || dist(p1.x + p1.model.width/6, p1.y + p1.model.height/2 + p1.model.height * 3/46, x + model.width/2, y + model.height/2) < dist(x + model.width/2, y + model.height/2, x + model.width, y + model.height/2)
        || dist(p1.x + p1.model.width * 5/6, p1.y + p1.model.height/2 + p1.model.height * 3/46, x + model.width/2, y + model.height/2) < dist(x + model.width/2, y + model.height/2, x + model.width, y + model.height/2)
        || dist(p1.x + p1.model.width/2, p1.y + p1.model.height, x + model.width/2, y + model.height/2) < dist(x + model.width/2, y + model.height/2, x + model.width, y + model.height/2)) {
      out = true;
      giveBonuse();
      return true;
    }
    return false;
  }
  
  abstract void giveBonuse();
  
  void move() {
    if (y < height && (x > 0 || x < width) && !out) {
      y += speedHor;
      x += speedVer;
      if (!blurred) {
        image(model, x, y);
      } else {
        image(blurredModel, x, y);
      }
      out = isHit();
      if (!out) {
        out = HitPlayer();
      }
    } else {
      out = true;
    }
  }
}
