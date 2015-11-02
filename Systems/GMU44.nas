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
		dataIn.pitch				= props.globals.getNode('/orientation/pitch-deg');
		dataIn.roll					= props.globals.getNode('/orientation/roll-deg');
		dataIn.yaw					= props.globals.getNode('/orientation/heading-deg');
		dataIn.magheading			= props.globals.getNode('/orientation/heading-magnetic-deg');
		m.dataIn					= dataIn;
		m.dataOut					= dataOut;

		#m.smooth = smooth.new(30);
		return m;
	},
	update: func()
	{
		#set the defauld value for the magnetometer and include the magnetic-dip and magnetic_variation.
		var md = me.dataIn.magnetic_dip.getValue() * D2R;
		var mv = me.dataIn.magnetic_variation.getValue() * D2R;
		var MagneticX	= 1 * math.cos(mv) * math.sin(md);
		var MagneticY	= 1 * math.sin(mv) * math.sin(md);
		var MagneticZ	= 1 * math.cos(md);

		#set the pitch roll yaw values of the plane
		var pitch	= me.dataIn.pitch.getValue() * D2R;
		var roll	= me.dataIn.roll.getValue() * D2R;
		var yaw		= me.dataIn.yaw.getValue() * D2R;
		#apply pitch (around x)
		MagneticX = MagneticX * cos(yaw) - MagneticZ * sin(yaw)
		MagneticZ = MagneticZ * cos(yaw) + MagneticX * sin(yaw)
		#apply Roll (around y)
		MagneticY = MagneticY * cos(roll) - z * sin(roll)
		MagneticZ = MagneticZ * cos(roll) + MagneticY * sin(roll)
		#apply roll (around z)
		MagneticX = MagneticX * cos(pitch) - MagneticY * sin(pitch)
		MagneticY = MagneticY * cos(pitch) + MagneticX * sin(pitch)

		Heading_mag = dataIn.magheading.getValue();

		if(power == 0 or serviceable == 0)
		{

			settimer(func { me.offLine() }, 0.02);
		}
		else
		{
			me.dataOut.heading.setDoubleValue(Heading_mag);
			me.dataOut.Magnetometer_X.setDoubleValue(MagneticX);
			me.dataOut.Magnetometer_Y.setDoubleValue(MagneticY);
			me.dataOut.Magnetometer_Z.setDoubleValue(MagneticZ);
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
