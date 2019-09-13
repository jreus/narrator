/* Story Playback Engine */

"Tell me a story...".postln;

( // Tell me a story...
~waiting = 0;
~done = false;
~story1 = Routine {
  ~done = false;
  0.yield;
  ~playAudio.("beach1.wav", fadein: 3.0, fadeout: 3.0);
  "beach1".postln;
  5.yield;
  ~playAudio.("beach1.wav", fadein: 3.0, fadeout: 3.0, out: 3);
  "beach2".postln;
  0.5.yield;
  ~playHaptic.(dur: 5, out: 2);
  "haptic1".postln;
  2.yield;
  ~playAudio.("haven1.wav", fadein: 3.0, fadeout: 3.0);
  "haven1".postln;

  {~waiting != -1}.while {
    0.1.yield;
  };

  "~~Fin".postln;
  ~done = true;
};

~story1.play(SystemClock);

{ // Inter-story logic
	var status = "N/A";
  loop {
    if(~done == true) {
    	status = "Done";
    } {
    	status = "Playing";
    };

   if(~done == true) {
   	"playing again".postln;
      ~story1.stop;
      ~story1.reset;
      status = "Playing ...";
      ~done = false;
      ~story1.play(SystemClock);
    };
    1.wait;
    "status: % %".format(status, ~done).postln;
  };
}.fork(SystemClock);

);
