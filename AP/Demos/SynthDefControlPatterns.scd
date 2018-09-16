SynthDef("pingy",
	{ arg out=0, freq=440, sustain=0.05, amp=0.1, pan;
		var env;
		env = EnvGen.kr(Env.perc(0.01, sustain), doneAction:2) * amp;
		Out.ar(out, Pan2.ar(Splay.ar(SinOsc.ar({freq * Rand(0.98, 1.02) } ! 20 , 0, env).clip), LFNoise1.kr(1).range(-1, 1), 0.6 ))
}).add;

Pbind(\dur, 0.03 + Pfunc{0.25.rand}, \instrument, \pingy, \degree, Prand('ForMIAM'.ascii / 2, inf).cpsmidi + Pfunc{rrand(1, 8)} ).play