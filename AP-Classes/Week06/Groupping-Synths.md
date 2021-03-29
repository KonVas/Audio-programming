  # Order of Execution

  ## Synth Grouping
  Last week we took a look on how to implement `SynthDefs` and how to create
  instances to be able to hear the `SynthDefs`. 
  Today, before we dive into more complicated concepts such the title of this document and look how
  to control with Events, I want to first clear the way with an
  interesting concept in SC, _the order of execution_.

  Order of execution as it suggests, is how we organize the `SynthDefs` in our signal chain.
  As in real life, you cannot have an FX processor following the source. Therefore, we shall make the provisions to take care the order of execution. For example the source is used as the input signal for another synth, as seen in the example as follows:

  ```js
  (
SynthDef(\blip, {|out = 0, rel = 0.8, freq = 120.0, amp = 0.5|
    var sig, env;
    env = EnvGen.kr( Env.perc(0.03, rel, curve:2), doneAction:2);
	sig = LFSaw.ar(freq, Rand(1.0, 2.0)*pi, 0.3);
    sig = sig * 0.5 * amp;
    Out.ar(out, sig / 20)
}).add;
)

(
SynthDef(\ring, {|out = 0, freq = 120.0, amp = 0.8|
    var sig, in;
	in = In.ar(0, 1);
    sig = Ringz.ar(in, {freq * Rand(0.98, 1.02) }!20, 0.3);
    sig = sig * 0.5 * amp;
	DetectSilence.ar(sig, doneAction:2);
    Out.ar(1, Splay.ar(sig) / 20)
}).add;
)

(
//force the synth to be created at the top of the chain:
Synth(\blip, args: [\freq, 220], target: nil, addAction: 'addToHead');

/*similarly we are forcing the fx synth to be created after source:*/
Synth(\ring, args: [\freq, 1220], target: nil, addAction: 'addToTail');
)
```

To hear this of-course we need to either play it, or create a node from the instance named `blip`. However, if we want to route this synth in a chain of signal we must make sure that it will follow the right order, that is `blip -> fx -> outputBus -> computer out`. To assure this order we shall use some additional preferences as to where the nodes will be assigned upon their creation. For example, _head_ and _tail_ allocations in the order process.

SynthDef Routing Using 'AddAction'
To tackle the issue of Order of Execution in SC, our Synths are organized in groups, that is each synth you create can belong to a specific group. Lets examine this concept further. Create a SynthDef and assign it to a group, using Group class:

  ```js
  SynthDef(\blip, {|out = 0, rel = 0.25, freq = 120.0, amp = 0.6|
      var sig, env;
      env = EnvGen.kr( Env.perc(0.03, rel), doneAction:2) * amp;
      sig = SinOsc.ar(6, 0, 0.3);
      sig = Ringz.ar(sig, {freq * Rand(0.98, 1.02) } ! 20, 0.3);
      sig = sig * 0.5;
      Out.ar(out, Splay.ar(sig) / 20)
  }).add;
```

  Then to create an instance of this we will use something like this below
  `Synth(\blip);` easy, but providing we need to create a bunch of these
  at the same time to achieve some kind of polyphonic spectrum.
  
  ```js
  x = {
    var inst = [(1..10)].choose;
  inst.do{
    Synth(\blip, [\freq, rrand(120.0, 1220.0)]);
  };
  }
  ```

  This will create a random amount of identical instances of the `blip` SynthDef each
  one having a random `freq` value generated with the `rrand()`.

  Now, since we are making music not ring tones we will probably want to
  be able to control something of these sounding `SynthDefs`. But is it
  possible to control all of them at once?

  We will group them and then using `.set` we will be able to manipulate all of them at once
  without worrying about how to pass the arguments to each one separately,
  see the Group help-file [here](http://doc.sccode.org/Classes/Group.html).

  Let's see how to organize the above into a group style. First we need to
  create the group and give a name to be able to assign and pass arguments
  later.

  ````js
  ~blipSynths = Group.new(s);
  ````
  Now use the global variable name you gave to the group inside the Synth
  node, so all instances will be linked on this group.

  ````js
  x = {
    var inst = [(1..10)].choose;
  inst.do{
    Synth(\blip, [\freq, rrand(120.0, 1220.0)], ~blipSynths);
  };
  }
  ````

  // kill it including everything is linked to it.
  `~blipSynths.free;`

  // see, if everything is cleared.
  `~blipSynths.query;`

  Once you get rid of the group and its children try to run again the function and
  see what is going on. You probably got something like this in the post
  window.

  >FAILURE IN SERVER /s_new Group 1371 not found
  FAILURE IN SERVER /s_new Group 1371 not found
  FAILURE IN SERVER /s_new Group 1371 not found
  FAILURE IN SERVER /s_new Group 1371 not found
  FAILURE IN SERVER /s_new Group 1371 not found
  FAILURE IN SERVER /s_new Group 1371 not found

  _There is an explanation for that, can you think and reflect from what you have learned so far?_

  Now that we saw how to organize a bunch of Synths created on the fly
  (not even knowing how many beforehand), we can make sure we can pass to
  all of the some argument values. See this below:

  ````js
  ~blipSynths.set(\amp, 0.1);
  ````

  For the love of suffering Grouping allows us to kill and pass everything
  at once, but also helps us to override the order of execution I
  mentioned that earlier. Gladly, Group offers the option to decide this
  when we create it. 
  
  ## Groups handling order of execution
  Groups can also make use of the `addAction` parameter. With this way we make sure that all synths created at this group will be assigned to the order we want, e.g., head or tail.
  
```js 
  ~blipSynths = Group.new(s, 'addToHead' );
  //And
  ~fxSynths = Group(s, 'addToTail');
```