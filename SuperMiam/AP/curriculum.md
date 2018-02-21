
* MultiMedia Design Class (MMD) :noexport:
  The MMD class will focus on creative coding using current media for the creation
  of interactive projects. It will possibly offer two groups. The split could be
  done by making introductory / advanced classes - basically spreading the current
  syllabus out over two semesters, and then perhaps adding a bit more basic stuff
  at the start for the absolute beginners; or the class could be split into a
  class that focuses on programming, and another more oriented towards hardware
  hacking.

** Suggested topics
*** Hardware prototyping
    A look on current practices on hardware development using open-electronics and
    microcontroller boards, this will include the following:
    + Arduino
      + Sensors, switches, and whatnot.
      + Programming of the microcontroller board.
      + Communication with audio environments.
    + Raspberry Pi
      + Running projects on a board.
      + Building real time audio software to run on the board.

    Tutorials will provide a hands on experience on making projects with the boards,
    including establishing communication with the outside world (e.g., serial,
    Firmata etc.). At the end of the class, the students will have to create a
    system which will be used for an interactive set-up, for example, an
    interactive installation, or a performance environment[fn:1].
 
* Audio Programming Class (AP)
  The course aims to introduce students to programming of musical software using
  the SuperCollider (open-source) programming language, a state of the art
  platform for audio synthesis and algorithmic composition. It will elaborate in
  programming concepts for real time sound synthesis software for various
  contexts including laptop performances to interactive installations. Some
  ready made implementations of sound synthesis techniques will be provided.
  Student output will be in the form of weekly coding assignments as well as
  final projects mainly demonstrating debugging and development skills.


| Week | Date         | Topic                                                                                            |
|------|--------------|--------------------------------------------------------------------------------------------------|
|    1 | February 7   | "Hello World!" Introduction in SC and the IDE.                                                   |
|    2 | February  14 | Server vs. SClang architecture. Mathematical operations, arrays, scoping variables.              |
|    3 | February 21  | Functions, passing arguments, and data manipulation.                                             |
|    4 | February  28 | SynthDefs, Synths, and Busses synthesis techniques, and signal manipulation.                     |
|    5 | March 7      | Control/interaction with SynthDefs (coninued from Feb. 28).                                      |
|    6 | March 14     | Manipulating SynthDef signals using effects and busses (coninued from March 7).                  |
|    7 | March 21     | Granulation with patterns of SC.                                                                 |
|    8 | March 28     | Mid term break.                                                                                  |
|    9 | April 4      | Algorithmic composition (events, streams, patterns, and stochastic processes).                   |
|   10 | April 11     | Scheduling: tasks routines and /just in time/ scheduling in SC.                                  |
|   11 | April 18     | Sound analysis (FFT).                                                                            |
|   12 | April 25     | JITLib overview: Ndefs, placeholders and proxies.                                                |
|   13 | May 2        | Graphical User Interfaces (GUI) in SC.                                                           |
|   14 | May 9        | External communication, controlers and OSC.                                                      |
|   15 | May 16       | Networking in SC.                                                                                |
|   16 | June 1       | Final project (digital instrument/live performance environment).                                 |

** Suggested topics (not in a particular order).
*** An Introduction to audio programming using the SuperCollider[fn:3] language for sound synthesis and algorithmic composition.
   + Introduction.
     + "Hello World!" and the IDE.
     + Scoping variables (global vs. local variables).
     + Parens (calculations).
     + Arrays (ordered collections).
     + Functions (the building blocks of programs).
     + Function callbacks and passing arguments.
     + Functional programming and Operators.
   + Digital Signal Processing (DSP).
     + Functions and sound synthesis.
     + UGens (audio unit generators).
     + Synth definitions and functions.
     + Recording and generating audio files.
   + Sound Synthesis Techniques:
     + Additive, Subtractive, Granulation, etc.
   + Control
     + Interacting with SynthDefs, algorithmic composition.
     + Higher level control of SynthDefs (Streams & Events).
     + Specs (mapping and manipulation of control signals).
   + External communication in SC.
     + Communication protocol implementations.
     + Mapping of external controllers/hardware interfaces.
   + Networking in SC.
     + Working locally (i.e., Pure Data[fn:4] and SC interaction).
     + Remote Server communication.

* Live Coding - laptop ensemble :noexport:
  In the laptop ensemble course the tutorials will focus on performance aspects with
  custom made systems using just in time programming techniques and live coding.
  The main aims of the course is to form a live coding ensemble
  focusing its research activities on network musical performance. Potential
  members of the ensemble will have to demonstrate competence in computer music
  performance and coding literacy, thus attending the audio programming and becoming
  familiar with the SuperCollider environment and at the same time being
  interested in laptop performance both in creative and research contexts is
  imperative.



* Live Coding Seminar (for AP advanced level) :noexport:
  A live coding course part of the audio programming advanced class using network
  music performance systems and Just In Time programming technics. The goal of the
  class is to create a laptop group with own repertoire and software. Members of
  the ensemble will be required to attend regular rehearsals and contribute to the
  repertoire and software of the ensemble. Instrumental students from other
  departments will be able to join and compose live electronics compositions and
  collaborate with the ensemble.

* Creative Coding Club :noexport:
  A bi-weekly informal meeting as an open space to discuss current projects,
  programming development and whatnot of student works. The form of the meetings
  will be as an informal meeting where experienced and non-experienced users may
  share ideas, hacks, and insights of their projects. This may take place in the
  University or anywhere suited for chill talks providing minimum technical
  support for example, a pair of speakers and a projector.

* Footnotes

[fn:4] https://puredata.info/

[fn:3] http://supercollider.github.io/
[fn:2] In connection with the MMD classes.
[fn:1] Using an environment that was developed in the AP class.
