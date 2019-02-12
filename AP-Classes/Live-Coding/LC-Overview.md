# Live Coding

Live coding is the improvisation of the structure of the algorithms
while at run. The performance strategy involves the real time hacking of
the source code of a software that provides some sounds synthesis
processing and sound modules, such as Ndefs, Tasks, and Routines using
Just In Time coding techniques.

The following tutorial will be heavily based on examples using the
JITLib in SuperCollider, and therefore a basic familiarity with the
standard SC syntax and nuances of the language is imperative to
understand further concepts of real time programming in SuperCollider.

# Live Coding in SC
Creating sound with SC can be very rewarding using its ready made unit
generators to build novel instruments and sound generators, but what
happens when one wants to improvise the structure of these instruments
and change them on the fly.[⌃1]

## Patterns in SC

## JITLib

`Ndef` is a node proxy which is a convenient method in JITLib to create
sound and modify without stopping the workflow of the algorithms that
run in the background. Here is an example, declare an `Ndef` and start
it:

``` js
Ndef(\x).play;
```
Once you created it you can update its content in real time, make sure
you are modifying the one using the right key, that is \x in this case:

``` js
Ndef(\x, {SinOsc.ar(\freq.kr(120.0, 0.3)) * 0.1 });
```
Note that it started played, since we have initiated it with .playNow we
have something that is playing. Besides the .start and .stop an `Ndef`
provides many other methods, including fadeTime and other interaction
methods.

Add fade time, and notice how the *`Ndef`(\x)* changes according to the
time given.

``` js
Ndef(\x).fadeTime = 2; //2 seconds of fade time.
```

``` js
Ndef(\x, {SinOsc.ar([\freq.kr(120.0), \freq.kr + 2.01]) / 2 * 0.1}); //smoother transition.
```

## Footnotes
[⌃1]: The process of responding to the sonic outcome while manipulating the code during improvisation.
