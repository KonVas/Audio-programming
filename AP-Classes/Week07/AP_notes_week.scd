s.boot


(
o = Server.default.options;
o.device = "ZoomAudioD";
s.reboot;
)

(
SynthDef(\additive, {| out = 0, amp = 0.1, freq = 1 |
	var signal, numSins = 8, modulo;
	signal = Mix.fill(numSins, {
		SinOsc.ar( ExpRand(120.0, 1220.0) + freq, Rand(0.1, 1.0) * pi )
	});
	signal = {signal}!2;
	signal = signal / numSins * amp;
	signal = LeakDC.ar(signal);
	Out.ar(out, signal);
}).play;
)

(
SynthDef(\additive_klang, {| out = 0, amp = 0.1 |
	var signal, numOsc = 8;
	signal = Klang.ar(`[ Array.rand( numOsc, 120, 1220.0), nil, nil ], 1, 0);
	signal = {signal}!2;
	signal = LeakDC.ar(signal * amp);
	Out.ar(out, Splay.ar(signal))
}).play;
)

(
SynthDef(\additive_expand, {| out = 0, gate = 1, freq = 120, amp = 0.1 |
	var signal, mod, pan;
	pan = LFNoise1.kr(1).range(-1, 1);
	mod = LFNoise1.kr(0.1).range(0.1, 1.0);
	signal = SinOsc.ar(freq, Rand(0.1, 1.0) * pi, mod);
	signal = {signal}!2;
	signal = signal * EnvGen.kr(Env.sine(4), gate, 0.8, doneAction:Done.freeSelf) * amp;
	signal = LeakDC.ar(signal);
	Out.ar(out, Splay.ar(signal, level: pan));
}).add;
)

(
fork{
	loop{
		n = rrand(1, 12);
		n.do{ //synth number
			0.75.wait;
			Synth(\additive_expand, [\freq, exprand(120, 1220.0), \amp, 1.0 / n ]);
			("Synths amount:" + n).postln;
		}
	}
}
)


(
SynthDef(\amplitude, {| out = 0, amp = 0.5, freq = 220, freqMod = 440 |
	var signal;
	signal = SinOsc.ar(freq) * SinOsc.ar(freqMod * 2).abs;
	signal = {signal}!2;
	Out.ar(out, signal);
}).add;
)

x = Synth(\amplitude, [\freq, 120])
x.set(\freqMod, 50);

(
SynthDef(\grains, {| freq = 220, freqMod = 440, out = 0, gate = 1, grainLength = 0.075, amp = 0.5|
	var signal, env;
	env = EnvGen.kr(Env.perc(0.02, grainLength, amp), gate, doneAction:Done.freeSelf);
	signal = SinOsc.ar(freq) * SinOsc.ar(freqMod * 2).abs;
	signal = {signal}!2;
	signal = signal * env * amp;
	signal = LeakDC.ar(signal);
	Out.ar(out, signal);
}).add
)

(
fork{
	loop{
		0.06.wait;
		Synth(\grains, [\freq, 80, \grainLength, rrand(0.1, 0.25), \freqMod, 100.rand(10)]);
	}
}
)

(
var path =  Platform.resourceDir +/+ "sounds/a11wlk01-44_1.aiff";
b = Buffer.read(s, path:path);
)

(
SynthDef(\play_buf_grains, {
	| out = 0, buffer = 0, rate = 1, gate = 1, speed = 1, bufPos = 0, grainLength = 0.1, amp = 0.75 |
	var signal, env, pan, trigger, bufDur;
	bufDur = BufDur.ir(buffer);
	trigger = Impulse.kr(speed / bufDur);
	pan  = LFNoise1.kr(1).range(-1, 1);
	env = EnvGen.kr(Env.perc(0.01, grainLength, amp), gate, doneAction:Done.freeSelf);
	signal = PlayBuf.ar(
		numChannels: buffer.numChannels,
		bufnum: buffer,
		rate: BufRateScale.ir(buffer) * rate,
		trigger: trigger / grainLength,
		startPos: bufPos * BufFrames.ir(buffer),
		loop: 1);
	signal = {signal}!2 * env;
	Out.ar(out, Pan2.ar(signal, pan, amp))
}).add
)

//Synth(\play_buf_grains, [\buffer, b, \grainLength, 0.2, \bufPos, 0.5]); //test

(
fork{
	loop{
		0.05.wait;
		Synth(\play_buf_grains, [
			\buf, b,
			\rate, rrand(0.1, 2.0),
			\bufPos, rrand(0.1, 1.0),
			\grainLength, rrand(0.1, 0.5),
		])
	}
}
)


(
SynthDef(\grain_buf_ugen, {
	| out = 0, buffer = 0, rate = 1, gate = 1, speed = 1, bufPos = 0, grainLength = 0.1, amp = 0.8 |
	var signal, trigger, env, pan, bufDur;
	bufDur = BufDur.kr(buffer);
	trigger = Impulse.kr(speed / bufDur);
	pan = WhiteNoise.kr(0.6);

	signal = TGrains.ar(
		numChannels: buffer.numChannels,
		trigger: trigger,
		bufnum: buffer,
		rate: rate,
		centerPos: bufPos / bufDur,
		dur: bufDur,
		pan: pan);

	Out.ar(out, signal.dup * amp);
}).add;
)


(
~grainSynth = Synth(\grain_buf_ugen, [\buffer, b]); //start the synth.
//manipulate the grain parameters with a loop:
fork{
	loop{
		~grainSynth.set(\rate, rrand(1, 4), \bufPos, rrand(0.1, 1), \bufDur, rrand(0.03, 0.08));
		0.25.wait;
	}
}
)