NdefMixer(s);

//Order of execution is not a problem anymore in JITLib.

(
Ndef(\grainSin, {|panSpeed = 1, amp = 0.1, freq = 220, rel = 0.3|
	var pos, sig, env;
	env = EnvGen.ar(Env.perc(0.01, rel), doneAction:2);
	pos = LFNoise1.kr(panSpeed).range(-1, 1);
	sig = SinOsc.ar(freq, 0, amp);
	sig = HPF.ar(sig, 220);
	sig = Pan2.ar(sig * env, pos);
})
)

Ndef(\grainSin)[1] = \xset -> Pbind(\dur, 0.05, \degree, Pwhite(1, 10)) //play the above ndef with patterns :)

Ndef(\grainSin).stop(8) //add some fade out to .stop

Ndef(\x).fadeTime = 2;
Ndef(\x).play;
Ndef(\x, { SinOsc.ar(\freq.kr(120.0, 0.3)) * 0.1 });

Ndef(\x, { SinOsc.ar([\freq.kr(120.0), \freq.kr + 2.01]) / 2 * 0.1});
Ndef(\x, {LFSaw.ar([\freq.kr(120.0), \freq.kr + 2.01]) / 2 * 0.1});
Ndef(\x, {LFSaw.ar([\freq.kr(120.0), \freq.kr + 2.01]) / 2 * Linen.kr(Impulse.kr(\speed.kr(1)))});
// Make an Ndef mixer to control the node definitions via a GUI

NdefMixer(s);
Ndef(\averb, {FreeVerb.ar(Ndef(\x).ar, 0.5, 0.8) }); //load an Ndef for processing.

Ndef(\hpf, {HPF.ar(\in.ar(0), 0.5, 0.8) }); //load an Ndef for processing using an \in.ar control.

Ndef.clear(8)