/* !!NOTE:

Using Buffer.cueSoundFile and DiskIn isn't a great idea. The repeated Disk reads causes mode switches and underruns. Better to use PlayBuf, if this becomes a RAM issue then use DiskIn with a large buffer size.

SynthDef(\playCueBuf,{|out=0, buf|
  // NOTE: DiskIn causes mode switches and underruns due to disk reads, better to use PlayBuf!
    Out.ar(out, DiskIn.ar( 1, buf ))
}).add;


*/

a.audioBufs = Dictionary.new;

"\nLoading audio files ...\n\n".postln;
PathName(a.audioPath).filesDo {|filepath|

  // Load into buffers...
  if(filepath.extension == "wav") {
  a.audioBufs.put(filepath.fileName,
    Buffer.read(s, filepath.fullPath, 0, -1, {|buf| "% %sps %ch".format(PathName(buf.path).fileName, buf.sampleRate, buf.numChannels).postln })
  );

  };
}


/*
/***** init.scd *****/





a.fragmentBufs = List.new;

( // Load Samples

// Fragment buffers
a.fragmentPaths.do {|pathStr|
  a.fragmentBufs.add(
    Buffer.read(s, pathStr, 0, -1, {|buf| "LOADED %".format(buf).postln })
  );
};

);





*/

