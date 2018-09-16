// Onset defaults

~onsetDelay = 0.1;
//~onsetThresh = 0.35; // something around 0.35 good with 414s, mics in RME at 55
~onsetThresh = 0.04; // something around 0.13 good with 414s, mics in RME at 25

~onsetBus = Bus.control;
~onsetBus.set(~onsetThresh);
~onsetBufSize = 1024;
~audioIn = 0;
//~audioIn = 1;
//b = Buffer.read(s, "testBass.aif".resolveRelative);

~onsetFunc = {
~onsetSynth = SynthDef(\onsets, {|thresh, delay|
	var in, chain, onsets, amp, pitch, hasFreq;



	//in = PlayBuf.ar(2, f) * 4;
	/*in = Mix(SoundIn.ar(~audioIn)) * 0.5;*/
	in = Mix(SoundIn.ar(~audioIn)) * 2;
	//in = PlayBuf.ar(1, b, BufRateScale.kr(b), loop:1); Out.ar(0, in); // test version


	//amp = RunningSum.rms(in, 256); // presumably show last attack
	amp = Amplitude.kr(in);

	chain = FFT(LocalBuf(~onsetBufSize), in * 10);

	//onsets = DelayN.kr(Onsets.kr(chain, 0.5), 0.1, 0.1);
	onsets = Onsets.kr(chain, thresh);

	//onsets.scope;

	//Poll.kr(onsets, onsets, 'onsets');

	#pitch, hasFreq = Pitch.kr(in, 40.midicps, 21.midicps, 108.midicps, peakThreshold:0.5); //piano range.
	//Poll.kr(onsets, onsets);
	//Out.ar(0, in.dup * 0.1);
	SendPeakRMS.ar(in, 20, 3, '/peakRMS');

	SendReply.kr(onsets, '/onsetsASAP', [amp, pitch, hasFreq]); // probably don't need pitch
	SendReply.kr(DelayN.kr(onsets * hasFreq, delay, delay), '/onsets1', [Peak.kr(amp, onsets), pitch, hasFreq]);
	0.0
	//in
}).play(s, [delay: ~onsetDelay, thresh: ~onsetBus.asMap]);

};
~onsetFunc.value;

ServerTree.add(~onsetFunc);

//this version for Utopia Land, for solo comment the OSCdef below.
~debug = false;
/*
OSCdef(\onsetForwardDef, { arg msg, time;
	var freq, amp, midinote, hasFreq;
	hasFreq = msg[5].booleanValue;
	//msg.postln;
	msg[0] = '/onsets';
	if(msg[3] > 0.05 && hasFreq, {
		if(~debug, {msg.postln});
		~addrBook.sendAll(*msg);
	})
}, '/onsets1', s.addr);
*/

OSCdef(\peakRMS, {|msg|
	{ ~level.peakLevel_(msg[3]); ~level.value_(msg[4]) }.defer
}, '/peakRMS').fix;


// message GUI
~messagesWin = Window.new.front;
~messagesWin.layout = VLayout(
	~messages = StaticText(),
	StaticText().string_("Onset Threshold").font_(Font("Helvetica", 12, true)),
	Slider(bounds:100@20).value_(~onsetThresh).action_({|slid| ~onsetBus.set(~onsetThresh = slid.value)}),
	~level = LevelIndicator(bounds:100@20)
);
~level.drawsPeak_(true);
~messages.font = Font("Helvetica", 24, true);
~messages.string = "\n\n";

