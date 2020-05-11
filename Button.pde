class Button {
  int x, y, w, h;
  String text;
  boolean clicked;
  
  Button(String text, int x, int y,int w, int h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    clicked = false;
    this.text = text;
    
  }
  
  void display() {
    if (isOver()) {
      fill(150);
    } else {
      fill(170);
    }
    rectMode(CENTER);
    rect(x, y, w, h);
    
    fill(255);
    textSize(50);
    textAlign(CENTER);
    text(text, x, y+h/4);
  }
  
  
  boolean isOver() {
    if (mouseX >= x-w/2 && mouseX <= x + w/2 && mouseY >= y-h/2 && mouseY <= y + h/2) {
      return true;
    }
    return false;
  }
  
  //This method is only gonna be called in the mouseClicked() method from the main program 
  //so it is sufficient to verify that the mouse is over the button to know if it has been clicked
  boolean isClicked() {
    if (isOver()) {
      clicked = true;
      
      return true;
    }
    return false;
  }
}
