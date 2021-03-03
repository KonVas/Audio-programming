
# Table of Contents

1.  [Audio Programming SC Workshop](#org393a866):export:
    1.  [Buffers in SC](#orgc8b063d)
        1.  [Buffer Class in SC](#org79e5851)
    2.  [Dictionary declaration/manipulation](#orgcc26091)
    3.  [Pattern, sequences and data sharing](#org1c4810c)
        1.  [Pspawner, Pkey and other pattern data sharing options in SC](#orga1c46f2)
        2.  [Server controlling with Patterns](#org56891b6)


<a id="org393a866"></a>

# Audio Programming SC Workshop     :export:


<a id="orgc8b063d"></a>

## DONE Buffers in SC


<a id="org79e5851"></a>

### Buffer Class in SC

How to read a buffer using native buffer classes in SC. What is a buffer.
A bufffer is a temporary memory in SC. And we can access it from its index on creation.

    b = BUffer.read()
    
    ~bufs = SoundFile.collectIntoBuffers(p +/+ "/sounds/*", s);
    //-> -> [ Buffer(1, 1003, 2, 44100, /Applications/SuperCollider.app/Contents/Resources/sounds/SinedPink.aiff),
    // Buffer(2, 107520, 1, 44100, /Applications/SuperCollider.app/Contents/Resources/sounds/a11wlk01-44_1.aiff),
    // Buffer(3, 188893, 1, 44100, /Applications/SuperCollider.app/Contents/Resources/sounds/a11wlk01.wav)
    //]
    ~bufs[1] //access the buffers within the array of the ~bufs.
    
    //play the buffers
    (
    SynthDef(\playbuf, {|out=0, rate=1, buffer=0|
    	var sig;
    	sig = PlayBuf.ar(1, buffer, rate * BufRateScale.ir(buffer), loop:1);
    	Out.ar(out, sig);                   //this will loop every sounds you load
    }).play(s, [\buffer, ~bufs[2]]);
    )


<a id="orgcc26091"></a>

## DONE Dictionary declaration/manipulation

Dictionaries are a convenience to store some information inside our programs.

    d = Dictionary.new()
    //event style dictionaries
    d = ()
    //add something inside the dictionaries:
    d.add(\msgA -> rrand(0.1, 1.0))
    d[\msgA] // -> current value of the random operator
    x = { LFNoise1.ar(freq: d[\msgA]) };
    //the msgA of the dictionary now is mapped inside my x function.
    
    //More examples
    
    d = Dictionary.new();
    d.add(\noise -> { LFNoise1.ar(80) });
    d.add(\noNoise -> { SinOsc.ar(80) });
    d.add(\update -> 1.0);
    d[\update];
    d[\humidity];
    d[\temperature];
    
    (
    fork{
    	var val;
    	loop{
    		0.5.wait;
    		val = rrand(0.1, 1.0);
    		d[\update] = val
    	}
    }
    )
    
    ///OSC Messages incoming values updating my Dictionary elements
    OSCdef(\inputMsgs, {|...args|
    	var msgFloat = args[0][1];
    	msgFloat.postln;
    	d = (update: msgFloat);
    }, '/test')
    
    n = NetAddr("localhost", 57120);
    n.sendMsg('/test', rrand(0.1, 1.0));


<a id="org1c4810c"></a>

## HOLD Pattern, sequences and data sharing


<a id="orga1c46f2"></a>

### Pspawner, Pkey and other pattern data sharing options in SC

Pspawner:
<https://depts.washington.edu/dxscdoc/Help/Tutorials/A-Practical-Guide/PG_06d_Parallel_Patterns.html>

    (
    p = Pspawner({|sp|
    	1.do {
    		var dur = 0.1;
    		sp.par( Pbind(
    			\dur, dur*2,
    			\degree, Pseq((1..10), inf),
    			\octave, Pkey(\degree).linlin(1, 10, 2, 8),
    			\amp, 0.5
    		));
    
    		sp.wait(2);
    
    		sp.par( Pbind(
    			\dur, dur,
    			\degree, Prand((1..10), inf),
    			\octave, 6,
    			\amp, 0.75
    		));
    
    		sp.wait(6);
    
    		sp.par( Pbind(
    			\dur, dur*3,
    			\degree, Pseq((1..10).reverse, inf),
    			\octave, 6,
    			\amp, 0.9,
    			\pan, Pwhite(-1, 1)
    		).trace);
    	}
    });
    )
    
    //start the sequence
    p.play;
    // stop it...
    p.stop;


<a id="org56891b6"></a>

### Server controlling with Patterns

Control Busses in Patterns is also a good practice when controlling SynthDefs with effects.
<http://doc.sccode.org/Tutorials/A-Practical-Guide/PG_06f_Server_Control.html>

