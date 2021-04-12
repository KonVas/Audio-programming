//Scheduling Events in SuperCollider

//Sequencing:

o = ServerOptions.new
//o.device = "ZoomAudioD";
s.reboot

fork{ loop{ 1.wait; "Hello".postln }};

//test stereo out is working:
{Pan2.ar(PinkNoise.ar(0.1), FSinOsc.kr(0.2))}.play

(
	fork{
		loop{
			0.5.wait;
		v = rrand(0.1, 1.0);
		postcs("some random val:" + v);
		}
	}
)

//Sound example of routine:
//First load a SynthDef:
(
SynthDef(\blip, {|out = 0, pan = 0.0, harmonics = 2, rel = 0.25, freq = 120.0, amp = 0.75|
	var sig, env;
	env = EnvGen.kr(Env.perc(0.02, rel), doneAction:Done.freeSelf);
	sig = Blip.ar(freq, harmonics) * env;
	sig = sig * amp * AmpComp.kr(freq, 300);
	ReplaceOut.ar(out, Pan2.ar(sig, pan) / 12)
}).add;
)

(
fork{
	loop{
		0.25.wait;
		Synth(\blip, [\pan, -1, \amp, 1]);
		3.wait;
		Synth(\blip, [\pan, 1, \amp, 1])
	}
}
)

(
r = Routine({
	var delta;
	loop {
		delta = rrand(1, 3) * 0.25;
		Synth(\blip, [pan: rrand(-1, 1), freq: exprand(120, 1220), amp: 0.5]);
		delta.wait;
	}.fork
})
)

r.play;
r.stop;

//Using an array of given values:
(
r = Routine({
	var delta, notes;
	loop {
		delta = rrand(1, 3) * 0.25;
		notes = [60, 72, 71, 67, 69, 71, 72, 60, 69, 67];
		Synth(\blip, [pan: rrand(-1, 1), freq:notes.choose, amp: 1]);
		delta.wait;
	}.fork;
})
)

r.play;
r.stop;


//Manipulate the tempo of the Scheduling:
t = TempoClock.default;
t.tempo = 2.0;
t.tempo_(1.0); //same as above.





//Events are in key value pairs (like dictionaries) and represent
//an action to be taken when playing them:
(instrument:\blip, freq: 220).play;


(
SynthDef(\blip, {|out = 0, pan = 0.0, harmonics = 2, rel = 0.25, freq = 120.0, amp = 0.75|
	var sig, env;
	env = EnvGen.kr(Env.perc(0.02, rel), doneAction:Done.freeSelf);
	sig = Blip.ar(freq, harmonics) * env;
	sig = sig * amp * AmpComp.kr(freq, 300);
	ReplaceOut.ar(out, Pan2.ar(sig, pan) / 12)
}).add;
)

(\instrument: \blip, freq: 120, amp:0.8).play;

//Pattern sequences
a = [60, 72, \rest, 67, 69, \rest, 72, 60, \rest, 67];
p = Pseq(a, inf).asStream;


(
b = Pbind(
	\instrument, \blip,
	\dur, Pseq([0.1, 0.35, 0.6], inf) * 0.5,
	\amp, 0.7,
	\degree, Pseq(a.cpsmidi, inf) * Pfunc{ foo },
	\octave, Pbrown(1, 6.0, step: 1) / 2
).play;
)


b.stop;



















