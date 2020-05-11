class ShieldBonuse extends Bonuse {
  
  ShieldBonuse() {
    this.model = shieldIcon.copy();
    this.blurredModel = blurredShieldIcon.copy();
  }
  
  void giveBonuse() {
    p1.s.isOn = true;
    shieldTime = millis();
  }
}
