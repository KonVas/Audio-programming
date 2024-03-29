//Granular Synthesis using Patterns.
//http://supercolliderbook.net/wilsondescrivanch3.pdf

b = Buffer.read(s, "/Applications/SuperCollider/SuperCollider.app/Contents/Resources/sounds/a11wlk01-44_1.aiff"); //use another sound.

b.plot;

t = TempoClock.new; //master clock for Pbindefs
t.tempo = 1; //change the tempo of the clock using a slider.

(
w = Window.new("TempoSlider", 120@600).front;
~slider = EZSlider(w, w.view.bounds);
~slider.action_({|sl|
	if(t.notNil{
	t.tempo = sl.value.round(0.01).postln * 2 + 10
	});
});
)

(
SynthDef(\grainSin, {|out = 0, panSpeed = 1, amp = 0.1, freq = 1, rel = 0.3|
	var pos, sig, env;
	env = EnvGen.ar(Env.perc(0.01, rel), doneAction:2);
	pos = LFNoise1.kr(panSpeed).range(-1, 1);
	sig = SinOsc.ar(freq, 0, amp);
	sig = HPF.ar(sig, 220);
	sig = Pan2.ar(sig, pos);
	Out.ar(out, sig * env);
}).add;
)

(
SynthDef(\grainBuf, {|out = 0, panSpeed = 1, amp = 0.1, rate = 1, buf, rel = 0.3|
	var pos, sig, env;
	env = EnvGen.ar(Env.perc(0.01, rel), doneAction:2);
	pos = LFNoise1.kr(panSpeed).range(-1, 1);
	sig = PlayBuf.ar(buf.numChannels, buf, rate);
	sig = HPF.ar(sig, 220);
	sig = Pan2.ar(sig, pos);
	Out.ar(out, sig * env);
}).add;
)

x = Synth(\grainSin, [\amp, 0.5, \freq, 220.0]);//testing
y = Synth(\grainBuf, [\amp, 0.5, \rate, 2, \buf, b]);//testing


(
Pbindef(\x,
	\dur, 0.1,
	\instrument, \grainSin, //Sine Synth
	\degree, Pwhite(1, 10) * 2.5,
	\panSpeed, Pkey(\dur),
	\octave, Pfunc{ rrand(1, 4) },
	\scale, Scale.ionian,
	\amp, 0.1,
	\rel, Pwhite(0.1, 0.6) + 2
);

Pbindef(\y,
	\dur, 0.1,
	\instrument, \grainBuf, //buffer Synth
	\buf, b,
	\rate, Prand([1, 2, 3, \rest, 4, 0.5,-1], inf) * 0.1,
	\panSpeed, Pkey(\dur),
	\rel, Pkey(\dur) + 2.2
);
)

(
Pbindef(\x).play(t);
Pbindef(\y).play(t);
)

Pbindef.clear(8);

Pbind