// Week 05

//Last weeks notes on incremental values from inside an array;
a = Array.series(10, 1, 1);
// ->[ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ]

p = 0;

fork { loop {
	1.wait;
p = a[p] % a.size;
	p.postln;
}
};

//////////////////
SynthDef // an instruction of creating the synthesizer

Synth // A node of the SynthDef which is submitted to the Server.

s.queryAllNodes;

(
SynthDef(\test1,
	{| out = 0, amp = 0.1, freqMul = 1 |
	Out.ar(out,
		SinOsc.ar([440, 446, 448.5, 882] * freqMul, 0, 0.1) * amp;
	)}
).add; //skipping .add, no synth added to server.
)

~tones = Synth(\test1, [\out, 0, \freqMul, 0.5]);//a node
~tones.set(\amp, 0.25);
~tones.free;

//some task example using all materials so far.

~notes = Array.series(10, 0.01, 0.25);

fork {
	loop{
		0.25.wait;
		~tones.set(\freqMul, ~notes.choose);
	}
};

// SynthDef Enveloping:

(
SynthDef(\myEnvSynth1, {|out = 0, freqMul = 1, amp = 0.3, dur = 0.5|
  var sig, env, pan;
	pan = LFNoise1.ar(1).range(-1, 1);
	env = Env.sine(dur);
	sig = SinOsc.ar( ExpRand(120.0, 1220.0), 2pi*0.25.rand );
  sig = sig * EnvGen.kr(env, doneAction: 2); //2 suspends the synth when done
	sig = Pan2.ar(sig, pan);
	Out.ar(out, sig * amp);
  }).add;

SynthDef(\myEnvSynth2, {|out = 0, freqMul = 1, amp = 0.3, dur = 0.5|
  var sig, env, pan;
	pan = LFNoise1.ar(1).range(-1, 1);
	env = Env.perc(releaseTime: dur);
	sig = SinOsc.ar( ExpRand(60.0, 120.0), 2pi*0.25.rand );
  sig = sig * EnvGen.kr(env, doneAction: 2); //2 suspends the synth when done
	sig = Pan2.ar(sig, pan);
	Out.ar(out, sig * amp);
  }).add;
)


(
fork {
	var time;
	loop{
		time = rrand(0.1, 1.5);
		time.wait;
		//Synth Tone:
		Synth(\myEnvSynth1,
			[
				\amp, 0.1,
				\dur, time + rrand(0.5, 1.5)
		]);
		//Synth Blip:
		Synth(\myEnvSynth2,
			[
				\amp, 0.1,
				\dur, time + rrand(0.5, 1.5) / 2
		]);
}
}
)

