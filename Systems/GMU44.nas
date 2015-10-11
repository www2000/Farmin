#
#	Farmin GMU44
#
#


var GMU44 = {
	new: func(module=0)
	{
		var m = { parents: [GMU44] };
		m.module = module;
		var dataOut = {};
		var dataIn	= {};
		root = props.globals.initNode('/Farmin/GMU44['~m.module~']');
		dataOut.serviceable 	= root.initNode('serviceable', 1, "BOOL");
		dataOut.operable		= root.initNode('operable', 0, "BOOL");
		dataOut.heading			= root.initNode('heading',0,'DOUBLE');
		dataOut.Magnetometer_X	= root.initNode('MagnetometerX',0,'DOUBLE');
		dataOut.Magnetometer_Y	= root.initNode('MagnetometerY',0,'DOUBLE');
		dataOut.Magnetometer_Z	= root.initNode('MagnetometerZ',0,'DOUBLE');

		datain.
		m.dataIn	= dataIn;
		m.dataOut	= dataOut;

		m.smooth = smooth.new(30);
		return m;
	},
	update: func()
	{

		if(power == 0 or serviceable == 0)
		{

			settimer(func { me.offLine() }, 0.02);
		}
		else
		{
			settimer(func { me.update() },0.02);
		}
	},
	offLine: func()
	{

		if(power == 1 and serviceable == 1)
		{
			settimer(func { me.update() }, 2);
		}
		else
		{
			settimer(func { me.offLine()}, 1);
		};

	},
	run: func()
	{
		thread.newthread(func { me.offLine() })
	},
};
#test delete in the further.
test = GMU44.new(0);
test.run();

test2 = GMU44.new(1);
test2.run();
