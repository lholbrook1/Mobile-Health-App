class Accelerometer {
  late double distanceTraveled;
  late int scanInterval;

  Accelerometer({
    this.distanceTraveled = 0,
    this.scanInterval = 30,
  });

  void addDistance(double d) {
    this.distanceTraveled += d;
  }
}
