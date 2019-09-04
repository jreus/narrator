/**
4-channel haptic, non-linear, narrative
2019 (c) Jonathan Reus
 */
s = Server.default;

s.options.numAnalogInChannels = 8;
s.options.numAnalogOutChannels = 2;
s.options.numDigitalChannels = 16;

s.options.blockSize = 16;
s.options.numInputBusChannels = 10;
s.options.numOutputBusChannels = 4;
s.options.maxLogins = 10;
s.options.memSize = 8192 * 32; // the default is 8192 which is quite little



// project directory
~mypath = "".resolveRelative;

s.waitForBoot({

	"Loading Synthdefs...".postln;
	(~mypath +/+ "loadSynthdefs.scd").load;
	s.sync;
	"Finished!".postln;

	"Initialize data structures, load buffers, make busses, synth instances, etc...".postln;
	(~mypath +/+ "init.scd").load;
	s.sync;
	"Finished!".postln;

	"Start app...".postln;
	(~mypath +/+ "run.scd").load;
	s.sync;
	"...Done!".postln;



});
