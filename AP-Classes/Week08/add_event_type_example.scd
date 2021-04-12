d = ();

Event.addEventType(\node1, {
	var data, keys;
	data = {rrand(0.1, 1.0).round(0.01)}!8;
	keys = ['alpha', 'beta', 'gamma', 'theta'];
	keys.collect({|key| //first loop in the keys array.
		data.do{|i| //nested loop in data values.
			if (i > 0.25, { //a boolean to rule out specified values.
				d.add(key -> i) //assigning the values accordingly
			}, {i = 0.1; d.add(key -> i) // if the value is less than spec it will assign 0.1.
			})
		};
	});
	d.postln;
});

Pbind(\dur, 0.08, \type, \node1).play;