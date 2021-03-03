# Sound Synthesis in SuperCollider Week 7(?).

### Synthesis Techniques
- [X] Additive
- [X] Amplitude
- [X] Granular

## Introduction
Sound Synthesis is an interesting field for exploration on its own. From raw waveforms to audio sample manipulation and complex data crunching of the Fast Fourier Transformation[^1] (FFT) techniques, it consists of the main arsenal of the artist enabling the design of novel sounds focussing on timbre exploration and micro-structure manipulation. These sounds can be then ported to a DAW for further manipulation or used as is to compose a full scale composition. (For an overview of waveform theory see this [tutorial](https://pudding.cool/2018/02/waveforms/)).

At the same time, the systems that are designed to synthesize such sounds are also part of the compositional process, albeit they might appear as a mere techno/mechanical process of producing a synthesizer, as this is the end goal. 

However, with this tutorial I will argue that although these sound design modules are created, and binded to each other, are constructed on an offline basis in regard to the compositional process of a large piece they are an inherent part to the musical decisions and the impact to the overal composition and its final form.

But without any further ado let's take a stroll with the ins and outs of the custom designed sound synthesis modules and their mechanics.

### Additive Synthesis
```js
SynthDef(\additive_sines, {| freq = 1, out = 0, amp = 0.5 |
	var signal, numSins = 8;
	signal = Mix.fill(numSins, {
		SinOsc.ar(ExpRand(120, 1220.0)+freq, Rand(0.1, 1.0) * pi)
	});
	signal = {signal}!2; 
	signal = signal / numSins * amp;
	signal = LeakDC.ar(signal);
	ReplaceOut.ar(out, signal);
}).play
```
Some information about the details comprising this example: Mix.fill(..) will populate the synthesizer's oscillators based on the `numSins` variable. In this case, it will create an `n` number of sine tones with modulatable frequency  of each oscillator, with stereo output and normalization/gate arrangement. 

This example, although at first glance it might seem very simplified and expressed with a limited amount of lines it actually creates 8 oscillators, completely independent from each one using the power of iteration. Something that in other environments might be counterproductive as it will require to abstract each oscillator individually.

At the end of the synthesizer, there is a small detail that asks the immediate play, as opposed to what we have experienced so far using the `.add` method, which stashes our SynthDef on the server available to be played later using a `Synth(..)` node instantiation. More about this on our previous class on `SynthDefs` and `Synths`

Next, we are seeing another variant of the previous example using a special Ugen designed to implement something similar named `Klang`. Using it we can assign our parameters in an easier way and at the same time the Ugen will make some _housekeeping_ for us.

### Additive synthesizer with Klang:
```js
SynthDef(\additive_klang, {| freq = 1, out = 0, amp = 0.5 |
	var signal, numOsc = 8, modulo;
	modulo = LFNoise1.kr(0.1).range(0.1, 1.0);
	signal = Klang.ar(`[ Array.rand(numOsc, 120, 1220.0), nil, nil ], 1, 0 );
	signal = {signal}!2;
	signal = signal / numOsc * amp * modulo;
	signal = LeakDC.ar(signal);
	ReplaceOut.ar(out, Splay.ar(signal))
}).play
```
However, there is something that begs for tweaking when looking in these examples. The number of the oscillators are fixed upon instantiation of the module. Next we take a look on how to create a synthesizer which its oscillators are modulatable while running.
```js
SynthDef(\additive_expand, {| freq = 120, out = 0, gate = 1, amp = 0.5 |
	var signal, pan, modulo;
	modulo = LFNoise1.kr(1, 0.5, 0.5);
	pan = LFNoise1.kr(1).range(-1, 1);
	signal = SinOsc.ar(freq, Rand(0.1, 1.0) * pi, modulo);
	signal = {signal}!2;
	signal = signal * EnvGen.kr(Env.sine(4), gate, 0.02, doneAction: Done.freeSelf) * amp;
	signal = LeakDC.ar(signal);
	Out.ar(out, Splay.ar(signal, center:pan))
}).add
```
With a loop we will be able to change the number of oscillators while at run:

```js
fork{
	loop{
		n = rrand(4, 12);
		n.do{
			Synth(\additive_expand, [\freq, exprand(120, 1220.0), \amp, n / 1.0]);
			0.75.wait;
			("Synths:" + n).postln
		};
	}
}
```

## Amplitude Modulation Synthesis in SuperCollider
```js
(
SynthDef(\ampMod, {| freq = 220, freqMod = 440, out = 0, amp = 0.5|
	var signal;
	signal = SinOsc.ar(freq) * SinOsc.ar(freqMod * 2).abs;
	signal = {signal}!2;
	signal = signal*amp;
	signal = LeakDC.ar(signal);
	Out.ar(out, signal)
}).play
)
```
## Granular Synthesis in SuperCollider:
Granular synthesis provides the means for unlimited sound manipulation and interesting timbre exploration. It can be used as a manipulation system for sonic material in studio or as an integrated interactive environment for live improvisation[^2] providing interesting artifacts and endless posibilities for real time improvisation with sound based compositions. 

### 1. Language side granular synthesis:
```js
(
SynthDef(\grains, {| freq = 220, freqMod = 440, out = 0, gate = 1, grainLength = 0.075, amp = 0.5|
	var signal, env;
	env = EnvGen.kr(Env.perc(0.02, grainLength, amp), gate, doneAction:Done.freeSelf);
	signal = SinOsc.ar(freq) * SinOsc.ar(freqMod * 2).abs;
	signal = {signal}!2;
	signal = signal*env*amp;
	signal = LeakDC.ar(signal);
	Out.ar(out, signal)
}).add
)

```
### Run a loop to create grains:
```js
fork{
	loop{
		0.06.wait;
		Synth(\grains, [\freq, 80, \freqMod, 100.rand(10)])
	}
}
```

Discuss the level of accuracy, grain level vs. ready made class Ugens for granular synthesis.

### 2. Using audio buffers for granular synthesis:

Create a buffer (temporary memory) in SC to manipulate:
A Buffer object is a client-side abstraction for a server-side buffer. It takes a path argument to audio-sample folder on your machine.
```js
(
//load an audio file using a Buffer class:
var path = /*Platform.resourceDir +/+*/ "/System/Library/Sounds/Blow.aiff";
b = Buffer.read(path:path); //takes pathname as argument.
)

(
SynthDef(\play_buf_grains, {
	| out = 0, buffer = 0, rate = 1, gate = 1, speed = 1, bufPos = 0, grainLength = 0.1, amp = 0.5 |
	var signal, env, pan, trigger, bufDur;
	bufDur = BufDur.kr(buffer);
	trigger = Impulse.kr(speed / bufDur);
	pan = LFNoise1.kr(1).range(-1, 1);
	env = EnvGen.kr(Env.perc(0.01, grainLength, amp), gate, doneAction:Done.freeSelf);
	signal = PlayBuf.ar(
		numChannels: buffer.numChannels,
		bufnum: buffer,
		rate: BufRateScale.ir(buffer) * rate,
		trigger: trigger / grainLength,
		startPos: bufPos * BufFrames.ir(buffer),
		loop: 1);
	signal = {signal}!2 * env;
	Out.ar(out, Pan2.ar(signal, pan, amp));
}).add;
)
```
```js
(
fork{
	loop{
		0.05.wait;
		Synth(\play_buf_grains, [
			\buf, b,
			\rate, rrand(0.1, 2.0),
			\bufPos, rrand(0.1, 1.0),
			\grainLength, rrand(0.1, 0.5),
		])
	}
}
)
```
### Using TGrain
```js 
(
SynthDef(\grain_buf_ugen, {
	| out = 0, buffer = 0, rate = 1, gate = 1, speed = 1, bufPos = 0, grainLength = 0.1, amp = 0.8 |
	var signal, trigger, env, pan, bufDur;
	bufDur = BufDur.kr(buffer);
	trigger = Impulse.kr(speed / bufDur);
	pan = WhiteNoise.kr(0.6);
	signal = TGrains.ar(
		numChannels: buffer.numChannels,
		trigger: trigger,
		bufnum: buffer,
		rate: rate,
		centerPos: bufPos / bufDur,
		dur: bufDur,
		pan: pan);
	Out.ar(out, signal.dup * amp);
}).add;
)
```
Then run this below to start it, and modulate the grains parameters with the loop:
```js
(
~grainSynth = Synth(\grain_buf_ugen, [\buffer, b]); //start the synth.
//manipulate the grain parameters with a loop:
fork{
	loop{
		~grainSynth.set(\rate, rrand(1, 4), \bufPos, rrand(0.1, 1), \bufDur, rrand(0.1, 0.5));
		0.25.wait;
	}
}
)
```
## Resources
[^1]: The Fast Fourier Transformation: https://www.dspguide.com/ch12.htm

[^2]: Greap: Using a Leap Motion to control an interactive granular synthesizer: http://porteakademik.itu.edu.tr/docs/librariesprovider181/Yayın-Arşivi/17.sayı/porte-akademik-17-kapak.pdf [page:64].

