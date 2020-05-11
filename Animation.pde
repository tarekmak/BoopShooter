//Inspired by https://processing.org/examples/animatedsprite.html
class Animation {
  PImage[] images, blurredImages;
  int imageCount;
  int frame;
  
  Animation(String imagePrefix, int count) {
    imageCount = count;
    images = new PImage[imageCount];
    
    
    for (int i = 0; i < imageCount; i++) {
      String filename = imagePrefix + nf(i, 2) + "_delay-0.03s" + ".gif";
      images[i] = loadImage(filename);
      images[i].resize(width, height);
      //blurredImages[i] = images[i].copy();
      //blurredImages[i] = initBlurred(images[i]);
    }
  }

  void display(float xpos, float ypos) {
    frame = (frame+1) % imageCount;
    
    if (blurred && blurredImages != null) {
      image(blurredImages[frame], xpos, ypos);
    } else {      
      image(images[frame], xpos, ypos);
    }
  }
  
  int getWidth() {
    return images[0].width;
  }
  
  void loadBlurredVersion() {
    blurredImages = new PImage[imageCount];
    for (int i = 0; i < imageCount; i++) {
      blurredImages[i] = images[i].copy();
      blurredImages[i] = initBlurred(images[i]);
    }
  }
  
}
