OSCFunc.trace(false);

OSCdef('printOSCMsgs', {|msg| msg[1].postln;
}, '/test');

/* Processing's port, since we working in the same machine address is localhost.*/
n = NetAddr("127.0.0.1", 12000);

//send OSC message to Processing.
n.sendMsg('/test', "Hello");