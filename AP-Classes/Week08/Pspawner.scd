Pspawner({| sp |

	sp.par(Pbind(*[\dur, 0.15, \degree, 1]));
	sp.seq(Pbind(*[\dur, 0.15, \degree, 4]));

	sp.wait(2.5);
	sp.seq(Pbind(*[\dur, 0.15, \degree, 3]));
	sp.wait(2.5);
	sp.suspendAll;
}).play;
