~portNumber = 57120; //The port that the other app is listening for messages.

n = NetAddr(hostname:"localhost", port: ~portNumber); //the address of the other computer, and the port that the other app is listening.

OSCdef(\loopback, {|msg| msg.postln; }, '/hello'); //this is just an example to loopback OSC messages. Every message that is received in this case '/hello' it will be printed in the post window.


n.sendMsg("/hello", "World");