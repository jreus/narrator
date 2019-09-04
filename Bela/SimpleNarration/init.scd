/***** init.scd *****/

/* !!NOTE:

Using Buffer.cueSoundFile and DiskIn isn't a great idea. The repeated Disk reads causes mode switches and underruns. Better to use PlayBuf, if this becomes a RAM issue then use DiskIn with a large buffer size.

SynthDef(\playCueBuf,{|out=0, buf|
  // NOTE: DiskIn causes mode switches and underruns due to disk reads, better to use PlayBuf!
    Out.ar(out, DiskIn.ar( 1, buf ))
}).add;


*/



a.fragmentBufs = List.new;

( // Load Samples

// Fragment buffers
a.fragmentPaths.do {|pathStr|
  a.fragmentBufs.add(
    Buffer.read(s, pathStr, 0, -1, {|buf| "LOADED %".format(buf).postln })
  );
};

);


