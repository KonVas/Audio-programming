
// Grains using a granular Ugen: GrainBuf;
(
var winenv;

b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01-44_1.aiff");
// a custom envelope

winenv = Env([0, 1, 0], [0.5, 0.5], [8, -8]);

z = Buffer.sendCollection(s, winenv.discretize, 1);

Ndef(\bufGrain, { |gate = 1, amp = 1, sndbuf, envbuf|
    var pan, env, freqdev;
    // use mouse x to control panning
	    pan = LFNoise1.kr(1).range(-1, 1);
    env = EnvGen.kr(
        Env([0, 1, 0], [1, 1], \sin, 1),
        gate,
        levelScale: amp,
        doneAction: Done.freeSelf);
        o = GrainBuf.ar(2,
		Impulse.kr(\speed.kr(1)), 0.1, sndbuf,
		LFNoise1.kr.range(0.5, 2),
            LFNoise2.kr(0.1).range(0, 1), 2, pan, envbuf) * env;
	o.dup;
	Pan2.ar(o, pan);
}).play(0, 2);
)

NdefMixer(s);

// switch to the custom env
Ndef(\bufGrain).set(\envbuf, z); //set method expects a value.
Ndef(\bufGrain).set(\envbuf, -1);

// Manually, change the speed of grains.
Ndef(\bufGrain).set(\speed, 20);

// ANother ktrl ndef;
Ndef(\ktrl, {LFNoise1.kr(1).range(1, 600) });

//Map speed with Ndef ktrl;
Ndef(\bufGrain).map(\speed, Ndef(\ktrl) ) //map method expects a stream of values or signal.

Ndef(\bufGrain)[1] = \filter -> {arg in; PitchShift.ar(in, 0.2, 0.1, 1.5, 0.25) }

// BREAK == true;

//Grains using patterns, with PlayBuf;

(
Ndef(\grainBuf2, {
	var env = EnvGen.kr(Env.perc(0.01, \dur.kr(0.3)) );
	PlayBuf.ar(b.numChannels,
		\bufnum.kr(0),
		\rate.kr(1),
		\trigger.kr(1),
		\startPos.kr(0.1),
		loop:0
	).dup * env
}).play(0, 2);

Ndef(\grainBuf2)[1] = \xset -> Pbind(\dur, 0.09, \rate, Pwhite(0.1, 10) );
)

Ndef(\grainBuf2)[3] = \filter -> {arg in; PitchShift.ar(in, 0.2, 0.1, 1.5, 0.25) };




