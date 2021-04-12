MIDIClient.init;
//Start MIDI Client, and connect.
MIDIIn.connectAll;

//select your MIDI Driver(s) in Audio MIDI Setup (MacOS).
~mOut = MIDIOut.newByName("IAC Driver", "Bus 1").latency_(Server.default.latency);

//this assumes you have Pigments in your Apllications folder in MacOS.
"open -a /Applications/Arturia/Pigments.app".unixCmd;

//run this pbindef to start sending MIDI to Pigments VST.
(
p = Pbindef(\x,
	\type, \midi, // select the type, midi for midi sequencing.
	\midiout, ~mOut,    // must provide the MIDI target here
	\chan, 0,
	\scale, Scale.mixolydian,
	// degree is converted to midinote, not just frequency
	\degree, Prand((1..14), inf),
	\dur, Pwrand([0.25, Pn(0.125, 2)], #[0.8, 0.2], inf) * 2,
	\legato, sin(Ptime(inf) * 0.5).linexp(-1, 1, 1/3, 3),
	\octave, Pwhite(1, 5),
	\amp, Pexprand(0.5, 0.3, inf),
	\sustain, Pseq((1..10.0), inf)
).trace
)

p.play;
p.stop;