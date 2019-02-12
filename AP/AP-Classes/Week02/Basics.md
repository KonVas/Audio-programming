# Basics in SC Week 02
## Variables and abstraction
In the last tutorial we covered how to run some first lines in the SC
IDE, and learned how to understand the ecosystem of the language. The
basics, at the left you type the commands, at the right by default, you
are receiving feedback in real time about what your commands doing, and
potential errors, for example syntax and other problems encountered
during the execution of the large or small snippets of code. We also
covered how to execute one line or larger regions and how to add
comments in our code, something very important while working with
scripting languages.  

Unlike other computer languages SC is real time meaning that you don't
have to 'compile' anything and wait for potential errors while this
procedure. This makes sense for live situations especially when
improvising algorithms on the fly as the strategy for the musical
performance. More on this later in the semester. For now we will focus
on the basics of creating small programs that contain basic abstraction
of "things" named ````Variables````, by declaring names we want to
objects.

Variables are one of the most powerful way to describe something inside
a program, enabling the interaction of reusable bits of
code inside a program. For this reason we will hear this word quite a
lot from now on, so make sure you have an idea what a variable is and
how it can be used after this tutorial, run your own and experiment with
their manipulation and see the differences.

So a variable basically is a name we give to things inside regions of
code:
````js
(
  var apple = "I am a red apple";
  apple.postln;
  )
````

In this code above the apple is a variable which is a name for something
we can store in it something, can you guess why this is important... In
this way we can add things to names and make many manipulations on them
without typing again again all the time, which would be
counterproductive assuming programs are large text blocks and everything
needs to be written in a precise manner.  

So for now you can imagine a variable being a name for something we are
going to use later in our system. It's a bin a storage placeholder, it's
nothing until you assign something to it, otherwise it's ````nil````, a
word you will get used to it eventually when programming.

Try the following code below:
````js
(
  var apple;
  apple.postln
  )
  ````
  And a little more experimentation with variables to understand their cuteness.

````js
(
var apple = "big apple";
var appleColor = "red, and juicy";
("I am a " ++ apple ++ " " ++ appleColor).postln;
)
````
You probably noticed some minor additional bits in the last sentence, this is because in programming things are not always exactly how they suppose to be so many times you will have to make some workarounds, especially when is about formatting like strings for example. Now go on and make your additions to the current code and try to make it more complex and fun by adding more variables.

## Some theory on Variables
Variables as assigned using the keyword *var*, after this word you may assign any names that make sense in your program. Variables are stored on the temporary memory of SC.

At this stage you have a good idea what is a variable and how it can be
used in a program to make things easier. One thing that you probably
haven't realized is that you interacting with something called objects;
Objects in object oriented programming is all we using to make our
programs. Thus, an object can be a number, remember last tutorial making
some mathematical operations on two numbers and summing or multiplying
them. A number is an object we can perform multiple operations on it,
but not all, why? Because different objects have diverse functionality.
For exaple, we can do this on a string:
````js
"hello" ++ "world"
````
That is, concatenate two strings using two sum signs to merge them. See
the next example, and maybe try to fix it, can you imagine what's wrong
with it?

````js
(
var a = 1;
var b = 2;
var sum = a ++ b;
sum
)
````
Look into the post window and spot the cause of the error.
The issue here lies to the fact that all object have different
attributes and thus different outcome and behavior when manipulating
them, whether this is inside a string or a mathematical operation.

Try to write some region that does an operation to numbers and
concatenates some words wrapped in strings and assigned in variables.
You may also declare a variable that uses another variable declared
*first*.

### Global vs. local Variables
A problem that arises often with variables is that, variables can exist in a region that you execute inside the matching parenthesis. This sometimes is not convenient, for example you have something like below:

````js
(
var lorem = "lorem ipsum dolor sit amet",
ipsum = "consectetur adipisicing elit";
lorem ++ " " ++ ipsum
 )
 ````


What if ````ipsum```` variable can't co exist with the rest of the
declared variables inside the same region.

## Assignment
Make a region that has some meaning as a text, for
example try to explain what your breakfast consisted today, or something
you would feel more comfortable sharing with SC and your computer's
electrons.  

## Functions
Functions are the building blocks of our programs, so if a program is a
house then functions are the bricks. See the Functions file
inside the folder of this tutorial.

# Reading list
SuperCollider Handbook pp.6-18 _Messages and Arguments_.
SuperCollider Handbook pp.6-18 _Variables_.
SuperCollider Handbook pp.128 _Objects and Classes_.

## Links to online resources
Object Oriented Programming for Beginners:
https://developer.mozilla.org/en-US/docs/Learn/JavaScript/Objects/Object-oriented_JS
