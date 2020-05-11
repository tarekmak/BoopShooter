class Shield {
  PImage model;
  float x, y, radius;
  //This boolean indicates if the shield of the plane is activated
  boolean isOn;
  
  Shield() {
    this.model = shieldModel.copy();
    isOn = false;
    radius = dist(model.width/2, model.height/2, model.width/2, model.height - model.height * 23/556);
  }
  
  void display() {
    if (isOn) {
      x = (mouseX - model.width/2);
      y = (mouseY - model.height/2);
      image(shieldModel, x, y);
    }
  }
}
