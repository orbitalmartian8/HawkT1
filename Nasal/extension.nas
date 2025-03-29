# ==================================
# Extension       by Helijah 08/2022
# ==================================

setlistener("/position/gear-agl-m", func(v) {
  if (v.getValue() > 3) {
    interpolate("/gear/gear[1]/extension-pos", 1, 0.10);
  } else {
    interpolate("/gear/gear[1]/extension-pos", 0, 0.10);
  }
});

setlistener("/position/gear-agl-m", func(v) {
  if (v.getValue() > 3) {
    interpolate("/gear/gear[2]/extension-pos", 1, 0.10);
  } else {
    interpolate("/gear/gear[2]/extension-pos", 0, 0.10);
  }
});
