// play
"beach1.wav out=1 fadein=2.5 fadeout=1.0".findRegexp("([a-zA-Z0-9]+\\.wav) out=([0-9]{1,2}) fadein=([0-9\\.]+) fadeout=([0-9\\.]+)")

// haptic
"freq=100 amod=2 dur=2.0 fadein=1.0 fadeout=1.0".findRegexp("freq=([0-9\\.]+) amod=([0-9\\.]+) dur=([0-9\\.]+) fadein=([0-9\\.]+) fadeout=([0-9\\.]+)")


"end estuary".findRegexp("(goto|end) ([A-Za-z0-9]+)?")

"haptic freq=100 amod=2 dur=2.0 fadein=1.0 fadeout=1.0".findRegexp("^(haptic|play) ([A-Za-z0-9\\. =]+)")

/*
"12.45 play blah=3.4 blah=2 blahblah".findRegexp("([0-9]+[\\.0-9]+?)[ ]([a-zA-Z= 0-9\\.]+)")

"passage 10".findRegexp("([0-9]+(\.[0-9]+)?)[ ]([a-zA-Z= 0-9\\.]+)")

"passage 10".findRegexp("([A-Za-z]+) ([a-zA-Z\\. =0-9])")
*/

// TODO:: Port this over to the Bela



( // Tell me a story...
~waiting = 0;
r = Routine {
  0.yield;
  ~playAudio.("beach1.wav", fadein: 3.0, fadeout: 3.0);
  5.yield;
  ~playHaptic.(dur: 3, out: 0);
  2.yield;
  ~playAudio.("haven1.wav", fadein: 3.0, fadeout: 3.0);

  {~waiting != -1}.while {
    0.1.yield;
  };

  "~~Fin".postln;
};

SystemClock.play(r);

);


a.audioBufs;
SystemClock.clear;




a.audioBufs.keys;
~playAudio.("beach1.wav");


// NOTE: check out Array.fork(join) ...interesting for sequencing

