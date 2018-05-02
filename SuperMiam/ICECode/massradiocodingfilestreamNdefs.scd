

// thanks to Dan Stowell!


// ****You should be using a sampleRate of 44100



// 1. Listen for frames (lets you recover)
(
~frame = nil;


OSCdef(\mrcFrames, {|msg, time| ~lastTime = time; ~frame = msg[1]; }, '/frame');


// if the starting computer crashes, all bets are off. :-)
)



// 2. Setup File
(


// Get up a file for playback


~fchans = 2; // set this to the correct number of channels for the file
~cueFrame = if(~frame.isNil, 0, {~frame + (r.myServer.sampleRate * (~lastTime - Main.elapsedTime))});
b = Buffer.cueSoundFile(s, "manco.wav".resolveRelative, ~cueFrame, ~fchans);


Ndef(\source).play(0, 2);
NdefMixer(s);



~startFunc = {
	Ndef(\source, {
		var out;
		out = VDiskIn.ar(~fchans, b, 1, 0);
		if(~fchans == 1, { out = out ! 2 });
		out.reverse
	});
};


// this will start the audio


OSCdef(\mrcStart, {
	~startFunc.value;
}, '/startMRC');


// automatically restart if we're receiving frames
if(~frame.notNil, ~startFunc);
)




// 3. Wait for start. You can cue up some  Ndefs if you want, but note that the initial presentation should be unprocessed, so don't turn them up



// example code

Ndef(\waveloss, {
	WaveLoss.ar(Ndef(\source).ar, \drop.kr(1), \outof.kr(1), 2 ).dup.sum
})


Ndef(\gate, { Compander.ar(Ndef(\source).ar, Ndef(\source).ar,
	thresh: \thresh.kr(0.1),
	slopeBelow: 10,
	slopeAbove: 1,
	clampTime: \clamp.kr(0.05),
	relaxTime: \relax.kr(0.05)
);   });

Ndef(\magMul, { |rate = 0.125, shift = 4|
	var in, buf, pb;
	buf = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav"
);
	pb = PlayBuf.ar(1, buf, BufRateScale.kr(buf) * rate, loop: 1);
	pb = PitchShift.ar(pb, 0.2, shift);
	in = FFT({LocalBuf(512)} ! 2, Ndef(\source).ar);
	pb = FFT(LocalBuf(512), pb);
	pb = PV_MagMul(in, pb);
	IFFT(pb) * 0.25
});

Ndef(\pshiftDisp, { PitchShift.ar(Ndef(\source).ar, 0.8, pitchRatio: \pitch.kr(2), pitchDispersion: {0.03.rand2} ! 14, timeDispersion: {LFNoise2.kr(rrand(1.0, 2.0)).range(0,0.8)} ! 14).clump(2).sum * 0.5})


Ndef(\allpass, { z = Ndef(\source).ar; 10.do({ z = AllpassC.ar(z, 0.1, 0.1.rand)}); z})

Ndef(\pulseMul, { Ndef(\source).ar * LFPulse.kr(\rate.kr(1), width: \width.kr(0.5)).range(0, 1)   });

Ndef(\mod, { Ndef(\source).ar * SinOsc.ar(SinOsc.kr(0.1).range(3, 500))})

Ndef(\verb, { FreeVerb.ar(Ndef(\source).ar, 1, \room.kr(0.5)) });

Ndef(\echoGate, { |dtime=0.264, decay=2|
	var in;
	in = Ndef(\in).ar;
	in = LPF.ar(in, \cutoff.kr(500));
	in = Compander.ar(in, in, \thresh.kr(0.07), 10, 1, 0.01, 0.01);
	CombL.ar(in, 2, dtime, decay, 1, in)
});

Ndef(\dyn, {
	var in;
	in = Ndef(\source).ar;
	DynKlank.ar(`[{LFNoise2.kr(0.1).range(200, 720)} ! 20 * 2, 0.01, \dec.kr(0.6) ! 20], in)
});

Ndef(\dynQ, {
	var in;
	in = Ndef(\source).ar;
	DynKlank.ar(`[{LFNoise2.kr(0.1).range(200, 720).midicps.round(1).cpsmidi} ! 20 * 2, 0.01, \dec.kr(0.6) ! 20], in)
});

Ndef(\frez, {
	var in, chain;
	in = Ndef(\source).ar;
	chain = FFT({LocalBuf(2048)} ! 2, in);
	chain = PV_MagFreeze(chain, 1 - Trig1.kr(Impulse.kr(\rate.kr(1))));
	IFFT(chain);
});

Ndef(\squared, {
	var in, chain;
	in = Ndef(\source).ar;
	chain = FFT({LocalBuf(2048)} !2, in);
	chain = PV_MagSquared(chain);
	IFFT(chain) * 0.01;
});

Ndef(\smear, {
	var in, chain;
	in = Ndef(\source).ar;
	chain = FFT({LocalBuf(2048)}!2, in);
	chain = PV_MagSmear(chain, 3);
	IFFT(chain);
});

MasterEQ(2);






//////////////////////////////////////////
// Start Playback
// don't execute this unless you're Scott


(

~broadcastAddr = NMLNetAddrMP("255.255.255.255", 57120 + (0..7));
// start playback
~broadcastAddr.sendMsg('/startMRC');
// send frames



~frameClock = TempoClock.new.permanent_(true);
~clockTask = Task({
	loop { ~broadcastAddr.sendMsg('/frame', b.sampleRate *  (~frameClock.beats)); 0.05.wait;}
}).play;

//
//SystemClock.sched((60 * 6) + 38, {r.shout("1 minute left!")});
)



//////////////////////////////////////////
// Start Playback
// for solo practice
// Don't do in concert!!!!


NetAddr.localAddr.sendMsg('/startMRC');
NetAddr.localAddr.sendMsg('Testing!!!!!');



// Cleanup when finished
(
n.free;
b.close;
b.free;



~clockTask.stop;
)

