# Patterns in SC
SC has great support for patterns and streams. A stream is a stream of
something. You can ask streams for their next value with the next
method. All objects are trivially a stream of themselves

>Do this couple of times.

````js
1.next;
````
Patterns are a template which can be used to create any number of more
interesting streams. They have names beginning with ````P````.

> An infinite stream of a random choice of 1, 2, or 3.
````js
a = Prand([1, 2, 3], inf).asStream;
a.next; // do this many times
````

Event patterns make streams of events. Events are parameter names and
parameters (which can themselves be streams), and some info on what to
do with those parameters. The default event type is called a 'note' and
plays a synth.

> An endless string of middle Cs. Note that this assumes a lot of
defaults. 1 second, default synthdef, middle C. Pbind().play;
````js
Pbind().play;
````
> More interestingly, we can use our own synthdefs, and/or specify
interesting parameter streams.

````js
(
Pbind(
	\degree, Pseq([Pseq([2, 1, 0], 2), Pseq([4, 3, 3, 2], 2)], 1), // |: Mi Re Do :||: So Fafa Mi :|
	\dur, Pseq([Pfin(6, 0.5), Pseq([0.5, 0.375, 0.125, 0.5], 2)]) // 0.5 secs 6 times, then |: 0.5 0.375 0.125 0.5 :|
).play;
)
````

> Notice that the above makes a bunch of assumptions. There's a default
sound (actually a SynthDef called 'default'), degree refers to a major
scale, etc.

````js
(
// a SynthDef
SynthDef(\blippy, { | out = 0, freq = 440, amp = 0.1, nharms = 10, pan = 0, gate = 1 |
    var audio = Blip.ar(freq, nharms, amp);
    var env = Linen.kr(gate, doneAction: 2);
    OffsetOut.ar(out, Pan2.ar(audio, pan, env) );
}).add;
)

(
Pbind(
	\instrument, \blippy,
	\freq, Prand([1, 1.2, 2, 2.5, 3, 4], inf) * 200, // use freq instead of degree
	\nharms, Pseq([4, 10, 40], inf),
	\dur, 0.15
).play;
)
````

We can also record them and render an audio file on the hard disk.
> Just define, don't make a stream
````js
p = Pbind(\instrument, \blippy, \freq, Prand([1, 1.2, 2, 2.5, 3, 4], inf) * Pstutter(6, Pseq([100, 200, 300])), \nharms, Pseq([4, 10, 40], inf), \dur, 0.1);

p.play; // test

p.record("~/Desktop/patternTest.aiff".standardizePath, fadeTime:0.5); //fadeTime is how long to record after last event. Adjust to avoid click at end

// note to use Pattern:record, your SynthDef must have an 'out' argument

b = Buffer.read(s, "~/Desktop/patternTest.aiff".standardizePath); // read it in to check

b.plot

b.play
````
