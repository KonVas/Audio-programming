//Setting a param val conditionally.

Ndef(\fmgrain, {
	FMGrain.ar(Impulse.ar(20), 0.2,
		\carFreq.kr(440),
		\modFreq.kr(200),
		LFNoise1.kr(1).range(1, 10),
		EnvGen.kr(
			Env.sine(\dur.kr(1.0)),
				\gate.kr(1),
				doneAction:2)
		)
}).play;

Spec.add(\carFreq, [0.1, 10]);
Spec.add(\modFreq, [0.1, 15]);
Spec.add(\dur, [0.1, 2.0]);

(
w = Window("softSet", Rect(500, 200, 500, 440)).front;
w.view.addFlowLayout;
NdefGui(Ndef(\fmgrain), 4, w);

~sl = ();
~cs = (\carFreq:\carFreq.asSpec, \modFreq:\modFreq.asSpec, \dur:\dur.asSpec);

[\carFreq, \modFreq, \dur].do({|par|
	~sl[par] = EZSmoothSlider(w, 380@30, par, ~cs[par], Routine { |sl|
		var newVal, lastVal;
		loop {
			newVal = sl.value;
			Ndef(\fmgrain).softSet(par, newVal.lag(0.3), 0.01, lastVal: lastVal, spec:~cs[par]);
			lastVal = newVal;
			\dummy.yield;
		}
	})
});
);

MIDIClient.init;
MIDIIn.connectAll;
MIDIFunc.trace(false);

~cc = (1:\carFreq, 2:\modFreq, 3:\dur);

~midicontrol = MIDIdef.cc(\akaiKnobs, {|val, num|
	{ ~sl[ ~cc[num] ].valueAction_( ~sl[ ~cc[num] ].controlSpec.map(val/127)) }.defer
}, (1..3) );