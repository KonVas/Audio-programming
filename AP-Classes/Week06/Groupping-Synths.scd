l = Bus.audio(s, 2);

(
SynthDef(\blip, {|out = 0, rel = 0.3, freq = 460.0, amp = 1|
    var sig, env;
	env = EnvGen.kr( Env.perc(releaseTime:rel), SinOsc.kr(0.3), doneAction:2);
	sig = SinOsc.ar(freq, Rand(0.1, 2.0)*pi, 0.3);
    sig = sig * 0.5 * amp;
    Out.ar(out, sig.dup / 20)
}).add;
)

(
SynthDef(\ring, {|out = 0, freq = 120.0, in = 0, amp = 1|
    var sig, input;
	input = In.ar(in, 2);
    sig = Ringz.ar(input, {freq * Rand(0.98, 1.02) }!20, 0.3);
    sig = sig * 0.5 * amp;
	DetectSilence.ar(sig, doneAction:2);
    Out.ar(1, Splay.ar(sig.dup) / 20)
}).add;
)

(
//force the synth to be created at the top of the chain:
Synth(\blip, [\out, l], addAction: 'addToHead');

/*similarly we are forcing the fx synth to be created after source:*/
Synth(\ring, args: [\freq, 1220, \in, l], target: nil, addAction: 'addToTail');
)

//create some Synths, a random number of instances.
x = {
	var list = (1..10);
	var inst = list.choose;
inst.do{
  Synth(\blip, [\freq, rrand(120.0, 1220.0)]);
};
	("- number of Synths: " ++ inst)
	//more code here...
};

x.value;

//Create the group:
~blipSynths = Group.new();

//Now assign all Synth blip to the group you just opened.
x = {
	var list = (1..10);
	var inst = list.choose;
inst.do{
  Synth(\blip, [\freq, rrand(120.0, 1220.0)], ~blipSynths);
};
	("- number of Synths: " ++ inst)
	//more code here...
};

//See is all is working properly.
x.value

//clear stuff.
~blipSynths.free;

//check everything has gone
~blipSynths.query;

//Pass addAction to Groups:
~blipSynths = Group.new(s, addAction: 'addToHead');
//OR:
~fxSynths = Group(s, 'addToTail');


