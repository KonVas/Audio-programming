(
SynthDef(\myEnvSineSynth, {
	|out = 0, amp = 0.3, dur = 0.5, freq = 1|
	var sig, env;
	env = Env.sine(dur);
	sig = SinOsc.ar([120.0, 121.0] * freq);
	sig = sig * EnvGen.kr(env, doneAction: 2);
	Out.ar(out, sig * amp);
}).add;

SynthDef(\myEnvSawSynth, {
	|out = 0, amp = 0.3, dur = 0.5, freq = 1|
	var sig, env;
	env = Env.sine(dur);
	sig = Saw.ar([120.0, 121.0] * freq);
	sig = sig; //EnvGen.kr(env, doneAction: 2);
	Out.ar(out, sig * amp);
}).add;
)

(
Synth(\myEnvSineSynth, [\dur, 0.9]);
x = Synth(\myEnvSawSynth, [\dur, 0.3]);
)

(
Pdef(\x,
	Pbind(
		\dur, 0.1,
		\instrument, \myEnvSineSynth,
		\freq, Pseries(1, 2, inf),
		\amp, 0.3,
		\legato, 2,
		\dur, Pkey(\dur, inf),
	)
).play;


Pdef(\y,
	Pbind(
		\dur, 0.1,
		\instrument, \myEnvSawSynth,
		\freq, Pseries(1, 2, inf)
	)
).play
)