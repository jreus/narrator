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


(
a = ();

a.rootPath = "".resolveRelative;
a.dataPath = a.rootPath +/+ "stories/";
a.audioPath = a.dataPath +/+ "audiofiles/";

a.audioBufs;

a.rootPath.postln;
);


s.waitForBoot({

  "Loading settings...".postln; // settings file is ignored by git
  (a.projectPath +/+ "localSettings.scd").load;

  // If controlling remotely, the following load statements must be run
  // from the remote client IDE: see remote.scd
  if(a.remote.isNil.or {a.remote == false}) {

    "Loading Synthdefs...".postln;
    (a.rootPath +/+ "loadSynthdefs.scd").load;
    s.sync;
    "Finished!".postln;

    // load utility methods & data structures
    (a.rootPath +/+ "loadUtils.scd").load;

    // load & parse story files from project directory
    //(a.selfPath +/+ "parseStory.scd").load;

    (a.rootPath +/+ "loadAudioFiles.scd").load;
    s.sync;


    (a.projectPath +/+ "playStories.scd").load;
    s.sync;


  } {
  	"Running system in REMOTE mode... waiting for remote client to connect and send commands.".postln;
  };



});
