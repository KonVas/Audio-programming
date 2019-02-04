/*Here is a monophonic synth. For its notes it will convert the key values into midi notes and sonify them using an LFSaw oscillator*/

s.waitForBoot{

	SynthDef(\playNotes, {|amp=0.6, note|
		var env = EnvGen.kr( Env.perc(0.01, 0.3), doneAction:2);
		var out = Splay.ar(LFSaw.ar({note.midicps * Rand(0.1, 0.2)}!8, Rand(pi, 2pi), amp));
		ReplaceOut.ar(0, out * env);
	}).add;

	OSCdef(\playNotes, {|msg|
		Synth(\playNotes, [\note, msg[1] ]);
	}, '/test');

};
