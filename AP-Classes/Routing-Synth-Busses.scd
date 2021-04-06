//1. Inputs and Output in SuperCollider:
//2. Groupings of SynthDefs:
s.boot
s.meter;

//Server input preferences;
(
o = Server.default.options;
o.numInputBusChannels = 1;
o.numOutputBusChannels = 36;
o.outDevice = "ZoomAudioD";
s.reboot;
)

~bus = Bus.audio(s, 1);

//Add reverb in my input from the onboard microphone.
(
SynthDef(\rvrb, {|out = 0, in|
	var input = SoundIn.ar(in); //input of my microphone;
	var fx = FreeVerb.ar(input);
	Out.ar(out, fx.dup * 0.5);
}).play(s, [\out, ~bus], addAction:\addToHead);

SynthDef(\delay, {
	arg out = 0, in, delaytime = 0.8;
	var input = In.ar(in, 1);
	var signal = DelayL.ar(input, 0.1, delaytime, 0.5);
	Out.ar(out, signal.dup * 0.5);
}).play(s, [\in, ~bus], addAction: \addToTail);

SynthDef(\rsntr, {
	arg out = 0, in, resFreq = 220;
	var input = In.ar(in, 1);
	var signal = Resonz.ar(input, resFreq);
	Out.ar(out, signal.dup * 0.5);
}).play(s, [\in, ~bus], addAction: \addToTail);

SynthDef(\pitchShifter, {
	arg out = 0, in, pitch = 1;
	var input = In.ar(in, 1);
	var signal = {Splay.ar(PitchShift.ar(input, 0.2, pitch*Rand(0.1, 4.0), Rand(0.1, 2.0), Rand(0.1, 2.0)))}!8;
	Out.ar(out, signal.dup * 0.5);
}).play(s, [\in, ~bus], addAction: \addToTail);
)


//Assignment Week 06

/*
Create different SynthDefs and assign them to separate Groups, use Busses f
or routing them to each other and allocate those on the proper actions,
e.g., addToHead, or addToTail.
*/