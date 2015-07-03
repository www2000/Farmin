#
#  Random tools for project farmin
#

var noiseGenerator = func()
{
	return (rand() - rand() + rand() - rand()) /2;;
};
var C2F = func(C)
{
	return (C*9.0)/5.0+32.0;
};
var F2C = func(F)
{
	return (F - 32.0) * (5.0/9.0)
};
var C2K = func(C)
{
	return C + 273.15;
};
var K2C = func(K)
{
	return 273.15 - K;
};
var K2F = func(K)
{
	return (K * (9/5)) - 459.67;
};
var F2K = func(F)
{
	return (F + 459.67) * (5/9);
};
