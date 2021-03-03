b = Buffer.alloc(s, 512, 1);
a = Harmonics.new();

b.sine2(a.teeth(2, 3).postln, a.geom(1.2), true, true, true);

Ndef(\lowfreq1).fadeTime = 0.01;
Ndef(\lowfreq2).fadeTime = 0.01;
Ndef(\pad).fadeTime = 3;
Ndef(\squiz).fadeTime = 3;

Ndef(\lowfreq1, {arg bufnum=0, freq = 60;
	var env = EnvGen.kr(Env.sine(\rel.kr(8.75)) );
	AudioMSG.ar( Osc.ar(bufnum, freq, 0, env), \index.kr(0.015) * pi, 0.5);
});

Ndef(\lowfreq2, {arg bufnum=0, freq = 60, index = 0.1;
	var env = EnvGen.kr(Env.sine(\rel.kr(1)) );
		AudioMSG.ar(
		Osc.ar(bufnum, freq, 0, env), index * pi
		)
});

Ndef(\pad, {
	Pan2.ar(
		Ringz.ar(
	WhiteNoise.ar(0.01),
		{
				Scale.major(\just).degreeToFreq(2.rand, \freq.kr(60).midicps, \oct.kr(1))
		}!8, \bwr.kr(0.13)
	).sum.tanh,
		LFNoise1.kr(1).range(-1, 1)
	)
});


Ndef(\mod, { \in.ar * SinOsc.ar(\freq.kr(0.1), \phase.kr(1) * pi, \mod.kr(0.1) ) });

Ndef(\pad)[1] = \xset -> Pbind(\dur, 8, \freq, Prand((60..65), inf), \oct, Prand([1, 2, 3, 4], inf) );

Ndef(\pad)[2] = \filter -> {|in| HPF.ar(in) }

Ndef(\hrmnzr, {
	AudioMSG.ar(\in.ar, \index.kr(1) * pi);
});

Ndef(\waveloss, {
	 var sig = [SinOsc.ar, PinkNoise.ar].mean;
	var mode = MouseY.kr(1,2).round;
	//WaveLoss.ar(\in.ar, \drop.kr(20), \outoff.kr(40), 2).dup.tanh;
	WaveLoss.ar(\in.ar([0, 0]).mean, MouseX.kr(0, 40), 40, mode: mode, mul: 0.1);
});

Ndef(\squiz, {
	Squiz.ar(\in.ar([0, 0]), \pitchratio.kr(2), \zcperchunk.kr, \memlen.kr(0.1) );
});

Ndef(\freeze, {
	var chain;
	chain = FFT(LocalBuf(2048), \in.ar );
	chain = PV_MagFreeze(chain, LFNoise0.kr(0.2) );
	0.8 * IFFT(chain).dup.tanh;
});


Ndef(\pitch, {
	PitchShift.ar(\in.ar, 0.2, \pitch.kr(1), \pitchDisp.kr(0.1), 2);
});


Ndef(\noizL, { LatoocarfianC.ar(s.sampleRate * \index.kr(1), 1, 3) });
Ndef(\noizC, { Crackle.ar( 0.01, 0.01 )});


Ndef(\lowfreq1)[1] = \xset -> Pbind(\dur, Pgeom(0.03, 1.1), \freq, 60, \rel, Pkey(\dur) * 0.7);
Ndef(\lowfreq2)[1] = \xset -> Pbind(\dur, Pgeom(1, 1.1), \freq, 4, \index, 2, \rel, Pkey(\dur) * 0.5);
Ndef(\lowfreq2)[1] = \xset -> Pbind(\dur, Pgeom(300.0, 1.01, inf) * 0.02, \freq, 4, \index, 0.75, \rel,  0.5);


NdefMixer(s);