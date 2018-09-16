({
	var win, texts, newtext, index = 0;

	texts = Array.newClear(50); //Array of executed codes, max number is 50 of them


	{
		win = Window("ICE-Code Display")
		.background_(Color.black).alpha_(0.09)
		.view.keyDownAction_(
			{|v, c, m , u, k|
				switch(k,
					6,{win.fullScreen},//z key to fullscreen
					7,{win.endFullScreen}//x key to end fullscreen
			)}
		);
		win.front;
	}.defer;

	newtext = {|num, newCode, fadeTime=30|
		var color;
		color = Color(*{1.0.rand}!3);// every new executed code has a random color
		{//New text object
			texts[num] = StaticText(win,Rect(640.rand,400.rand,640,400))
			.string_(newCode)
			.stringColor_(Color.white)
			.font_(Font("Courier",size:20)).align_(\topLeft)}.defer;

		{// right after new text created, fade out
			256.do{|i|
				{texts[num].stringColor_(color.alpha_(i.linlin(0,255,1,0)))}.defer;
				(fadeTime/256).wait
			}
		}.fork;

	};


	this.preProcessor = {|code| newtext.value(index%texts.size, code.asString ++ "\n\n");
		index = index + 1;
		code};

	/*OSCdef(\cR,{|msg|
		newtext.value(index%texts.size,msg[1].asString ++ "\n\n" ++ msg[2]);
		index = index + 1;
	},"/codeRelay")*/



}.fork
)

