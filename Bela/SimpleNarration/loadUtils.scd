( // Plumbing...
a.maxSynths = 20;
a.activeSynths = Array.newClear(a.maxSynths);

~playAudio = {|filename,id,out=0, amp=1.0, fadein=1.0, fadeout=1.0|
  var buf = a.audioBufs.at(filename);
  var synth;
  if(buf.notNil) {
    if(id.isNil) { id = rrand(0, a.maxSynths-1) }; // TODO: lazy!

    if(buf.numChannels == 2) { synth = \playFragment2ch } { synth = \playFragment1ch };
    a.activeSynths[id] = Synth(synth, [\id, id, \out, out, \buf, buf, \amp, amp, \fadeIn, fadein, \fadeOut, fadeout]);
    ~waiting = id;
  } {
    "No audio buffer found for filename %".format(filename).throw;
  };
};

~playHaptic = {|id, freq=100, am_hz=1, out=0, amp=1.0, atk=0.01, rel=0.1, dur=1.0|
  if(id.isNil) { id = rrand(0, a.maxSynths-1) }; // TODO: lazy!
  a.activeSynths[id] = Synth(\simpleHaptic, [\atk, atk, \id, id, \rel, rel, \dur, dur, \freq, freq, \am_hz, am_hz, \out, out, \amp, amp]);
  ~waiting = id;

};

OSCdef(\playerStatus, {|msg|
  var id, status, allDone = true;
  id=msg[2].asInt;
  status=msg[3].asInt;

  "Done % %".format(id, status).postln;

  if(status == 1) { a.activeSynths[id] = nil };

  allDone = a.activeSynths.detect({|val| val != nil }).isNil;
  if(allDone) {
    ~waiting = -1;
  };
}, "/tr");

);