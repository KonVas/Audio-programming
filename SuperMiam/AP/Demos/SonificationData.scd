~dataFile = [1, 4, 6, 8, 10, 30, 50, 55, 52];

(
Ndef(\grainSin, {|panSpeed = 1, amp = 0.1, freq = 220, rel = 0.3|
	var pos, sig, env;
	env = EnvGen.ar(Env.perc(0.01, rel), doneAction:0);
	pos = LFNoise1.kr(panSpeed).range(-1, 1);
	sig = SinOsc.ar(freq, 0, amp);
	sig = HPF.ar(sig, 220);
	sig = Pan2.ar(sig * env, pos);
}).play
)

p = Prand(~dataFile, inf).asStream; //pick each value from the pseudo-data-file.

(
Tdef(\x, {
	loop{
		~dur.wait;
	Ndef(\grainSin).set(\freq, p.next * 100)
	}
}).play
)


Ndef(\grainSin).fadeTime = 0.05;
Ndef(\grainSin)[1] = \xset -> Pbind(\dur, 0.05, \degree, Pxrand(~dataFile / 0.2, inf));

Ndef(\grainSin).stop(9);

