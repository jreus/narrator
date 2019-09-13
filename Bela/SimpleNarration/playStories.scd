/* Story Playback Engine */

( // Tell me a story...
~waiting = 0;
~done = false;
~story1 = Routine {
  ~done = false;
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
  ~done = true;
};

SystemClock.play(~story1);

{ // Inter-story logic
  loop {
   if(~done) {
      ~story.reset;
      SystemClock.play(~story1);
    } {
      5.yield;
    };
  };
}.fork(AppClock);

);
