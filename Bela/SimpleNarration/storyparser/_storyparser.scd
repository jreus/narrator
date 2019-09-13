/**
Simple Story Format Parser
2019 (c) Jonathan Reus

Parses a simple story language file and plays back.
*/


// 0. configure server & language plumbing
(
s = Server.default;
s.options.memSize = 8192 * 32;

a = ();
a.rootPath = File.realpath("../".resolveRelative);
a.selfPath = "".resolveRelative;
a.dataPath = a.rootPath +/+ "stories/";
a.audioPath = a.dataPath +/+ "audiofiles/";
a.audioBufs;
);


s.waitForBoot {

  // 1. load synthdefs
	"Loading Synthdefs...".postln;
	(a.rootPath +/+ "loadSynthdefs.scd").load;
	s.sync;
	"Finished!".postln;

  // 2. load utility methods & data structures
  (a.rootPath +/+ "loadUtils.scd").load;

  // 3. load & parse story files from project directory
  (a.selfPath +/+ "parseStory.scd").load;

  a.stories["story1.sto.txt"].keys;

  // 4. load audio files & warn of missing audio files in parsed stories
  (a.rootPath +/+ "loadAudioFiles.scd").load;
  s.sync;


  // 3. build the stories as eventstreams
  //(a.selfPath +/+ "compileStories.scd").load;


  // 4. functions to play/stop different stories/fragments

};


(
r = Routine({
  10.do {|idx|
    idx.postln;
    1.yield;
  }
});
);

SystemClock.play(r)
SystemClock.clear;

