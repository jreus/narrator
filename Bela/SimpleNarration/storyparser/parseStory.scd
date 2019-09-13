  // NOTE: 13 Sept, 2019 >>
  //  The process of making a story metalanguage
  //  became a bit too large of a project near the end,
  //  so I decided to work directly with hard-coded routines
  //  for each story.
  //    See parserScratch.scd for an example..


a.stories = Dictionary.new;
a.commandHash = Dictionary.new;

PathName(a.dataPath).files.do {|fi|

  if(fi.extension == "txt") { // START FILE
    var tmp, raw, parsed = Dictionary.new;
    var re_event, re_eventcommands, re_command, re_whendone;
    var passage;

    re_event = "([0-9]+[\\.0-9]+?)[ ]([a-zA-Z= 0-9\\.]+)";
    re_eventcommands = "^(haptic|play) ([A-Za-z0-9\\. =]+)";
    re_command = "([A-Za-z]+) ([a-zA-Z\\. =0-9]+)";
    re_whendone = "(goto|end) ([A-Za-z0-9]+)?";
    // Parse story
    "Parsing story file % ... \n\n".format(fi.fileName).postln;
    raw = File.readAllString(fi.fullPath).split($\n);
    raw.do {|line|

      // BEGIN LINE PARSE
      if((line.size > 0).and { line[0] != $# }) {
        // Line has length and is not a comment
      tmp = line.findRegexp(re_event);
      if(tmp != []) { // time-based event
        var time = tmp[1][1].asFloat,rest = tmp[2][1];
        var ev_command, ev_args, event;
        if(passage.at(\events).isNil) { passage[\events] = List.new };
        event = Dictionary.new;
        event.put(\time, time);
        tmp = rest.findRegexp(re_eventcommands);
        if(tmp == []) { "Unknown event command: %".format(rest).throw };
        ev_command = tmp[1][1].asSymbol;
        ev_args = tmp[2][1];
        switch(ev_command,
            \play, {
              // Parse play arguments
              var re_play = "([a-zA-Z0-9]+\\.wav) out=([0-9]{1,2}) fadein=([0-9\\.]+) fadeout=([0-9\\.]+)";
              tmp = ev_args.findRegexp(re_play);

              event.put(\command, \play);
              event.put(\file, tmp[1][1]);
              event.put(\out, tmp[2][1].asInt);
              event.put(\fadein, tmp[3][1].asFloat);
              event.put(\fadeout, tmp[4][1].asFloat);

            },
            \haptic, {
              // Parse haptic arguments
              var re_haptic = "freq=([0-9\\.]+) amod=([0-9\\.]+) dur=([0-9\\.]+) fadein=([0-9\\.]+) fadeout=([0-9\\.]+)";
              tmp = ev_args.findRegexp(re_haptic);

              event.put(\command, \haptic);
              event.put(\freq, tmp[1][1].asFloat);
              event.put(\amod, tmp[2][1].asFloat);
              event.put(\dur, tmp[3][1].asFloat);
              event.put(\fadein, tmp[4][1].asFloat);
              event.put(\fadeout, tmp[4][1].asFloat);


            },
            { "Event type not recognized: %".format(ev_command).throw }
          );

          // Add the event to the current passage
         "\t\t% at % >> %".format(event[\command].asString.toUpper, event[\time], event).postln;
         passage[\events].add(event);

      } { // other command
        tmp = line.findRegexp(re_command);
        if(tmp != []) {
          var command = tmp[1][1].toLower.asSymbol, rest = tmp[2][1];

          switch(command,
            \passage, {
                var passageid = rest;
              if(passage.notNil) { // Store the current passage
                parsed.put(passage[\id], passage);
                "END PASSAGE %\n\n".format(passage[\id]).postln;
                } { // first passage
                  parsed.put(\entryPoint, passageid)
                };
              "NEW PASSAGE %".format(rest).postln;
              passage = Dictionary.new;
              passage[\id] = passageid;
            },
            \whendone, {
              var wd_command, wd_args;
              tmp = rest.findRegexp(re_whendone);
              if(tmp.isNil) { "Parse Error: bad arguments to whendone '%'".format(rest).throw };
              wd_command = tmp[1][1].toLower.asSymbol;
              wd_args = tmp[2][1];
              passage[\whendone] = Dictionary.new;
              passage[\whendone].put(\command, wd_command);
              passage[\whendone].put(\args, wd_args);

              "WHENDONE % >> %".format(passage[\whendone][\command], passage[\whendone]).postln;
            },
            { "Command % not recognized".format(command).throw }
          );

        } {
          "UNKNOWN ::%::".format(line).postln;
        };
      };

      };
      // END LINE PARSE

    }; // END FILE LINE PARSE LOOP

    if(passage.notNil.and {parsed.notNil}) {
      parsed.put(passage[\id], passage);
      "END PASSAGE %\n\n".format(passage[\id]).postln;
    };

    "\n\n\n\nRAW###\n%".format(raw).postln;
    "\n\n\n\nPARSED###\n%\n\n".format(parsed).postln;
    a.stories.put(fi.fileName, parsed);
  } // END FILE
}

