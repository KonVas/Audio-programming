# Ins and Outs in SuperCollider
So far we have seen how to manipulate sound and design basic ugenGraphs,
which act as recipes for sound synthesis on the server of SC. In this
tutorial we will focus on modifying inputs and outputs of our synthesis
nodes, by using classes such as `Input` and `Out`, what these do is
pretty self explanatory. Although you may draw from your experience of
analog systems, such as mixing consoles providing inputs outputs and
auxiliary outs, it might be a bit confusing in the beginning in the SC
ecosystem, especially if you come from other graphic audio platforms,
such as Pure Data, MaxMSP etc.  

When you start SC it will allocate automatically a set of in and out
busses, depending on your audio interface of the machine you are using.
Run this in SC to see what is available in your computer: `s.boot` once
you run this you will get some information about your audio interface
and its specs including sample rate and channel information. If you run
this and your server booted properly then you most likely looking on
something like this.
```
-> localhost
Booting server 'localhost' on address 127.0.0.1:57110.
Found 0 LADSPA plugins
Number of Devices: 2
   0 : "Built-in Microph"
   1 : "Built-in Output"

"Built-in Microph" Input Device
   Streams: 1
      0  channels 2

"Built-in Output" Output Device
   Streams: 1
      0  channels 2

SC_AudioDriver: sample rate = 44100.000000, driver's block size = 512
SuperCollider 3 server ready.
Requested notification messages from server 'localhost'
localhost: server process's maxLogins (1) matches with my options.
localhost: keeping clientID (0) as confirmed by server process.
Shared memory server interface initialized
```

The first line tells you which server you are using, see SC Server
Tutorial for internal vs. localhost servers in SC. The next lines are
telling you some information about the address of the server, since we
are using by default the localhost server we are getting the "127.0.0.1"
and 57110 address and port respectively. Remembering the first tutorials
of SC here, SC is a two part application that runs at the same time in
your computer. That is, the `scsynth` and the `sclang`, can you guess
what these two have in common and why they are different? How do they
communicate...

Now that we took some technical stuff in the ecosystem of SC, let's take
a look more generic issues in the previous post window snippet. The rest
of the notification in question provides some details about your audio
interface that SC is using. That is, the input is reading and the out,
including the number of the available channels that SC will stream out
the sound. Finally, it let's you know what sample rate you are on, the
rest of the info can be safely ignored now.

Run this, `s.meter`, you may see some audio signal bouncing on your
server meter. It also shows you how many ins and outs you have. Assuming
you are playing on a stereo set up you are looking on two outputs. This
can be changed though in case you have a multichannel piece, and audio
interface accordingly. Run this pieces of code and follow the comments
within the snippet.
```
// check your Server's attributes
o = ServerOptions.new();
o.numInputBusChannels; //enquire input bus channels
o.numOutputBusChannels; //check the output channels

o.numInputBusChannels_(2); //change the number of inputs
o.numOutputBusChannels_(4); //same for the outputs.

s.reboot; //to take effect you need to reboot the server.
```

It is important to reboot the server everytime you change something,
otherwise it won't work. Let's now make a new meter window and see how
many ins and outs we have available `s.meter` most likely you looking on
two ins again but more outputs.  

On the same way, you may select a different audio interface by
hardcoding its name using a string format, e.g., `o.device ="MOTU
Traveler";`

Now that we know how to manipulate the servers in and outs let's take it
for a stroll using some simple signal routing. First make a function
using a simple uGen to create some signal that we will be able to
experiment with.
```
play{ SinOsc.ar({ExpRand(120.0, 1220.0)}!4, mul:0.5) };
```

Try to change the number of `do` function. Can guess which one is this?
Change it to use less or more signal outs, by the way this is called
`multichannel expansion`.  

The idea is that you create couple of SinOsc without adding anything,
but iterating a SinOsc class, and asking to make 4 of them, in turn this
will expand on the outputs of SC respectively. Pretty simple...

Now let's see how we can create synthdefs that use the same idea. Let's
copy the code we just used to experiment a little bit more.

```
SynthDef(\multChan, {
  var sig = SinOsc.ar(SinOsc.ar({ExpRand(120.0, 1220.0)}!4, mul:0.5));
  Out.ar(0, sig * Impulse.kr(1));
  }).add;

  //test is working
  Synth(\multChan);
  ```
Now we know how to make it in a SynthDef way, but let's take a look a little bit deeper how this is actually working by changing some arguments in the sdef.

...more to come...
