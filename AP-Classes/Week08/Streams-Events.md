# Sequencing in SuperCollider:
One way to sequence values to SC as we have seen so far is to use something called a `Routine`. 

```js
(
	fork{
		loop{
			1.wait;
			("Hello" + "I will trigger something every 1 second").postln;
		}
	}
)
```

Using it we can create timed scheduling of certain messages assigned to our SynthDefs. In fixed media composition, this yields interesting results as usually we would like to create a sound that changes its characteristics over time, for example to increase/decrease the speed of its rhythm, and/or its morphological features. This way we can create any pairs to pass them as argument setters
to our SynthDefs, if you know the name of the SynthDef then you can do
something like this.

````js
SynthDef(\blip, {|out = 0, pan = 0.0, rel = 0.25, freq = 120.0, amp = 0.6|
	var sig, env;
	env = EnvGen.kr( Env.sine(rel), doneAction:2) * amp;
	sig = SinOsc.ar(6, 0, 0.3);
	sig = Ringz.ar(sig, {freq * Rand(0.98, 1.02) } ! 8, 0.3);
	sig = sig * 0.5;
	Out.ar(out, Pan2.ar(sig.sum, pan) / 8)
}).add;

// an event to control the Sdef.
e = (instrument: blip, freq: 100, dur:0.1);
````

## Pbind
Pbind is a event wrapper, and it responds to play, Pbind will create synth nodes, and it expects key-value pairs. It takes a `delta` time, in Pbind it is denoted with the `dur` parameter and that is, the time between yielding a new event.
Not to be confused with the `dur` parameter of a given envelope inside a Sdef.

Pbind is using a slightly different syntax to pass the values and map it
to the arguments. See the example as follows.

````js
Pbind(
  \dur, 0.25,
  \type, note,
  \instrument, \blip,
  \degree, 1,
//...any available params provided in the Sdef...
).play;
````

Keep in mind that the above has lots of default values, for example, you
could add `\octave` which now is not visible until you change it. Octave
also, will probably work when a degree key is used to control the `freq`
argument of the SynthDef. Due to the huge amount of this topic we will
stick on the basics but make sure you check more on the help files on the topics noted at the end of this tutorial.

## Patterns
Patterns in SC is an extremely fun way to control Sdefs. It allows to
create phrases and sequences of sounds, a method used par excellence in fixed media composition and acousmatic music.

Before jumping onto this, let's take a look how a Pattern is
creating the values, using streams:

````js
~pat1 = Pseq([1, 2, 3, 4], inf).asStream;
~pat2 = Prand([1, 2, 3, 4], inf).asStream;

~pat1.next;
~pat2.next;
````

Since Pseq object are responding to `.next` message when we evaluate the last two lines we are able to generate a series of
numbers which are included inside the patterns. The numbers can be
either floats or integers. These numbers are given as an array and
through this list of numbers the pattern will be able to generate the
values.

## Pbind
Pbind is used to generate events, and the default type event it will generate is the note event. When is played, it creates a node instance of a SynthDef on the Server. Adding patterns inside a Pbind we don't need anymore to use the `.next`
message.

```js
(
b = Pbind(
	\instrument, \blip,
	\dur, Pseq([0.1, 0.35, 0.6], inf) * 0.5,
	\amp, 0.7,
	\degree, Pseq(a.cpsmidi, inf) * Pfunc{ foo },
	\octave, Pbrown(1, 6.0, step: 1) / 2
).play;
)

b.stop;
```

Going back to Pbind and value assignment, you can also map a function as
the value of a parameter. See the example below:

````js
(
  ~note = 1;
p = Pbind(
	\instrument, \blip,
	\dur, 0.25,
	\degree, Pfunc({ ~note * rrand(1, 30) }),
	\rel, 0.2,
	\pan, Pfunc({ [-1, 1].choose }).asStream,
).trace.play(t);
)
````

## Discussion
Patterns are sequences of values and when used inside event wrapper as a Pbind can create streams of values to control our SynthDefs. They can be used as an interface to interact with the running synths and create complicated textures and improvisations but also sonic gestures and phrases for generating material of a fixed media piece. Live coding with SuperCollider makes heavy use of patterns paradigm and are as a means to interact with the sonic outcome in real time.



## Reader
[Event](https://doc.sccode.org/Classes/Event.html).
[Pbind]()
[Patterns A Practical Guide](https://doc.sccode.org/Browse.html#Streams-Patterns-Events%3EA-Practical-Guide).
