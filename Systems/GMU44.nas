#
#	Farmin GMU44
#
#


var GMU44 = {
	new: func(module=0)
	{
		var m = { parents: [GMU44] };
		m.module = module;
		var dataOut 				= {};
		var dataIn					= {};
		root 						= props.globals.getNode('/Farmin/GMU44['~m.module~']', create=1);
		dataOut.serviceable 		= root.initNode('serviceable', 1, "BOOL");
		dataOut.operable			= root.initNode('operable', 0, "BOOL");
		dataOut.heading				= root.initNode('heading',0,'DOUBLE');
		dataOut.Magnetometer_X		= root.initNode('MagnetometerX',0,'DOUBLE');
		dataOut.Magnetometer_Y		= root.initNode('MagnetometerY',0,'DOUBLE');
		dataOut.Magnetometer_Z		= root.initNode('MagnetometerZ',0,'DOUBLE');

		dataIn.magnetic_dip			= props.globals.getNode('/environment/magnetic-dip-deg');
		dataIn.magnetic_variation	= props.globals.getNode('/environment/magnetic-variation-deg');
		m.dataIn	= dataIn;
		m.dataOut	= dataOut;

		#m.smooth = smooth.new(30);
		return m;
	},
	update: func()
	{
		#set the defauld value for the magnetometer.
		var MagneticX	= 1;
		var MagneticY	= 0;
		var MagneticZ	= 0;

		#set variation dip and variation.
		var mdip		= me.datain.magnetic-dip.getValue();
		var mvar		= me.datain.magnetic-variation.getValue();

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
var run = func(){
var test = GMU44.new(0);
test.run();

test2 = GMU44.new(1);
test2.run();
};
setlistener("/sim/signals/fdm-initialized", run);
