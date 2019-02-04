Spec.add(\att, [120, 1200, 'exp']); //a way to add specs

\att.asSpec

x = {arg inputVal, scale = 1,offset = 0.5; inputVal * scale + offset}; //scale and offset

x.set(\scale, 0.1) //interact externally

att.linlin(0, 100, 120, 1200); //if you know range of input signal that's easier.

[0.1, 0.5, 1.0].plot;//plotting values in SC.

d = (); //dictionary implementation to store keys to values.
d.att = [0.1, 0.5, 1.0];

d.att =  [0.1, 0.5, 1.0].reverse;

d.att.collect{arg val; val * 100 / 2} // iteration in SC.