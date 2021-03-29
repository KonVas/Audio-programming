
{SinOsc.ar([440, 446, 448.5, 882], 0, 0.1)}.play;

s.queryAllNodes

SynthDef(\test1, {
	Out.ar(0,
		SinOsc.ar([440, 446, 448.5, 882]*2, 0, 0.1)//multichannel expansion.
	)
}).add;

Synth(\test1);

s.queryAllNodes

SynthDef(\nameA, {
	arg releaseTime = 0.5, attackTime = 0.01;
	var env = EnvGen.kr(Env.perc(attackTime, releaseTime), doneAction:2);
	Out.ar(0,
		SinOsc.ar([440, 446, 448.5, 882]* ExpRand(1, 10), 0, 0.3) * env
	);
}).add;


(
9.do{
	Synth(\nameA, [\releaseTime, rrand(0.1, 1.0), \attackTime, rrand(0.01, 0.1)]);
}
)

//this is a bit loud let's fix the amp.

SynthDef(\nameA, {
	arg releaseTime = 0.5, attackTime = 0.01, amp = 0.01;
	var env = EnvGen.kr(Env.perc(attackTime, releaseTime), doneAction:2);
	Out.ar(0,
		SinOsc.ar([440, 446, 448.5, 882]* ExpRand(1, 10), Rand(0.1, 2.0)*pi, amp).sum * env
	);
}).add;


(
~synths = 8;
x = {
~synths.do{
	arg amp = 0.01;
	Synth(\nameA, [
			\releaseTime, rrand(0.1, 1.0),
			\attackTime, rrand(0.01, 0.1),
			\amp, amp / ~synths
	]);
}
}
)

(
Tdef(\x, {
	var time = 0.05, synths;
	loop{
		time = time + rrand(0.01, 0.5);
		~synths = rand(24);
		x.value;
		synths = ("number of synths: " ++ ~synths.asString);
		synths.postln;
		time.wait;
	}
}).play;
)

Tdef(\x).stop;









