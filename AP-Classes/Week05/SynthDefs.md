# Ugen and sound
Last week we looked on how to create simple sound functions and how to
control them using other functions as input. This week we will focus on
Ugens and how are they used inside synth definitions. The idea of a Ugen
is that is used to create audio or to manipulate a signal. However,
Ugens won't create any sound on their own. They need to be enclosed in a
SynthDef; the `{}.play` is actually a node, that is a synth, which is
created automatically in order to hear the output of the Ugens. Creating
a node in SC will use some default parameters to create the sound
including the first bus of the audio output of your audio interface,
thus you won't be be able to change this unless you using a SynthDef.

A SynthDef is a Ugen graph that tells to the scserver  how to
create the sound. Remember, the language is totally agnostic about
sound, it is the scserver that will create the signal flow and through
the language we will be able to interact and send instructions for audio
manipulation dynamically. Let's take a look on a SynthDef.

We already thrown some new term such SynthDefs, but on the bigger picture a SynthDef is a Synthesizer definition (without dragging you to the technical side of a SynthDef). In order to start designing our first synthesizers maybe a view on the basics and most common parameters of a synthesizer is worth it. Take a look on this [tutorial](https://learningsynths.ableton.com/) to fresh up your mind about typical parameters and mechanics of synthesizers.

````js
SynthDef(\test1, {
	Out.ar(0,
		SinOsc.ar([440, 446, 448.5, 882], 0, 0.1)
	)
}).add;
````
Run this line below to query all nodes currently active, and look the
response on the post window of SC.

````js
s.queryAllNodes;
````
Here you will see some words that might not make sense at this point.
Let's go back on the first way to create sound and compare using the
last command.

````js
{SinOsc.ar([440, 446, 448.5, 882], 0, 0.1)}.play;
//now run this below
s.queryAllNodes;
````
You are most likely seeing something like this:

````js
-> Synth('temp__2' : 1005)
-> localhost
NODE TREE Group 0
   1 group
      1005 temp__2
````

Is it something you might see problematic here, and if yes can you track
the problem and provide a better solution. To help see this example
below.

````js
SynthDef(\test1, {
	Out.ar(0,
		SinOsc.ar([440, 446, 448.5, 882], 0, 0.1)
	)
}).add;

Synth(\test1);

s.queryAllNodes;
````
The post window will probably now return something like this below:

````js
-> Synth('test1' : 1006)
-> localhost
NODE TREE Group 0
   1 group
      1006 test1
````

So we are now entering on the world of SynthDefs. SynthDefs require a litle bit more code labour but for a good reason. That is, a better definition of audio manipulation and control over the sound generation in SC. Bear in mind, that once you press command period you are basically reseting all Ugen graphs.

SynthDefs can also be grouped for organization convenience, solving something in SC is called order of execution. For example, if you are using a SynthDef that is used as an input to another inside your program, then the input node must be created first.

A `SynthDef` provides the interface to create sound synthesis
modules in SuperCollider. It also offers a set of interaction
capabilities to alter the musical parameters of the sound synthesis on a
higher level. To create it we type ```SynthDef```, it has to have a
unique name, that is a `symbol` and is denoted by single quotes or a slash before. Once is created we need to load it on the Server using the
message '.add'. For this make sure you have already boot the Server.

````js
(
  SynthDef(\mySynth, {|out = 0, amp = 0.6| var sig; sig =
SinOsc.ar([120.0, 121.0]); // a two output sine oscillator synth. sig =
sig / 2; Out.ar(out, sig \* amp); }).add; )

Synth(\mySynth);
````

Our `SynthDef` is a (two output) sine oscillator synthesizer with
fixed values (leftChannel:120.0, rightChannel:121.0), and it takes
advantage of *multichannel expansion* in SC which is implemented using
an array. This is one of the strenghts of SC as multiple ugens can be
used to create complex sound engines. To hear the `SynthDef` we need
to use another class names Synth, which is used to create an instance of
the `SynthDef` which is loaded on the Server. You can also pass
default values to a `SynthDef` like 'amp'. Sometimes we need to do
more manipulation on the signal i.e., add a filter in the signal chain
but is better to keep them simple and create other ones for
extra manipulation.

## Envelope in SynthDefs
To apply ADSR properties to a `SynthDef` we use an Env
specification. To be able to re-trigger the envelope, as we saw formerly, we use an EnvGen. Run this line below and see how the envelope of the synthesizer will look like.

````js
Env.new([0, 1, 0.9, 0], [0.1, 0.5, 1],[-5, 0, -5]).plot;
````

Envelope on our previous `SynthDef`
````js
(
SynthDef(\myEnvSynth, {|out = 0, amp = 0.3|
  var sig, env;
  env = Env.new([0, 1, 0.9, 0], [0.1, 0.5, 1],[-5, 0, -5]);
  sig = SinOsc.ar([120.0, 121.0]);
  sig = sig * EnvGen.kr(env, doneAction: 2);
    Out.ar(out, sig * amp);
  }).add;
)

Synth(\myEnvSynth);
)
````
Assuming the previous `SynthDef` is loaded we can assign the Synth
class to a variable like this below:

````js
x = Synth(\myEnvSynth); */ x now is our Synth and can be used anywhere
in our program as it is a global variable. x.set(&amp;, 0.1); /* the set
message requires the name of the parameter and a value.*/
````

## Discussion

A `SynthDef` is the sound engine of our program or instrument we are
building. It provides a set of interaction messages, such as `.set` `.free` and it has to be started through another class named `Synth`
using the name of the `SynthDef`. Make sure to load `SynthDefs`
using a method called `.add;`

## Task
Create various synthdefs and assign them to be played by routines and make them use random values in two different ways we implemented previously (Exprand vs. rrand() ).

## Task Mid term project
Please make a small 'komposition' using various synthdefs as instruments. As inspiration you can listen to Stockhausens Studie II, using sinusoidal transients with various durations and transforming their partials throughout the piece. Of course, on the timbre side, you may use more than sinusoidal sounds and take advantage on the wealth of sound generators of SC. This is due before the first class after the mid term break.
