//No Utopia, using this version is for duo with instrument.
(
s.reboot;
~numOuts = 12;
// input
"VibInput.scd".resolveRelative.load;

~soloDef = \default;

~soloBus = 0;

/////// Phrase Window

~phraseWindow = ScrollView(bounds: 800@400).front;
~phraseWindow.canvas = ~canvas = View();
~canvas.layout = VLayout(
	~phraseView = UserView());
~canvas.layout.spacing_(0);
~canvas.layout.margins_(0);
~phraseWindow.hasVerticalScroller = false;
~notes = []; // (time, midinote, amp)
~secondWidth = 80;

~funcDict = IdentityDictionary();
~keysDown = IdentitySet();

~phraseView.drawFunc = {|view|
	var viewHeight = view.bounds.height;
	var viewWidth = view.bounds.width;
	var stepSize = viewHeight / 86;
	var now = ~mouseDownNow ?? { Main.elapsedTime };

	Pen.stringInRect("Drag mouse to select notes\nHold:\n\t\talt for looping pattern\n\t\tctrl to round to mode\n\t\tshift to open in new doc\n\t\tcmd to play immediately\n\t\tarrow to round durs\n\t\tn to play in an individual Ndef", Rect(20, 10, 400, 200), Font("Helvetica", 14, true), Color.grey(0.5, 0.5));

	// draw the grid
	DrawGrid(view.bounds, ControlSpec((view.bounds.width / ~secondWidth).neg, 0, step:1.0).grid, ControlSpec(21, 108, step:1).grid).draw;

	// draw any selection
	if(~selEnd.notNil, {
		Pen.addRect(Rect(~selStart, 0, ~selEnd - ~selStart, view.bounds.height));
		Pen.color = Color.gray(0.2, 0.3);
		Pen.fill;
	});

	// now the notes
	// piano goes from 21 - 108 in midinotes
	~notes.do({|note|
		Pen.addRect(Rect(
			viewWidth - (~secondWidth * (now - note.time)),
			//viewHeight - (stepSize * (note.midinote - 20)), // for piano roll
			viewHeight - (stepSize * (note.midinote - 52)), //for vibraphone roll
			stepSize,
			stepSize)
		);
		Pen.color = Color.red(note.amp * 0.5 + 0.5);
		Pen.fill;
		Pen.color = Color.black;
		Pen.stroke;
	});
};

~phraseView.mouseDownAction = {|view, x, y|
	~mouseDown = true;
	~selStart = x;
	~selEnd = x;
	~mouseDownNow = Main.elapsedTime;
};

~phraseView.mouseMoveAction = {|view, x, y|
	~selEnd = x;
	view.refresh;
};

~nDown = false;
~phraseView.keyDownAction_({|view, char, mods, unicode|
	if(char == $n, { ~nDown = true }, {
		if(unicode != 0, { // ignore mod keys
			~keysDown.add(char.asSymbol);
		});
	});
});
~phraseView.keyUpAction_({|view, char, mods, unicode|
	if(char == $n, { ~nDown = false }, {
		if(unicode != 0, {
			~keysDown.remove(char.asSymbol);
		});
	});
});

~selectionNum = 1;
~phraseView.mouseUpAction = {|view, x, y, mods|
	var start, end, selectedNotes;
	var viewWidth = view.bounds.width;
	start = ~mouseDownNow - ((viewWidth - min(~selStart, ~selEnd)) / ~secondWidth);
	end = ~mouseDownNow - ((viewWidth - max(~selStart, ~selEnd)) / ~secondWidth);
	selectedNotes = ~notes.select({|note|
		(note.time >= start) && (note.time <= end)
	});
	if(selectedNotes.size > 0, {
		var string, params, midinotes, amps, durs, durSum, lastDur, repeats;
		var controlNames, otherParamsString, endString;
		var nameString;
		params = selectedNotes.collect({|note|
			[note.time, note.midinote, note.amp]
		}).flop;

		// durations
		durs = params[0].differentiate.drop(1);
		if(durs.size > 0, {
			durSum = durs.sum;
			lastDur = durSum.roundUp(0.25) - durSum;
		});
		durs = durs.add(lastDur ? 0.25); // dup last duration, catch one note corner case
		if(mods.bitAnd(2097152) == 2097152, {
			durs = durs.collect({|dur| dur.round(0.125).max(0.125) });
		});

		//pitches
		midinotes = params[1];
		if(mods.isCtrl, {
			var interruptPC;
			interruptPC = (~interrupt%12).sort;
			midinotes = midinotes.collect({|note|
				var octave, pc;
				octave = floor(note / 12);
				pc = note%12;
				pc.nearestInList(interruptPC) + (octave * 12)
			});
		});

		// amps
		amps = params[2];

		// other controls
		controlNames = SynthDescLib.global[~soloDef.asSymbol].controls;
		controlNames = controlNames.reject({|cn|
			// get rid of used keys
			[\out, \freq, \dur, \amp, \midinote, \gate, \degree].includes(cn.name.asSymbol);
		});
		otherParamsString = "";
		controlNames.do({|cn|
			otherParamsString = otherParamsString ++ ",\n\t'%', %".format(cn.name.asSymbol, cn.defaultValue);
		});

		//nameString = "%-%".format(~selectionNum, ~addrBook.me.name.asString);
		nameString = "%-%".format(~selectionNum, "konvas");

		// check for non-mod keys and funcs in Dict
		if(~keysDown.size > 0, {
			~keysDown.do({|key|
				var res;
				res = ~funcDict[key].value(durs, midinotes, amps, mods, ~soloDef, controlNames, nameString);
				if(res.isKindOf(String), { string = res });
			});
		}, {

			if(~nDown, {
				endString = ";\nNdef('%')[0] = Pdef('%');\nNdef('%').play;".format(nameString, nameString, nameString);
			},{ endString = ".play(TempoClock(), quant:0)" });

			repeats = if(mods.isAlt, {inf}, {1});
			string = "(\nvar rpts = %;\nPdef('%', Pbind(\n\t'instrument', '%',\n\t'dur', Pseq(%, rpts) * 1, \n\t'midinote', Pseq(%, rpts) + 0, \n\t'amp', Pseq(%, rpts) * 1,\n\t'out', ~soloBus%\n))%\n)".format(repeats, nameString, ~soloDef.asSymbol, durs.asCompileString, midinotes.asCompileString, amps.asCompileString, otherParamsString, endString);
		});

		if(string.notNil, {
			if(mods.isShift || ~lastDocument.isNil, {
				~lastDocument = Document("Selection Doc %".format(~selectionNum), string);
				~lastDocument.onClose = {|doc|
					if(~lastDocument == doc, { ~lastDocument = nil });
				};
			}, {
				~lastDocument.text = ~lastDocument.text ++ "\n\n" ++ string;
				~lastDocument.front;
			});

			if(mods.isCmd, { string.interpret });
		});
		~selectionNum = ~selectionNum + 1;
	});
	~selStart = nil;
	~selEnd = nil;
	~mouseDown = false;
	~mouseDownNow = nil;
	~keysDown.clear;
	view.refresh;
};


~debug = false;
OSCdef(\onsetDef, { arg msg, time;
	var freq, amp, midinote, hasFreq;
	hasFreq = msg[5].booleanValue;
	//\trig.postln;
	//msg.postln;
	if(msg[3] > 0.05 && hasFreq, {
		if(~debug, {msg.postln});
		freq = msg[4];
		amp = msg[3].clip(0, 0.75);
		//midinote = freq.cpsmidi.round;
		midinote = freq.cpsmidi.round;
		~notes = ~notes.add((time: Main.elapsedTime, midinote: midinote, amp: amp));
	})
}, '/onsets1').fix;

//Oscdef for timed finale.
OSCdef(\shutkey, {|msg|
	if(msg[1] == 1) {
		var time = 0.2;
		Pdef.clear(time);
		Ndef.clear(time);
	}
}, '/shut');

~mouseDown = false;
SkipJack({
	if(~mouseDown.not, {
		{~phraseView.refresh;}.defer;
	});
}, 0.1, {~phraseWindow.isClosed});

/*~textureDef = \default;
~interruptDef = \default;
~soloDef = \default;

~soloBus = Bus.audio(s, 2);


Ndef(\t).play(vol:0.5); // texture
Ndef(\i).play(~interruptBus.index, vol: 0.5); // interrupt
Ndef(\s).play(vol: 0.5); // solo

Ndef(\t)[0] = Pdef(\t);
Ndef(\i)[0] = Pdef(\i);
Ndef(\s)[0] = { In.ar(~soloBus, 2) };*/

NdefMixer(s);
PdefAllGui();

//////////////////// RecordBuf

SynthDef(\grain, { arg out=0, freq=440, sustain=0.05, amp=0.1, buf, rate=1, pos;
	var env, pb;
	env = EnvGen.kr(Env.sine(sustain, amp), doneAction:2);
	pb = PlayBuf.ar(1, buf, rate, startPos:pos * BufSampleRate.kr(buf));
	Out.ar(out, pb * env)
}).add;

~recWin = Window.new("recordings").front;
~recWin.layout = VLayout(~recBut = Button().states_([["Record New (10 secs max)", Color.black, Color.green], ["Record Stop", Color.black, Color.red]]), ~recsList = ListView(), StaticText().string_("Select and press p for new Pdef, n for Ndef"));
~currentBuf = Buffer.alloc(s, s.sampleRate * 10);
~recNum = 0;
~recBufs = List.new;
~recDurs = List.new;
~recBut.action = {|but|
	switch(but.value,
		1, { var synth;
			~recStart = Main.elapsedTime;
			~recsynth = { RecordBuf.ar(SoundIn.ar(~audioIn), bufnum:~currentBuf, loop:0, doneAction:2); }.play;
			~recsynth.onFree({
				{
					var recDur;
					recDur = Main.elapsedTime - ~recStart;
					~recDurs.add(recDur);
					"Recording lasted % seconds\n".postf(recDur);
					~recBut.value_(0);
					~recsList.items = (~recsList.items ++ ~recNum).asArray;
					~recsList.value = ~recNum;
					~recNum = ~recNum + 1;
					~recBufs.add(~currentBuf);
					~currentBuf = Buffer.alloc(s, s.sampleRate * 10);
					~recsList.focus;
				}.defer;

			});
		},
		0, {
			~recsynth.free;
		}
	);
};
~recsList.keyDownAction = {|view, char|
	switch(char,
		$p, {
			Document.new("Pdef for Buffer " ++ view.value, "Pdef('Buf %-%', Pbind(\\instrument, \\grain, \\buf, ~recBufs[%], \\rate, 1, \\pos, Pseg(Pseq([0, %]), Pseq([%, 0]), repeats:inf), \\sustain, 0.05, \\delta, Pwhite(0.01, 0.04), \\out, Prand((0..(~numOuts-1)), inf))).play".format(view.value, UniqueID.next, view.value, ~recDurs[view.value], ~recDurs[view.value]));
			true
		},
		$n, {
			Document.new("(/nNdef for Buffer " ++ view.value, "(\nNdef('Buf %-%', {|rate = 1, loop = 1, t_trig = 1, pan = 0|\n\tPan2.ar(PlayBuf.ar(1, ~recBufs[%], BufRateScale.kr(~recBufs[%]) * rate, t_trig, loop: loop), pan)\n}).play\n)".format(view.value, UniqueID.next, view.value, view.value));
			true
		}, { false }
	)
};
)

////////////////////////////// Examples //////////////////////////////

//// Using the custom Func Dict ////

// functions will be called with these args: durs, midinotes, amps, mods, soloDefName, controlNames, nameString
// mods are keyboard modifiers like ctrl and alt
// nameString is a generated namestring which can be used with a Pdef

// if the function returns a string, then it will generate a new doc

// lets make a Pmono version with the m key
(
~funcDict[\m] = {|durs, midinotes, amps, mods, soloDefName, controlNames, nameString|
	var repeats, string, endString, otherParamsString;

	repeats = if(mods.isAlt, {inf}, {1}); // check mods for alt

	if(~nDown, { // if n is down play in an Ndef
		endString = ";\nNdef('%')[0] = Pdef('%');\nNdef('%').play;".format(nameString, nameString, nameString);
	},{ endString = ".play(TempoClock(), quant:0)" });

	otherParamsString = "";
	controlNames.do({|cn|
		otherParamsString = otherParamsString ++ ",\n\t'%', %".format(cn.name.asSymbol, cn.defaultValue);
	});

	string = "(\nvar rpts = %;\nPdef('%', Pmono(\n\t'default',\n\t'dur', Pseq(%, rpts) * 1, \n\t'midinote', Pseq(%, rpts) + 0, \n\t'amp', Pseq(%, rpts) * 1,\n\t'out', ~soloBus%\n))%\n)".format(repeats, nameString, durs.asCompileString, midinotes.asCompileString, amps.asCompileString, otherParamsString, endString);

	string // returns a string so will open a new doc
};
)

// This function pops up a GUI for performance
(
SynthDef(\sinegrain, { arg out=0, freq=440, sustain=0.05, amp=0.1;
	var env;
	env = EnvGen.kr(Env.perc(0.01, sustain, amp, 0.1), doneAction:2);
	Out.ar(out, Splay.ar(SinOsc.ar([freq, freq * 0.5], 0, env)))
}).add;

~funcDict[\s] = {|durs, midinotes, amps, mods, soloDefName, controlNames, nameString|
	var slider, eventStreamPlayer, maxNoteIndex;
	maxNoteIndex = midinotes.size - 1;
	slider = Slider2D(bounds:200@200).front;
	slider.mouseDownAction = {
		eventStreamPlayer = Pbind(
			\instrument, \grains, //never hasher synth!
			\dur, Prand(durs * durs.maxItem.reciprocal * 0.05, inf),
			\midinote, Pfunc({ midinotes[(slider.y * maxNoteIndex).round] }),
			\amp, Pfunc({ slider.x })
		).play(AppClock);
	};
	slider.mouseUpAction = { eventStreamPlayer.stop };
};
)


/////// Section 3 ///////

// use pitch capture and custom funcs to create drones
(
~funcDict[\p] = {|durs, midinotes, amps, mods, soloDefName, controlNames, nameString|
	var ampScale, durScale, out;
	// fiddle with the gate arg to re-trig
	Ndef(nameString.asSymbol, {|t_gate = 1|
		ampScale = 0.5 / amps.sum;
		durScale = (40 / durs.maxItem).floor;
		out = SinOsc.ar(midinotes.midicps, mul: amps.collect({|amp, i| Env.sine(durs[i] * durScale, amp * ampScale).delay(TRand.kr(0.0, 3.0, t_gate)).kr(gate:t_gate)}));
		Splay.ar(out.scramble)
	}).play(vol:0.5);
}
)

// pattern drone
(
SynthDef(\sinegrain, { arg out=0, freq=440, sustain=0.05, amp=0.1;
	var env;
	env = EnvGen.kr(Env.perc(0.01, sustain, amp, 0.1), doneAction:2);
	Out.ar(out, Splay.ar(SinOsc.ar([freq, freq * 0.5], 0, env)))
}).add;

~funcDict[\q] = {|durs, midinotes, amps, mods, soloDefName, controlNames, nameString|
	var ampScale, durScale, out;
	durScale = (12 / durs.maxItem).floor;
	Pdef(nameString.asSymbol, Pbind(\instrument, ~soloDef, \midinote, Prand(midinotes, inf), \dur, Pwhite(1, 3), \amp, 0.02, \legato, Prand(durs * durScale, inf)));
	Ndef(nameString.asSymbol, Pdef(nameString.asSymbol)).play;

}
)