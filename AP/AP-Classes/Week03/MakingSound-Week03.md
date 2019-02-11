## Creating sound with SC
Run the following lines one each time and see at the post window. To
create a simple sound in SC run the last line, it will create the
simplest sound you can ever imagine, that is a sine oscillator. Once
this is done we can move on with more interesting examples.

````js
"Hello World";
s.server;
(
//double click to select all region
    play{
      SinOsc.ar(120.0, 0, 0.3)
    }.scope;
)
````

Notice the semicolon sign at the end of each line, this is used to
separate each command, if the semicolon is missing then the code will be
executed as one line, this is the most common syntax error for beginners
and not.

In SC every time you execute some code it will run as a command and you
will see the result of the command in real time. That is to say that SC
is a real time environment making ideal to improvise and manipulate code
on the fly. More about this later. Right now we need to make sure we
know how to execute code and make some sense when looking at the post
window.

```` js
//execute these lines below separately
1 + 1;
1 + a;
[(1..4)].mirror;
("Hello World").mirror;
````
In the lines above each time we execute something we see some response
in our post window, sometimes giving a sensible feedback and some less
readable. This is because SC will try to let you know what you are doing
wrong or right, most likely in the first case the information coming
from SC post window is rather important, as it will let you know what is
the error of your code, and it will help you to debug the code that is
causing the problem.
