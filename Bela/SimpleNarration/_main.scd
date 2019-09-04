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


s.options.pgaGainLeft = 0;     // Set the PGA pre-amp gain for the left audio input channel (0dBmin; 59.5dB max; default: 16dB)
s.options.pgaGainRight = 0;    // Set the PGA pre-amp gain for the right audio input channel (0dBmin; 59.5dB max; default: 16dB)
s.options.headphoneLevel = 0; // Set the headphone output level (0dB max; -63.5dB min)
s.options.speakerMuted = 0;    // Set whether to mute the speaker initially (default: no) 1-mute  0-not muted

// NOTE:: REMEMBER TO ALWAYS REDUCE THE LEVEL GOING TO THE SPEAKER AMPS! THEY EXPECT 1.8V peak2peak
//   Add a resistor/divider if needed from the audio output!

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
