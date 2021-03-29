//Event in SC, assign keys to values.
e = (freq: 100, dur:0.1);

e[\freq];
e[\dur]


//A SynthDef to play with
SynthDef(\blip, {|out = 0, pan = 0.0, rel = 0.25, freq = 120.0, amp = 0.6|
	var sig, env;
	env = EnvGen.kr( Env.sine(rel), doneAction:2) * amp;
	sig = SinOsc.ar(6, 0, 0.3);
	sig = Ringz.ar(sig, {freq * Rand(0.98, 1.02) } ! 8, 0.3);
	sig = sig * 0.5;
	Out.ar(out, Pan2.ar(sig.sum, pan) / 8)
}).add;

e = (instrument: \blip, freq: 440, dur: 0.5);
e.play;

t = TempoClock.default.tempo = 3;

~note = 1;

(
p = Pbind(
	\instrument, \blip,
	\dur, 0.25,
	\degree, Pfunc({ ~note * rrand(1, 30) }).asStream,
	\rel, 0.2,
	\pan, Pfunc({ [-1, 1].choose }).asStream,
).trace.play(t);
)

p.stop;

//A nice start to learn about patterns
e = (instrument: \blip, freq: 440, dur: 0.5);
e.play
