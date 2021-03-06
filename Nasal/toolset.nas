#
#  Random tools for project farmin
#

var noiseGenerator = func()
{
	return (rand() - rand() + rand() - rand()) /2;;
};
#Temperature
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
#Length conver
var feet2Meter = func(feet)
{
	return 0.3048 * feet;
}

var meter2Feet = func(meter)
{
	return 3.2808399 * meter;
}

#Pressure
var inHG2Pascal = func(inGH)
{
	return 3386.38866667 * inGH;
};
var inHG2mBar = func(inGH)
{
	return 33.8638866667 * inGH;
};

var fgGetLowPass = func(current, target, timeratio)
{
	if(timeratio < 0.0)
	{
		if (timeratio < -1.0)
		{
			current = target;
		}
		else
		{

		}
	}
	elsif (timeratio < 0.2)
	{
		current = current * (1.0 - timeratio) + target * timeratio;
	}
	elsif( timeratio > 5.0)
	{
		current = target;
	}
	else
	{
		keep = math.exp(-timeratio);
		current = current * keep + target * (1.0 - keep);
	}
	return current;
};
