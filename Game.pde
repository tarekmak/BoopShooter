import processing.sound.*;
SoundFile boop, menuMusic, planeFlying, deathMusic;

Plane p1;
PImage heart, explo, soundOn, soundOff;
PImage logo;
PImage[] meteoritesTypes, blurredMet;
ArrayList<Meteorite> meteorites;
ArrayList<Button> buttons;
ArrayList<Bonuse> bonuses;
int score, highscore, oldscores;
Animation back, loading;

boolean blurred = false;

int bonus, start;

float lastshot, blurTime, shieldTime;

boolean changeBackMusic, mute;

Button retry;

float[][] blur_filter = {{1.0/9, 1.0/9, 1.0/9},
                         {1.0/9, 1.0/9, 1.0/9},
                         {1.0/9, 1.0/9, 1.0/9}};
                         
//This string indicates which screen we're at                         
String screen;

//This integer represents the difficulty mode (.5 for easy, 1 normal and 1.5) which has effects on the speed and the frequency of the meteorites of the game
float difficulty;

//Generated in main file setup() so we don't have to load images multiple times (which would cause a drop in framerates and sometimes crash the program)
PImage bulletModel, blurredBulletModel, blurredExplo, normalExplo, shieldIcon, blurredShieldIcon, lifeIcon, blurredLifeIcon, shieldModel;

int setUpStage;

void setup() {
  size(1500, 900);
  setUpStage = 0;
  loading = new Animation("loadingFrames/frame_", 12);
  //menuMusic.loop();
}

void draw() {

  //Inspired by https://forum.processing.org/one/topic/how-to-show-loading-text-while-application-is-launching.html
  //https://www.processing.org/reference/thread_.html
  switch (setUpStage) {
    case 0:
      setUpStage++;
      thread("doSetUp");
      return;
    case 1:
      loading.display(0, 0);
      return;
    case 2:
      back.display(0, 0);
      sound();
      if (("MENU").equals(screen)) {
        menuScreen();
      } else if (("PLAY").equals(screen)) {
        playScreen();
      } else if (("RETRY").equals(screen)) {       
        retryScreen();  
      } else if (("DIFFICULTY(From menu)").equals(screen)) {
        difficultyFromMenu();
      } else if (("DIFFICULTY(From retry)").equals(screen)) {
        difficultyFromRetry();
      } else if (("PAUSE").equals(screen)) {
        pauseScreen();
      }
      return;
  }
}

void doSetUp() {
  logo = loadImage("logo.png");
  logo.resize(width/3, width/3);
  soundOn = loadImage("soundOn.png");
  soundOn.resize(70, 70);
  soundOff = loadImage("soundOff.png");
  soundOff.resize(70, 70);
   
  shieldIcon = loadImage("shieldIcon.png");
  shieldIcon.resize(70, 70);
  blurredShieldIcon = initBlurred(shieldIcon);
  
  lifeIcon = loadImage("lifeIcon.png");
  lifeIcon.resize(70, 70);
  blurredLifeIcon = initBlurred(lifeIcon);
   
  shieldModel = loadImage("shield.png");
  shieldModel.resize(width/5, width/5);
   
  back = new Animation("backgroundFrames/frame_", 29);
  back.loadBlurredVersion();
  
  heart = loadImage("heart.png");
  heart.resize(50, 50);
  
  explo = loadImage("explo.png");
  explo.resize(width/7, height/6); //217 145
  normalExplo = explo.copy(); 
  blurredExplo = explo.copy();
  
  p1 = new Plane();
  
  meteorites = new ArrayList<Meteorite>();
  bonuses = new ArrayList<Bonuse>();
   
  blurredMet = new PImage[4];
  
  meteoritesTypes = new PImage[4];
  
  meteoritesTypes[0] = loadImage("met0.png");
  meteoritesTypes[0].resize(width/10, width/10);
  
  meteoritesTypes[1] = loadImage("met1.png");
  meteoritesTypes[1].resize(width/15, width/15);
  
  meteoritesTypes[2] = loadImage("met2.png");
  meteoritesTypes[2].resize(width/10, width/10);
  
  meteoritesTypes[3] = loadImage("met3.png");
  meteoritesTypes[3].resize(width/9, width/9);
  
  frameRate(140);
  
  bonus = 0;
  score = millis();
  bulletModel = loadImage("bullet.png");
  bulletModel.resize((int)(width/7.5), (int)(width/7.5));
  blurredBulletModel = initBlurred(bulletModel);
  
  initBlurredMetModels();
  
  boop = new SoundFile(this, "boop.mp3");
  menuMusic = new SoundFile(this, "menuMusic.mp3");
  planeFlying = new SoundFile(this, "planeFlying.mp3");
  deathMusic = new SoundFile(this, "deathMusic.mp3");
  lastshot = 0;
  blurTime = 0;
  changeBackMusic = true;
  
  mute = false;
  
  buttons = new ArrayList<Button>(); 
  highscore = 0;
  screen = "MENU";
  difficulty = 1;
  buttons.add(new Button("Play", width/2, height/2+150, 250, 70));
  buttons.add(new Button("Difficulty", width/2, height/2+230, 250, 70));
  setUpStage++;
}

//From the convolution program given to us on moodle
void filter_Image(PImage origImg, PImage img, float[][] filter) {
  img.loadPixels();
  float r,g,b;
  for(int i=1; i < img.width-1;i++) {
    for(int j=1; j < img.height-1;j++) {
      color c = img.get(i, j);
      if (red(c) == 0 && green(c) == 0 && blue(c) == 0) {
        img.pixels[i + j * img.width] &= 0x00FFFFFF;
      } else {
        r = 0;
        g = 0;
        b = 0;
    
        for(int m=-1;m<2;m++) {
          for(int n=-1;n<2;n++) {
              r += red(origImg.get(i+m, j+n)) * filter[n+1][m+1];
              g += green(origImg.get(i+m, j+n)) * filter[n+1][m+1];
              b += blue(origImg.get(i+m, j+n)) * filter[n+1][m+1];
            }
            img.set(i, j, color(r,g,b));
          }
      }
    }
  }
  img.updatePixels();
}

void mouseClicked() {
  if (setUpStage > 1) {
    for (int i = 0; i < buttons.size(); i++) {
      if (buttons.get(i).isClicked()) {
        break;
      }
    }
  }
}

void keyPressed() {
  if (setUpStage > 1) {
    if ((key == 'p' || key == 'P')) {
      if (("PLAY").equals(screen)) {
        screen = "PAUSE";
      } else if (("PAUSE").equals(screen)) {
        screen = "PLAY";
      }
    } else if ((key == 'm' || key == 'M')) {
      if (mute) {
        mute = false;
        changeBackMusic = true;
      } else {
        mute = true;
        menuMusic.stop();
        deathMusic.stop();
        planeFlying.stop();
      }
    }
  }
}

PImage initBlurred(PImage org) {
  PImage[] tempBlurred = new PImage[4];
  tempBlurred[0] = org.copy(); 
  for (int j = 1; j < 4; j++) {
    tempBlurred[j] = tempBlurred[j-1];
    filter_Image(tempBlurred[j-1],  tempBlurred[j], blur_filter);
  }
  return tempBlurred[3].copy(); 
}

void initBlurredMetModels() {
  for (int i = 0; i < meteoritesTypes.length; i++) {
    blurredMet[i] = initBlurred(meteoritesTypes[i]);
  }
}

void menuScreen() {
  imageMode(CENTER);
  image(logo, width/2 + 50, height/2 - 150);
  imageMode(CORNER);
  String buttonPressed  = "";
  for (int i = 0; i < buttons.size(); i++) {
    buttons.get(i).display();
    if (buttons.get(i).clicked == true) {
      buttonPressed = buttons.get(i).text;
      buttons.removeAll(buttons);
      break;
    }
  }
  
  if (highscore > 0) {
    textAlign(CENTER);
    text("Highscore:", width/2, height/2+340);
    text(highscore, width/2, height/2+400);
  }
  if (("Play").equals(buttonPressed)) {
    screen = "PLAY";
    changeBackMusic = true;
    p1.dead = false;
    p1.life = 5;
    
  } else if (("Difficulty").equals(buttonPressed)) {
    screen = "DIFFICULTY(From menu)";
    buttons.add(new Button("Easy", width/2, height/2+120, 250, 70));
    buttons.add(new Button("Normal", width/2, height/2+200, 250, 70));
    buttons.add(new Button("Hard", width/2, height/2+280, 250, 70));
    buttons.add(new Button("Back", width/2, height/2+390, 250, 70));
  }
}

void playScreen() {
  if (!p1.dead) {
    
    if (blurred && millis() - blurTime > 5000 * difficulty) {
      blurred = false;
      explo = normalExplo.copy();
    } else if (blurred) {
      //Displays how much more time the blurring is gonna last
      textSize(20);
      textAlign(CENTER);
      //Making sure the blur time remaining text doesn't overwrite the shield remimaning time
      if (p1.s.isOn && blurTime > shieldTime) {
        text("Blur Time Remaining: " + (blurTime + 5000 * difficulty - millis()), width/2, 70);
      } else {
        text("Blur Time Remaining: " + (blurTime + 5000 * difficulty - millis()), width/2, 35);
      }
    }
    
    if (p1.s.isOn && millis() - shieldTime > 5000 / difficulty) {
      p1.s.isOn = false;
    } else if (p1.s.isOn) {
      //Displays how much more time the shield protecting the player is gonna stay
      textSize(20);
      textAlign(CENTER);
      //Making sure the shield time remaining text doesn't overwrite the blurring remimaning time
      if (blurred && blurTime < shieldTime) {
        text("Shield Time Remaining: " + (shieldTime + 5000 / difficulty - millis()), width/2, 70);
      } else {
        text("Shield Time Remaining: " + (shieldTime + 5000 / difficulty - millis()), width/2, 35);
      }
    }
    
    //Using time limit so the player cannot shoot as many consecutive shots as he wants (limited to 1 shot/200ms)
    //Not using mouseClicked() as it only works if the mouse is static (mouseX needs to be the same when mouse is clicked and released) meaning that player could only shoot when plane is static
    if (mousePressed && !p1.dead && mouseButton == LEFT && (millis() - lastshot > 200 || lastshot == 0)) {
      if (!mute) {
        boop.play();
      }
      p1.bullets.add(new Bullet(p1.x + p1.model.width/2, p1.y));
      lastshot = millis();
    }
    
    if (p1.life <= 0) {
      image(explo, p1.x, p1.y);
      p1.dead = true;
    }
    
    score = millis() + bonus - start;
    float rand = random(0, 1);
    if (rand < .05 && meteorites.size() < 10 * difficulty) {
      meteorites.add(new Meteorite());
    }
    
    if (meteorites != null && !meteorites.isEmpty()) {
      for (int i = 0; i < meteorites.size(); i++) {
        if (meteorites.get(i) != null && !meteorites.get(i).out) {
          meteorites.get(i).move();
        } else {
          image(explo, meteorites.get(i).x + meteorites.get(i).model.width/2, meteorites.get(i).y + meteorites.get(i).model.height/2);
          meteorites.remove(i);
        }
      }
    }
    
    rand = random(0, 1);
    if (rand < (.001) && bonuses.size() < ceil(1 / difficulty)) {
      //According to Bayes theory, given that rand is smaller than .001, then we have exactly .5 chance that rand < .0005, meaning that the bonuses are distributed equaly
      if (rand < .0005) {
        bonuses.add(new ShieldBonuse());
      } else {
        bonuses.add(new LifeBonuse());
      }
    }
    
    if (bonuses != null && !bonuses.isEmpty()) {
      for (int i = 0; i < bonuses.size(); i++) {
        if (bonuses.get(i) != null && !bonuses.get(i).out) {
          bonuses.get(i).move();
        } else {
          bonuses.remove(i);
        }
      }
    }
    
    textAlign(LEFT);
    textSize(30);
    image(heart, width - 100,0);
    fill(#B90606);
    text("" + p1.life, width - 45, 35);
    fill(255);
    text("Score: ", 0, 30);
    text("" + score, 0, 70);
    text("Kills: ", width/6, 30);
    text("" + bonus/10000, width/6, 70);
    text("Press 'p' to pause", 0, height-15);
    
    text("Highscore: ", 0, 100);
    //if (highscore > 0) {
      if (highscore > score) {
        text("" + highscore, 0, 140);
      } else {
        text("" + score, 0, 140);
      }
    //} 
    p1.move();
    if (p1.bullets != null && !p1.bullets.isEmpty()) {
      for (int i = 0; i < p1.bullets.size(); i++) {
        if (p1.bullets.get(i) != null && !p1.bullets.get(i).done) {
          p1.bullets.get(i).move();
        } else {
          p1.bullets.remove(i);
        }
      }
    }
  } else {
    screen = "RETRY";
     changeBackMusic = true;
    if (highscore < score) {
      highscore = score;
    }
    start = millis();
    bonus = 0;
    blurTime = 0;
    blurred = false;
    buttons.add(new Button("Retry", width/2, height/2 + 170, 250, 70));
    buttons.add(new Button("Change Difficulty", width/2, height/2+250, 440, 70));
    buttons.add(new Button("Back To Menu", width/2, height/2+330, 360, 70));
    
  }
}

void retryScreen() {
  textSize(50);
  textAlign(CENTER);
  text("YOU DIED!", width/2, height/2-60);
  text("Your score was:", width/2, height/2);
  text(score, width/2, height/2+60);
  String buttonPressed  = "";
  for (int i = 0; i < buttons.size(); i++) {
    buttons.get(i).display();
    if (buttons.get(i).clicked == true) {
      buttonPressed = buttons.get(i).text;
      buttons.removeAll(buttons);
      break;
    }
  }
  
  if (("Retry").equals(buttonPressed)) {
    screen = "PLAY";
    changeBackMusic = true;
    p1.dead = false;
    p1.life = 5;
    //blurTime = 0;
    //blurred = false;
    if (highscore < score) {
      highscore = score;
    }
    start = millis();
    bonus = 0;
    
  } else if (("Change Difficulty").equals(buttonPressed)) {
    screen = "DIFFICULTY(From retry)";
    buttons.add(new Button("Easy", width/2, height/2+120, 250, 70));
    buttons.add(new Button("Normal", width/2, height/2+200, 250, 70));
    buttons.add(new Button("Hard", width/2, height/2+280, 250, 70));
  } else if (("Back To Menu").equals(buttonPressed)) {
    changeBackMusic = true;
    screen = "MENU";
    buttons.add(new Button("Play", width/2, height/2+170, 250, 70));
    buttons.add(new Button("Difficulty", width/2, height/2+240, 250, 70));
  }
}

void difficultyFromMenu() {
  imageMode(CENTER);
  image(logo, width/2 + 50, height/2 - 160);
  imageMode(CORNER);
  String buttonPressed  = "";
  for (int i = 0; i < buttons.size(); i++) {
    buttons.get(i).display();
    if (buttons.get(i).clicked == true) {
      buttonPressed = buttons.get(i).text;
      buttons.removeAll(buttons);
      break;
    }
  }
  
  if (!("").equals(buttonPressed)) {
    screen = "MENU";
    //changeBackMusic = true;
    buttons.add(new Button("Play", width/2, height/2+170, 250, 70));
    buttons.add(new Button("Difficulty", width/2, height/2+240, 250, 70));
    if (("Easy").equals(buttonPressed)) {
      difficulty = .5;
    } else if (("Normal").equals(buttonPressed)) {
      difficulty = 1;
    } else if (("Hard").equals(buttonPressed)) {
      difficulty = 1.5;
    }
  }
}

void difficultyFromRetry() {
  String buttonPressed  = "";
  for (int i = 0; i < buttons.size(); i++) {
    buttons.get(i).display();
    if (buttons.get(i).clicked == true) {
      buttonPressed = buttons.get(i).text;
      buttons.removeAll(buttons);
      break;
    }
  }
  
  if (!("").equals(buttonPressed)) {
    screen = "RETRY";
    buttons.add(new Button("Retry", width/2, height/2 + 170, 250, 70));
    buttons.add(new Button("Change Difficulty", width/2, height/2+250, 440, 70));
    buttons.add(new Button("Back To Menu", width/2, height/2+330, 355, 70));
    if (("Easy").equals(buttonPressed)) {
      difficulty = .5;
    } else if (("Normal").equals(buttonPressed)) {
      difficulty = 1;
    } else if (("Hard").equals(buttonPressed)) {
      difficulty = 1.5;
    }
  }
}

void pauseScreen() {
  textAlign(CENTER);
  textSize(120);
  text("PAUSE", width/2, height/2-100);
  textSize(30);
  text("Press 'p' to resume", width/2, height/2+ 30);
}

//Handling everything that's sound related
void sound() {
  if (!mute) {
    if (("PLAY").equals(screen)) {
      image(soundOn, width - 180, 0);
    } else {
      image(soundOn, width - 50, 0);
    }
    
    //Playing the right music / the right background sound
    if ((("DIFFICULTY(From retry)").equals(screen) || ("RETRY").equals(screen)) && changeBackMusic) {
      planeFlying.stop();
      menuMusic.stop();
      deathMusic.loop();
      changeBackMusic = false;
    } else if (("PLAY").equals(screen) && changeBackMusic) {
      menuMusic.stop();
      deathMusic.stop();
      planeFlying.loop();
      changeBackMusic = false;
    } else if (changeBackMusic){
      deathMusic.stop();
      planeFlying.stop();
      menuMusic.loop();
      changeBackMusic = false;
    }
    
  } else {
    if (("PLAY").equals(screen)) {
      image(soundOff, width - 180, 0);
    } else {
      image(soundOff, width - 50, 0);
    }
  }
  
  textSize(30);
  textAlign(RIGHT);
  text("Press 'm' to mute", width, height-15);
}
