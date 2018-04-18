Ndef(\sine, {SinOsc.ar(\freq.kr(220)) * Impulse.kr(1)}).play;
Ndef(\saw, {Saw.ar(\freq.kr(220)) * 0.5}).play;

//Standard way to manipulate a signal of Ndef.
Ndef(\hpf, {HPF.ar(Ndef(\z).ar)}).play;
Ndef(\pitch, {PitchShift.ar(Ndef(\hpf).ar, 0.25, 4, pitchDispersion:1, timeDispersion:0.24)}).play;

//add custom specs to ndefMixer ranges and other params.
Spec.add(\freq, [1, 100.0, \lin, 0.01, 10]);

//Second way...
Ndef(\pitch, {PitchShift.ar(\in.ar(0), 0.25, 4, pitchDispersion:1, timeDispersion:0.25)}).play;

//Define the balance of manipulation, in JITLib style.
Ndef(\sine)[1] = \filter -> {arg in; FreeVerb.ar(in) };
Ndef(\sine)[2] = \filter -> {arg in; CombC.ar(in, 0.9, 0.9, 0.3) };

//Controling Ndef with Events - Pbind.
Ndef(\saw)[1] = \xset -> Pbind(\dur, 0.25, \freq, Pseq([100, 200, 300], inf) )
Ndef(\saw)[2] = \xset -> Pbind(\dur, 0.25, \freq, Prand([100, 200, 300], inf) )