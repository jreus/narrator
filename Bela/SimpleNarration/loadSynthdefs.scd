// Synth Defs

(
SynthDef(\playFragment1ch,{|out=0, buf, id=0, amp=1.0, fadeIn=0.1, fadeOut=0.1|
  var sig, env, t_done;
  sig = PlayBuf.ar(1, buf, BufRateScale.kr(buf), 1, doneAction: 2);
  env = EnvGen.ar(Env.linen(fadeIn, BufDur.kr(buf) - fadeIn - fadeOut ,fadeOut), 1);
  SendTrig.kr(Done.kr(env), id, 1.0);
  Out.ar(out, sig * env * amp);
}).add;

SynthDef(\playFragment2ch,{|out=0, buf, id=0, amp=1.0, fadeIn=0.1, fadeOut=0.1|
  var sig, env;
  sig = PlayBuf.ar(2, buf, BufRateScale.kr(buf), 1, doneAction: 2);
  env = EnvGen.ar(Env.linen(fadeIn, BufDur.kr(buf) - fadeIn - fadeOut ,fadeOut), 1);
  SendTrig.kr(Done.kr(env), id, 1.0);
  Out.ar(out, sig * env * amp);
}).add;


SynthDef('karp', {|freq=200, amp=0.5, pan=0, dur=1, trig=1, delaytime=2, decaytime=2, coef=0.1, out=0|
		var sig, env;
	coef.poll(2);
		sig = Pluck.ar(WhiteNoise.ar(1), trig, delaytime, freq.reciprocal, decaytime, coef);
		env = EnvGen.ar(Env.perc(0.01, dur), trig, doneAction: 2);
		Out.ar(out, sig * env * amp);
}).add;

SynthDef('simpleHaptic', {|freq=100, id=0, am_hz=1, out=0, amp=1.0,
  atk=0.01, rel=0.1, dur=5.0|
  var sig, env;
  sig = SinOsc.ar(freq) * SinOsc.ar(am_hz);
  env = EnvGen.ar(Env.linen(0.01, dur-atk-rel, rel), doneAction: 2);
  SendTrig.kr(Done.kr(env), id, 1.0);
  Out.ar(out, sig * env);
}).add;

)
