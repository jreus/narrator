/***** init.scd *****/

a.fragmentBufs = ();
a.sampleDir = a.projectPath +/+ "_samples/";
a.fragmentDir = a.sampleDir +/+ "_fragments/";

( // Load Samples
PathName(a.fragmentDir).filesDo {|filepath|
  var bufsize = 65536 * 4; // adjust for available ram vs. playback quality
  Buffer.cueSoundFile(s, filepath, 0, 1, 65536 * 4);
};
);