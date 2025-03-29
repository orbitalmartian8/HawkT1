print("*** LOADING instrumentation.nas ... ***");
############################################################
#                                                          #
#                   INSTRUMENTS SETTINGS                   #
#                                                          #
############################################################
# Adapté pour McDonnell T45 09/2022

var SPEEDABS = "/autopilot/internal/vert-speed-abs";

var Tacan = func() {
  if (getprop("instrumentation/tacan/frequencies/selected-channel[4]") == "X") {
    setprop("instrumentation/tacan/frequencies/XPos", 1);
  } else {
    setprop("instrumentation/tacan/frequencies/XPos", -1);
  }
}

# Vertical Speed Moins absolute value
var vsm = func() {
  var ret = getprop("autopilot/internal/vertical-speed-fpm");
  if ( ret < 0 ) {
    ret *= -1;
  }
  setprop(SPEEDABS, ret);
}

var initIns = func() {
    Tacan();
    vsm();
    settimer(initIns, 0.01);
}
