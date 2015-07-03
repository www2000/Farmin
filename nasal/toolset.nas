#
#  Random tools for project farmin
#


var noiseGenerator = func()
{
	return (rand() - rand() + rand() - rand()) /2;;
};
var C2F = func(c)
{
	return (c*9)/5+32;
};
