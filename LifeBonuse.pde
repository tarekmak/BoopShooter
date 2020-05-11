class LifeBonuse extends Bonuse{
  
  LifeBonuse() {
    this.model = lifeIcon.copy();
    this.blurredModel = blurredLifeIcon.copy();
  }
  
  void giveBonuse() {
    p1.life++;
    fill(#B90606);
    text("+1", width - 55, 70);
  }
}
