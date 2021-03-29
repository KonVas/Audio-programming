{SinOsc.ar()}.play;


Pbind(\dur, \instrument, \sine, 0.25, \degree, 3, \legato, 0.01, \octave, 4).play


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
x = Synth(\blip, [\freq, 880] )

Pbind(
	\dur, 0.08,
	\instrument, \blip,
	\degree, 3,
	\legato, 0.01,
	\octave, 4
).trace.play;

/////////////////

SynthDef(\nameA, {
	arg freq = 1, releaseTime = 0.5, attackTime = 0.01, amp = 0.01;
	var env = EnvGen.kr(Env.perc(attackTime, releaseTime), doneAction:2);
	Out.ar(0,
		SinOsc.ar([440, 446, 448.5, 882] * freq, 0, amp) * env
	);
}).add;

Pbind(\dur, 0.25,
	\instrument, \nameA,
	\degree, 0.2
).play;


