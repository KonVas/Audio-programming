s.reboot;

// check your Server's attributes
o = Server.local.options;
o.numInputBusChannels;
o.numOutputBusChannels;

o.numInputBusChannels = 2;
o.numOutputBusChannels = 4;

o.device = "AudioBox 1818 VSL"; //if available.

s.reboot;

o.device

s.meter;
////////changed outs//////

play{ SinOsc.ar({ExpRand(120.0, 1220.0)}!4, mul:0.5) * Impulse.kr(1) };


/////synth paradigm

SynthDef(\multChan, {arg out = 0;
  var sig = SinOsc.ar({ExpRand(120.0, 1220.0)}!4, mul:0.5);
	Out.ar(out, sig.sum * Impulse.kr(1)); //mono signal using sum method
  }).add;

SynthDef(\blip, {arg out = 0;
  var sig = Saw.ar({ExpRand(120.0, 1220.0)}!4, mul:0.5);
	Out.ar(out, sig.sum * Impulse.kr(1)); //mono signal using sum method
  }).add;

  //test is working
Synth(\multChan, [\out, ~bus1]);
Synth(\blip, [\out, ~bus2]);

~bus1.scope
~bus2.scope

~bus1 = Bus.audio(s, 1); //create a bus to route signal.
~bus2 = Bus.audio(s, 1);

SynthDef(\rev, {| out = 0, in |
	var sig = GVerb.ar( In.ar(in) );
	Out.ar(out, sig);
}).add;

/*take care of order of execution by adding the fx after the singal synth*/
Synth(\rev, [\out, 1, \in, ~bus1], addAction: 'addToTail');

//change outs with Pbind way

SynthDef(\sine, {arg out = 0, relTime = 0.5, freq = 120.0;
	var env = EnvGen.kr(Env.perc(attackTime: relTime), doneAction: 2);
	var sig = SinOsc.ar(freq * Rand(0.1, 2.0), Rand(0.1, 2pi), mul:0.5);
	sig = sig * 0.5;
	Out.ar(out, sig); //mono signal using sum method
  }).add;

~speakersArray = [0, 1, 2, 3]; //speaker number depending on audio interface

p = Pbind(
	\instrument, \sine,
	\dur, 0.25,
	\degree, 1,
	/*Pseq([
	Pseq([1, 1, 1], 1), Pseq([2, 2, 2], 1)
	], 1),*/
	\out, Prand([0, ~bus1], inf), //pick randomly output.
	\relTime, 0.25
)
.trace.play;

p.stop;
