print("*** LOADING hawkt1.nas ... ***");
###################################################################
#                                                                 #
#                       hawkt1 SYSTEMS SETTINGS                     #
#                                                                 #
###################################################################
# Adapté pour McDonnell T45 09/2022

var Elapsed_time_Seconds  = 0;
var Elapsed_time_previous = 0;
var LastTime              = 0;
# Elapsed for time > 0.25 sec
var Elapsed               = 0;

var InitListener = setlistener("/sim/signals/fdm-initialized", func {
  settimer(main_Init_Loop, 5.0);
  removelistener(InitListener);
});

# Main init loop
# Perhaps in the future, make an object for each subsystems, in the same way
# of "engine"
var main_Init_Loop = func() {
  # Loop Updated inside

  print("Intrumentation ... Check");
  settimer(instrumentation.initIns, 2.0);

  print("Flight Director ... Check");
  settimer(flightdirector.init_set, 4.0);

  print("MFD ...Check");
  settimer(mfd.update_main, 4.0);

  print("Transponder ... Check");
  settimer(init_Transpondeur, 4.0);

  print("system loop ... Check");
  settimer(UpdateMain, 8.0);
}

var UpdateMain = func {
  settimer(hawkt1.updatefunction, 0);
}

var updatefunction = func() {
  Elapsed_time_Seconds = int(getprop("/sim/time/elapsed-sec"));
  AbsoluteTime = getprop("/sim/time/elapsed-sec");

  # Flight Director (autopilot)
  if (getprop("/autopilot/locks/AP-status") == "AP1") {
    flightdirector.update_fd();
  } else {
    # this is a way to reduce autopilot refreshing time when not activated  <-? what
    if (Elapsed_time_Seconds != Elapsed_time_previous) {
      flightdirector.update_fd();
    }
  }

  Elapsed_time_previous = Elapsed_time_Seconds;
  LastTime = AbsoluteTime;
  t45.UpdateMain();
}

var init_Transpondeur = func() {
  # Init Transponder
  var poweroften = [1, 10, 100, 1000];
  var idcode = getprop('/instrumentation/transponder/id-code');

  if (idcode != nil) {
    for(var i = 0 ; i < 4 ; i += 1) {
      setprop("/instrumentation/transponder/inputs/digit[" ~ i ~ "]", int(math.mod(idcode / poweroften[i], 10)));
    }
  }
}
