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

// Methods...



