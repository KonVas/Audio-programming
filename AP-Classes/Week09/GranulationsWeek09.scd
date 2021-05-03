//Granular synthesis in SC
// 1. using a sine oscillator.

(
SynthDef(\sineGrain, {|out = 0, freq = 120.0, rel = 0.2, amp = 0.5|
	var env = EnvGen.kr(Env.perc(releaseTime:rel), doneAction:2);
	var sig = SinOsc.ar(freq, 0, amp);
	ReplaceOut.ar(out, sig * env);
}).add;
)

Synth(\sineGrain); //test

(
Tdef(\grainChange, {
	loop{
	0.05.wait;
		~speed = rrand(0.01, 0.03);
		~pitchValue = rrand(1.0, 10.0);
		["Speed is: " ++ ~speed, "Pitch is: " ++ ~pitchValue].postln;
	}
}).play
)

~speed = 0.3;
~pitchValue = 1.0;

(
Pbind(\instrument, \sineGrain,
	\dur, Pfunc{ ~speed + 0.01 },
	\degree, Pfunc{ ~pitchValue + rrand(0.1, 0.5) },
	\rel, 0.2
).play;
)

// Use some designated classes for Granular synthesis.
(
SynthDef(\sineGrain2, {
	|amp = 0.5, out = 0, speed = 1.0, dur = 0.5, grainFreq = 120.0|
	var trigger = Impulse.kr(speed);
	var sig = SinGrain.ar(trigger, dur, grainFreq);
	ReplaceOut.ar(out, sig.dup * amp); //mind signal is duplicated here.
}).add;
)


x = Synth(\sineGrain2, [\speed, 8, \dur, 0.1, \grainFreq, 120]);

Tdef(\grain2, {
	loop{
		var time = 0.05; //abstract any value passed as reference.
		time.wait;
		x.set(\speed, time.reciprocal, \grainFreq, exprand(120.0, 1220.0));
	};
}).play


//free the synth be tidy.
x.free; Tdef(\grain2).stop;

//A grain synth that uses buffer sound.

b = Buffer.read(s, "/Users/konstantinos/Desktop/09 Ping.aiff");
b.plot; // plot to see if loaded.

SynthDef(\grainbuf1, {
	|amp = 0.5, out = 0, buf = 0, rate = 1, start = 0, duration = 0.4, speed = 1.0|
	var trigger = Impulse.kr(speed);
	var sig = PlayBuf.ar(b.numChannels, buf, rate * BufRateScale.ir(buf), trigger, start)
	* EnvGen.kr(Env.sine(duration), doneAction:2);
	ReplaceOut.ar(out, sig.dup);
}).add;

Pbind(\instrument, \grainbuf1,
	\dur, 0.2,
	\rate, Pwhite(0.5, 10),
	\buf, b,
	\duration, Pwhite(0.1, 0.6)
).play;

/*
Assignement: add your own parameters and make some more granulated sounds
using these examples, you can use buffers or just oscillators as sources.
*/
		