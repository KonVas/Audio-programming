/*
The NetAddress below will send the OSC message to Prcng to the denoted port.
*/
(
	n = NetAddr(
	"127.0.0.1", //localhost ip address
	47120 //the port of Prcng
	 );
);
	/* the OSCdef receiver below will receive the message from Prcng and will do whatever is inside its function, remember a function is denoted using curly bruckets {} */

	OSCdef(\rcvPrLftrgt, {|msg| //the OSC function
		msg[1].postln; /* here we choose the second OSC message from the packet.*/
		Synth(\blip, [\freq, msg[1].midicps.max(200)]); /*midicps will convert from midi to frequency range*/
		n.sendMsg('/sc3p5', rrand(1, 12.0) ); //send back to Prcng.
		}, //OSC function ends here
		 '/ballLR' /*the first OSC message, has to be same with the Prcng is sending otherwise there won't be any communication*/
		 );

		(
	SynthDef(\blip, {|freq = 440, amp = 0.85, att = 0.01, rel = 0.06, ffreq = 1000 |
	    var sig, env, lfo;
	    sig = SinOsc.ar(freq, 0, amp);
	    env = EnvGen.ar(Env.perc(att, rel), doneAction:2);
	    lfo = SinOsc.kr(rel * ffreq);

	    Out.ar(0, Pan2.ar(RHPF.ar(sig*env, ffreq), SinOsc.kr(211*lfo)))
	}).add;
	);
