#
#	Farmin GMU44
#
#


var GMU44 = {
	new: func(module=0)
	{
		var m = { parents: [GMU44] };
		m.module = module;
		.initNode('/systems/GMU44['~m.module~']/heading',0,'DOUBLE');
		.initNode('/systems/GMU44['~m.module~']/serviceable', 1, "BOOL");
		.initNode('/systems/GMU44['~m.module~']/operable', 0, "BOOL");
		m.smooth = smooth.new(30);
		return m;
	},
	update: func()
	{
		var sensordata = getprop("/orientation/heading-magnetic-deg");
		var rawdata = sensordata + (0.2*noiseGenerator());
		if (rawdata < 0.0 )
		{
			rawdata = rawdata + 360.0;
		}
		elsif(rawdata > 360.0)
		{
			rawdata = rawdata = 360.0;
		};
		var heading = me.smooth.smooth(rawdata);
		setprop('/systems/GMU44['~me.module~']/heading',heading);

		var power = getprop('/systems/GMU44[' ~ me.module ~ ']/operable');
		var serviceable = getprop('/systems/GMU44[' ~ me.module ~ ']/serviceable');
		if(power == 0 or serviceable == 0)
		{
			setprop('/systems/GMU44['~me.module~']/heading', 0);
			settimer(func { me.offLine() }, 0.05);
		}
		else
		{
			settimer(func { me.update() },0.05);
		}
	},
	offLine: func()
	{
		var power = getprop('/systems/GMU44['~me.module~']/operable');
		var serviceable = getprop('/systems/GMU44['~me.module~']/serviceable');
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
		print('run');
		thread.newthread(func { me.offLine() })
	},
};
#test delete in the further.
test = GMU44.new(0);
test.run();

test2 = GMU44.new(1);
test2.run();
