~synth = {|freq = 220| CombC.ar( LFTri.ar([freq, freq * 2.01], 0, 0.1) )}.play;

(
~interval = 0.5;
~series = 10;


~change_freq = {
	var freq = 220.0;
	freq = freq * Array.series(~series, ~interval, 0.25).choose;
	~synth.set(\freq, freq)
}
)

fork({ loop{ 0.1.wait; ~change_freq.value;} });