// =====================================================================
// SuperCollider Workspace
// =====================================================================


d = ();

d = (
	a: (1..3),
	b: (3..6),
	c: (6..9)
)

d[\c]

play({ Decay.ar(Impulse.ar(XLine.kr(1,50,20), 0.25), 0.2, PinkNoise.ar, 0) });


p = Pbind(\dur, rrand(0.21, 0.75), \octave, 1, \degree, ).play;

p.stop;

60.midicps;\
