(
SynthDef.new(\blip, {| out = 0 |
        var sig, env;
	sig = SinOsc.ar(\freq.kr(220, 0.3));
	env = EnvGen.kr(Env.perc(\attack.kr(0.03, 0.3), \release.kr(0.5, 0.3)), doneAction: 2);
	sig = sig * env * \amp.kr(0.2, 0.3);
    sig = Pan2.ar(sig, LFNoise1.kr(1).range(-1,1));
    Out.ar(out, sig)
}).add;
)
//:test
x = Synth(\blip, [\freq, 440] );

//Schedule something ahead to be performed by a SynthDef, using Tdefs...

(
Tdef(\x, {
	5.do{
		1.wait;
		Synth(\blip, [\freq, rrand(120.0, 1220.0) ] );
	};
	2.5.wait;

	8.do{
		0.5.wait;
		Synth(\blip, [
			\freq, rrand(120.0, 1220.0),
			\release, rrand(0.1, 0.9)] );
	};
	2.5.wait;

	32.do{
		0.08.wait;
		Synth(\blip, [\freq, rrand(120.0, 1220.0)] );
	};

	0.05.wait;
	"My job is done".postln;
});
)

Tdef(\x).play;

//Using events
(
Pdef(\x,
	Pbind(
	\dur, 0.25, \instrument, \blip,
	\freq, Prand((120..140) * 1, inf),
	\release, Pwhite(0.1, 0.9, inf)
)
);

Pdef(\y,
	Pbind(
		\amp, Pwhite(0.1, 0.6, inf),
	\dur, 0.25, \instrument, \blip,
	\freq, Pseq((120..140) * 2, inf),
	\release, Pwhite(0.1, 0.9, inf)
)
);
)

(
Pdef(\x).play;
Pdef(\y).play
)

Pdef(\x).quant = 1; // evaluate Pdef again after changing the quant value.
Pdef(\y).quant = 10;

Ndef(\x)[0] = Pdef(\x);// make an Ndef from Pdef automatically, but not play Pdefs when using this way.

NdefMixer(s)