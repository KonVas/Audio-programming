//Functions
// Functions have variables, as static "things" but also arguments which can be changed on the fly, dynamically and externally.

(
x = {
	arg c, d; //declaring arguments.
	var a = 2;
	var b = 5;
	a + b
}
);

(
x = {
	arg c, d; //declaring arguments.
	c / d;
}
)

x.value(2, 3);// assign the numbers externally.

////using functions as parameters.
(
y = {
	arg c = 2, d = 3; //declaring arguments.
	c / d;
}
)

(
x = {
	arg a = 100;
	a * y.value;
	// using the y function as parameter here
}
)

x.value(0.001);

//Some examples about locals and global variables
//Local Vars vs Global Vars
(
var randomValue, string;
randomValue = 100.0.rand;
string = "catch a rand value";
(string + randomValue);
)

~randomValue = 100.0.rand.round;

~string = "catch a rand value";

//Combining Arguments and Variables in Functions
//this is also known as functional programming.

(
~randomAge = {
	arg age;
	var string = "My age is:";
	(string + age)
}
)

~randomAge.value(20.rand);

// Methods...



