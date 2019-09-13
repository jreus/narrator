/*****
Bela Remote Control

Use this file for working on the Bela remotely from the SC IDE.
First run _main.scd on the Bela and edit localSettings.scd to configure
remote mode to be true.

(c) 2019 Jonathan Reus

******/

// Test active communication with the server
s.plotTree; // show all active nodes
s.freeAll;  // free all nodes

( // Connect to the Bela server and set up Client Side data structures
Server.default = s = Server("belaServer", NetAddr("192.168.7.2", 57110));
s.options.maxLogins = 10; // should match the settings on the Bela
s.initTree;
s.startAliveThread;

(
a = ();

a.belaRootPath = "/root/Bela/projects/SimpleNarration/";
a.clientRootPath = "".resolveRelative;

a.rootPath = "".resolveRelative;
a.dataPath = a.belaRootPath +/+ "stories/";
a.audioPath = a.dataPath +/+ "audiofiles/";

a.clientDataPath = a.clientRootPath +/+ "stories/";
a.clientAudioPath = a.clientDataPath +/+ "audiofiles/";

// build a client-side copy of Bela-side audio paths
a.audioFilePaths = List.new;
PathName(a.clientAudioPath).filesDo {|filepath|
  a.audioFilePaths.add(a.audioPath +/+ filepath.fileName);
};

a.audioBufs;

a.rootPath.postln;
);

// These should now target the Bela and the audio files in its filesystem
(a.clientProjectPath +/+ "loadSynthdefs.scd").load;
(a.clientProjectPath +/+ "loadUtils.scd").load;
(a.clientProjectPath +/+ "loadAudioFiles.scd").load;

(a.clientProjectPath +/+ "playStories.scd").load;



// Livecoding some things...
d = Synth(\playFragment, [\out, 0, \buf, a.fragmentBufs[3], \fadeIn, 2, \fadeOut, 2, \amp, 1.0]);
e = Synth(\playFragment, [\out, 1, \buf, a.fragmentBufs[4], \fadeIn, 2, \fadeOut, 2, \amp, 1.0]);

// into a haptic transducer...
f = Synth(\playFragment, [\out, 2, \buf, a.fragmentBufs[5], \fadeIn, 2, \fadeOut, 2, \amp, 1.0]);
f.free;

Synth('karp', [\out, 0, 'dur', 20, 'freq', 5, 'amp', 0.5, 'decaytime', 0.5, 'coef', 0.1]);
Synth('karp', [\out, 1, 'dur', 20, 'freq', 10, 'amp', 1.0, 'decaytime', 10.5, 'coef', 0.7, \delaytime, 0.6]);

// Don't overload the speaker amps!!!! Watch the amplitude... :-/ ....
// A full volume SinOsc out of the Analog output is ~ 4.9V peak-to-peak
// centered around 2.5V ....
// x = {SinOsc.ar(100) * 1.0}.play(outbus: 2);

// An amplitude of 0.35 gives you roughly 1.8 V peak2peak
// ...but you lose some resolution... :-/
//x = {SinOsc.ar(100) * 0.32}.play(outbus: 2);
//x.free;

// A 47k resistor in series from AN0 does a good job of bringing down the signal! :-)

// Haptic Pulses
x = Synth(\simpleHaptic, [\out, 2, \atk, 0.01, \dur, 4, \rel, 2]);
y = Synth(\simpleHaptic, [\out, 3, \freq, 200, \am_hz, 5, \atk, 0.01, \dur, 2, \rel, 1]);



Synth('karp', [\out, 2, 'dur', 5, \freq, 5, 'amp', 1.0, 'decaytime', 10.5, 'coef', 0.9, \delaytime, 0.085]);

(
Pdef(\arpL, Pbind(*[
  instrument: \karp,
  note: Pseq([0,3,7,9], inf),
	root: 0,
  amp: 0.5,
	dur: 0.1,
	coef: 0.6,
	decaytime: 3,
	delaytime: 4,
  out: 0,
]
)).play(quant: 4);
);

(
Pdef(\arpR, Pbind(*[
  instrument: \karp,
  note: Pseq([0,3,7,9], inf, 2),
	root: 0,
  amp: 0.5,
	dur: 0.1,
	coef: 0.6,
	decaytime: 3,
	delaytime: 4,
  mtranspose: 2,
  out: 1,
]
)).play(quant: 4);
);

Pdef.clear;

Pbindef(\arpL, \ctranspose, 0, \note, Pseq([10, 2, 9, [3,7], 17, [0,8]], inf), \dur, 0.2, \amp, 0.5, \coef, 0.8);

Pbindef(\arpL, \out, 0);
Pbindef(\arpR, \out, 1, \note, -24);

Pbindef(\arpL, \out, 2, \note, -19, \amp, 1.0, \dur, 0.09, \decaytime, 5.1, \coef, 0.2, \delaytime, 200.0);
Pbindef(\arpR, \out, 2, \note, -48, \amp, 1.0, \dur, 5, \decaytime, 10.0, \delaytime, 10.0, \coef, 0.8);


p.stop;