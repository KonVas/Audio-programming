(
SynthDef(\blip, {|out = 0, amp = 0.6, dur = 1, freq = 1|
	var sig, env;
	env = EnvGen.kr(Env.perc(0.01, dur), doneAction:2); //take care of doneAction!
	sig = SinOsc.ar([120.0, 121.0] * freq); //two output sine oscillator synth.
	sig = sig / 2;
	Out.ar(out, sig * amp * env); //out creates a buss.
}).add;
)

(
SynthDef(\crackle, {|out = 0, chaos = 1.5, amp = 0.6, envDur = 0.3|
	var env, sig;
	env = EnvGen.kr(Env.sine(envDur), doneAction:2);
	sig = Crackle.ar(chaos, 0.5, 0.5);
	sig = sig.dup / 2; //duplicating the signal so it plays in both channels.
	Out.ar(out, sig * amp * env);
}).add;
)

//Control SynthDefs using Events.
//Pbind example
Pbind(\instrument, \blip, \dur, 0.25, \freq, 1).play;
Pbind(\instrument, \blip, \dur, 0.25, \freq, 2).play;
Pbind(\instrument, \blip, \dur, 0.5, \freq, 0.5).play;

Pbind(\instrument, \sawy, \dur, 0.1, \speed, 2, \freq, 3).play;
Pbind(\instrument, \sawy, \dur, 0.01, \speed, 2, \freq, 1).play;

//To change something without stopping the sound use a Pdef.
//Pdef example
Pdef(\x).play;
Pdef(\x,  Pbind(\instrument, \crackle, \dur, 2));
Pdef(\x, Pbind(\instrument, \crackle, \chaos, Pwhite(0.1, 2.0, inf),  \envDur, 0.3, \dur, 0.08));

//...and change things 'on the fly'
Pdef(\y, Pbind(\instrument, \blip, \dur, Pbrown(0, 6, 0.1, inf), \freq, 2));
Pdef(\y).play;
Pdef(\y).stop; //suspend and start later again.