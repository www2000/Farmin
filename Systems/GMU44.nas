#
#	Farmin GMU44
#
#

var noiseGenerator = func()
{
	return (rand() - rand() + rand() - rand()) /2;;
};

var smooth = {
	new: func(samplesSize)
	{
		var m = { parents: [smooth]};
		m.samplesSize = samplesSize;
		m.reset();
		m.dataLowerbound  = (samplesSize*15)/100;
		m.dataUppeerbound = samplesSize - m.dataLowerbound;
		return m
	},
	smooth: func(rawIn)
	{
		var samples = subvec(me.samples,1);
		samples = append(samples,rawIn);
		me.samples = samples;
		var sortsamples = sort(samples,me.sort_rules);
		sortsamples = subvec(sortsamples,me.dataLowerbound,me.dataUppeerbound);
		var k = size(sortsamples);
		var total = 0;
		foreach(j; sortsamples)
		{
			total += j;
		}
		return total/k;
	},
	sort_rules: func(a, b){
		if(a < b){
			return -1;
		}elsif(a == b){
			return 0;
		}else{
			return 1;
		}
	},
	reset: func()
	{
		me.samples = setsize([], me.samplesSize);
		var key = 0;
		foreach(i;me.samples)
		{
			me.samples[key] = 0;
			key+=1;
		}
	}
};

var GMU44 = {
	new: func(module=0)
	{
		var m = { parents: [GMU44] };
		m.module = module;
		props.globals.initNode('/systems/GMU44['~m.module~']/heading',0,'DOUBLE');
		props.globals.initNode('/systems/GMU44['~m.module~']/serviceable', 1, "BOOL");
		props.globals.initNode('/systems/GMU44['~m.module~']/operable', 0, "BOOL");
		m.smooth = smooth.new(30);
		return m;
	},
	update: func()
	{
		print('run');
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
			settimer(func { me.watchdog() }, 0.05);
		}
		else
		{
			settimer(func { me.update() },0.05);
		}
	},
	watchdog: func()
	{
		print('watchdog');
		var power = getprop('/systems/GMU44['~me.module~']/operable');
		var serviceable = getprop('/systems/GMU44['~me.module~']/serviceable');
		if(power == 1 and serviceable == 1)
		{
			settimer(func { me.update() }, 5*rand());
		}
		else
		{
			settimer(func { me.watchdog()}, 1);
		};

	},
	run: func()
	{
		print('run');
		thread.newthread(func { me.watchdog() })
	},
};
#test delete in the further.
test = GMU44.new(0);
test.run();

test2 = GMU44.new(1);
test2.run();
