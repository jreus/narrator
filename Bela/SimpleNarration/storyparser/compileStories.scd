a.compiledStories = Dictionary.new;

a.stories.do {|story|
  var task = Task.new({
    var currentPassage, nextPassage, eventList;
    var lastEvent;

    // Do entry point
    currentPassage = story[story[\entryPoint]];

    "Story Start % ...".format(currentPassage[\id]);

    currentPassage[\events].do {|event|
      var waitFor;
      // Play event
      waitFor = event[\time] - lastEvent[\time];

      // TODO:: I AM HERE GET THIS EVENT PLAYBACK SYSTEM WORKING...

      lastEvent = event;

    };



  });

};


x = a.stories["story1.sto.txt"][\entryPoint];
y = a.stories["story1.sto.txt"][x];
y[\events]


OSCdef.trace(false);
(
OSCdef(\darien, {|msg|
  var type, val;
  type = msg[1].asSymbol;
  val = msg[2];

  switch(type,
    \x, { val = val.asFloat },
    \y, { val = val.asFloat },
    \ele, { val = val.asFloat },
    \time, { val = val /* as time? */},
    \pdop, { val = val.asFloat },
    \hr, { val = val.asFloat },
    { "Not recognized %".format(msg).error }
  );

}, "/fromDarien");
);