class Meteorite {
  float x, y;
  float speedHor, speedVer, radius;
  boolean out;
  PImage model, blurredModel;
  
  //abstract boolean isHit();
  //abstract boolean HitPlayer();
  
  Meteorite() {
    this.x = random(1, width);
    this.y = -30;
    
    this.speedHor = random(2*difficulty, 3*difficulty);
    float rand = random(1);
    if (rand < .5) {
      this.speedVer = random(-3*difficulty, -2*difficulty);
    } else {
      this.speedVer = random(2 * difficulty, 3*difficulty);
    }
    out = false;
    rand = random(0, 1);
    if (rand < .25) {
      this.model = meteoritesTypes[0].copy();
      this.blurredModel = blurredMet[0].copy();
    } else if (rand < .5) {
      this.model = meteoritesTypes[1].copy();
      this.blurredModel = blurredMet[1].copy();
    } else if (rand < .75) {
      this.model = meteoritesTypes[2].copy();
      this.blurredModel = blurredMet[2].copy();
    } else {
      this.model = meteoritesTypes[3].copy();
      this.blurredModel = blurredMet[3].copy();
    }
    radius = dist(x + model.width/2 - 10, y + model.height/2 - 10, x + model.width - 10, y + model.height/2 - 10);
    
    //color bc = blurredModel.get(1,1);
    //color c = model.get(1,1);
    //print("Blurred Red: " + red(bc) + "\nBlurred Blue: "  + blue(bc) + "\nBlurred Green: " + green(bc) + "\n\n");
    //print("Red: " + red(c) + "\nBlue: "  + blue(c) + "\nGreen" + green(c) + "\n");
  }
  
  boolean isHit() {
    if (p1 != null) {
     
      for (int i = 0; i < p1.bullets.size(); i++) {
        if (dist(p1.bullets.get(i).x + p1.bullets.get(i).model.width/2, p1.bullets.get(i).y + p1.bullets.get(i).model.height/4, x + model.width/2 - 10, y + model.height/2 - 10) < dist(x + model.width/2 - 10, y + model.height/2 - 10, x + model.width - 10, y + model.height/2 - 10)) {
          //out = true;
          p1.bullets.get(i).done = true;
          image(explo, x + model.width/2, y + model.height/2);
          bonus += 10000;
          fill(0, 255, 0);
          text("+10 000", 0, 120);
          return true;
        }
      }

      if (p1.s.isOn) {
        //Inspired by https://processing.org/examples/circlecollision.html
        PVector metPos = new PVector(x + model.width/2 - 10, y + model.height/2 - 10);
        PVector shieldPos = new PVector(p1.s.x + p1.s.model.width/2, p1.s.y + p1.s.model.height/2);
        
        
        // Get distances between the shield and meteorite models
        PVector distanceVect = PVector.sub(shieldPos, metPos);
    
        // Calculate magnitude of the vector separating the shield and meteorite
        float distanceVectMag = distanceVect.mag();
    
        // Minimum distance before the shield and the meteorite are touching
        float minDistance = radius + p1.s.radius;
        
        if (distanceVectMag < minDistance) {
          image(explo, x + model.width/2, y + model.height/2);
          bonus += 10000;
          fill(0, 255, 0);
          text("+10 000", 0, 120);
          return true;
        }
      }
    }
    return false;
  }
  
  //165 108
  
  boolean HitPlayer() {
    //Setting up the hitbox of the plane
    if (p1 != null && dist(p1.x + p1.model.width/2, p1.y + p1.model.height/2, x + model.width/2 - 10, y + model.height/2 - 10) < dist(x + model.width/2 - 10, y + model.height/2 - 10, x + model.width - 10, y + model.height/2 - 10) 
        || dist(p1.x + p1.model.width/2, p1.y, x + model.width/2 - 10, y + model.height/2 - 10) < dist(x + model.width/2 - 10, y + model.height/2 - 10, x + model.width - 10, y + model.height/2 - 10)
        || dist(p1.x, p1.y + p1.model.height/2 + p1.model.height * 9/46, x + model.width/2 - 10, y + model.height/2 - 10) < dist(x + model.width/2 - 10, y + model.height/2 - 10, x + model.width - 10, y + model.height/2 - 10)
        || dist(p1.x + p1.model.width, p1.y + p1.model.height/2 + p1.model.height * 9/46, x + model.width/2 - 10, y + model.height/2 - 10) < dist(x + model.width/2 - 10, y + model.height/2 - 10, x + model.width - 10, y + model.height/2 - 10)
        || dist(p1.x + p1.model.width/6, p1.y + p1.model.height/2 + p1.model.height * 3/46, x + model.width/2 - 10, y + model.height/2 - 10) < dist(x + model.width/2 - 10, y + model.height/2 - 10, x + model.width - 10, y + model.height/2 - 10)
        || dist(p1.x + p1.model.width * 5/6, p1.y + p1.model.height/2 + p1.model.height * 3/46, x + model.width/2 - 10, y + model.height/2 - 10) < dist(x + model.width/2 - 10, y + model.height/2 - 10, x + model.width - 10, y + model.height/2 - 10)
        || dist(p1.x + p1.model.width/2, p1.y + p1.model.height, x + model.width/2 - 10, y + model.height/2 - 10) < dist(x + model.width/2 - 10, y + model.height/2 - 10, x + model.width - 10, y + model.height/2 - 10)) {
      out = true;
      p1.life--;
      image(explo, p1.x, p1.y);
      if (p1.life  > 0) {
        blurred = true;
        blurTime = millis();
      }
      explo = blurredExplo.copy();
      return true;
    }
    return false;
  }
  
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
