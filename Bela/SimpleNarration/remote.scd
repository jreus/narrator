/*****
Bela Remote Control

Use this file for working on the Bela remotely from the SC IDE.
First run _main.scd on the Bela
(c) 2019 Jonathan Reus

******/


( // connect to the already-running remote belaserver
Server.default = s = Server("belaServer", NetAddr("192.168.7.2", 57110));
s.options.maxLogins = 10; // should match the settings on the Bela
s.initTree;
s.startAliveThread;
);

// Communicate with the server
s.plotTree; // show all active nodes
s.freeAll;  // free all nodes

(
a = ();



);



(
SynthDef('karp', {|freq=200, amp=0.5, pan=0, dur=1, trig=1, delaytime=2, decaytime=2, coef=0.1, out=0|
		var sig, env;
	coef.poll(2);
		sig = Pluck.ar(WhiteNoise.ar(1), trig, delaytime, freq.reciprocal, decaytime, coef);
		env = EnvGen.ar(Env.perc(0.01, dur), trig, doneAction: 2);
		Out.ar(out, sig * env * amp);
}).add;
);

Synth('karp', [\out, 0, 'dur', 20, 'freq', 220, 'amp', 1.0, 'decaytime', 0.5, 'coef', 0.1]);
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
x = {SinOsc.ar(100) * SinOsc.ar(1)}.play(outbus: 2);
x.free;



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
