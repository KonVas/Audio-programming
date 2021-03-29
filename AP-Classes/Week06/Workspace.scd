~fxBus = Bus.audio(s, 1);

~fxBus.scope;

(
SynthDef(\source, {| out = 0, freq = 120, freqMod = 1, release = 0.25, amp = 0.1 |
	var signal, env;
	env = EnvGen.kr(Env.perc(attackTime:release), doneAction: 0);
	signal = SinOsc.ar(freq * (freqMod + Rand(0.1, 5.0)), 0, amp);
	Out.ar(out, signal);
}).add;

SynthDef(\fx, {| out = 0, freq = 220, in = 0, amp = 0.5 |
	var signal, input;
	input = In.ar(in, 1);
	signal = Ringz.ar(input, freq, 0.5, amp);
	signal = signal * 0.5;
	signal = {signal}!2;
	Out.ar(0, signal);
}).add;
)

2.do{"hello".postln}; // duplicate string
//Alternatively with shortcut:
{"hello".postln}!2 //sugar syntax

(
//order of execution using addActions in Nodes:
Synth(\source, [\freq,  440, \out, ~fxBus]);
Synth(\fx, [\freq, 660, \in, ~fxBus]);
)

~sourceGroup = Group.new(s, addAction:'addToHead');

~fxGroup = Group.new(s, addAction: 'addToHead');

x = {
	var instruments = [(1..10)].choose;
	instruments.do{
		Synth(\source, [\freq, exprand(120.0, 1200.0), \amp, 0.5 / 10], ~sourceGroup);
}
}

x.value;

~sourceGroup.set(\freqMod, 0.5);

~sourceGroup.free;
~sourceGroup.query;

