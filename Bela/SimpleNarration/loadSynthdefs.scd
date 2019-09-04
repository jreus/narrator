// Synth Defs

(

SynthDef(\playFragment,{|out=0, buf, amp=1.0, fadeIn=0.1, fadeOut=0.1|
  var sig, env;
  sig = PlayBuf.ar(1, buf, BufRateScale.kr(buf), 1, doneAction: 2);
  env = EnvGen.ar(Env.linen(fadeIn, BufDur.kr(buf) - fadeIn - fadeOut ,fadeOut), 1);
  Out.ar(out, sig * env * amp);
}).add;

)
