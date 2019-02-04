n = NetAddr("172.20.10.6", 57120);

d = (a:1, b:2, c:3); //dictionary

OSCdef(\alpha, {|msg|
	msg.postln;
	d.a = msg[1]; //assign each message to dict indexes.
	d.b = msg[2];
	n.sendMsg(*msg); //for
	}, '/alpha');

(
	(
f = { |msg, time, addr|
    if(msg[0] != '/status.reply') {
        "time: % sender: %\nmessage: %\n".postf(time, addr, msg);
    }
};
thisProcess.addOSCRecvFunc(f);
);

// stop posting.
thisProcess.removeOSCRecvFunc(f);
	)

d = (a:1, b:2, c:3);

d.values.collect{|i| i };
n  = nil
(
r = Routine({
	inf.do{|i|
	p = Pwhite(0.1, 1.0).asStream;
	if(n.notNil == true){
		n.sendMsg("hello", p.next);
	};
	0.5.wait;
	};
}).play;
)

r.stop; // stop the routine 
r.play; //start again;
