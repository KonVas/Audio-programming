# Events
Event in SC is a set of instructions, normally coming in the format of
key-value, enclosed in parenthesis, for example  

````js
e = (freq: 100, dur: 0.2);
````
Once you have create this you can access it by its key.

````js
e[\freq];
e[\dur]
````

using this way we can create any pairs to pass them as argument setters
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
What is a Pbind, a Pbind will allow us to wrap all of the above, that is
the event, and also will be able to trigger it every given time, that is
`delta` time, in Pbind it is denoted with the `dur` parameter. Not to be
confused with the `dur` parameter of a given envelope inside a Sdef.
Pbind is using a slightly different syntax to pass the values and map it
to the arguments. See the example as follows.

````js
Pbind(
  \dur, 0.25,
  \type, note,
  \instrument, \blip,
  \degree, 1,
  //more params from the Sdef, if available.
).play; /*add trace before .play to see the event.*/
````

Bear in mind that the above has lots of default values, for example, you
could add `\octave` which now is not visible until you change it. Octave
also, will probably work when a degree key is used to control the `freq`
argument of the SynthDef. Due to the huge amount of this topic we will
stick on the basics but make sure you check more on the help files,
including conversion of the keys and parameters, check Reader section on
this file.

## Patterns
Patterns in SC is an extremely fun way to control Sdefs. It allows to
create phrases and sequences of sounds when mapped to parameters of our
Sdefs. Before jumping onto this, let's take a look how a Pattern is
creating the values.

````js
~pat1 = Pseq([1, 2, 3, 4], inf).asStream;
~pat2 = Prand([1, 2, 3, 4], inf).asStream;

~pat1.next;
~pat2.next;
````

Evaluating the last two lines we are able to generate a series of
numbers which are included inside the patterns. The numbers can be
either floats or integers. These numbers are given as an array and
through this list of numbers the pattern will be able to generate the
values.

Adding this inside a Pbind we don't need anymore to use the `.next`
message. Since the Pbind will recur iteratively within its pattern
configuration on a provided time, that is `dur` value, this is the
interval between the next value of the patterns.

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
Patterns when used inside event wrapper as a Pbind is a very powerful
and elegant way to control our SynthDefs. They can be used as an
interface to interact with the running synths and create complicated
textures and improvisations but also sonic gestures and phrases for
generating material of a fixed media piece. Live coding makes heavy use
of patterns paradigm and provides the means to interact during
improvisation with SC. It definitely worths of spending some time to
learn about more patterns and their implementation in SC.  



## Reader
[Pbind](http://doc.sccode.org/Tutorials/A-Practical-Guide/PG_03_What_Is_Pbind.html)
[Patterns](http://doc.sccode.org/Tutorials/A-Practical-Guide/PG_01_Introduction.html)
[Streams](http://doc.sccode.org/Overviews/Streams.html)
