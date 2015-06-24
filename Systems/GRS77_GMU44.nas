#
#	Farmin GRS77/GMU44
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
		samples = subvec(me.samples,1);
		samples = append(samples,rawIn);
		me.samples = samples;
		sortsamples = sort(samples,me.sort_rules);
		sortsamples = subvec(sortsamples,me.dataLowerbound,me.dataUppeerbound);
		k = size(sortsamples);
		total = 0;
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
		key = 0;
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
		props.globals.initNode('/instrumentation/GMU44['~m.module~']/heading',0,'DOUBLE');
		props.globals.initNode('/instrumentation/GMU44['~m.module~']/headingRaw',0,'DOUBLE');
		props.globals.initNode('/instrumentation/GMU44['~m.module~']/serviceable', 1, "BOOL");
		props.globals.initNode('/instrumentation/GMU44['~m.module~']/operable', 0, "BOOL");
		m.smooth = smooth.new(30);
		return m;
	},
	update: func()
	{
		print('run');
		sensordata = getprop("/orientation/heading-magnetic-deg");
		rawdata = sensordata + (0.2*noiseGenerator());
		if (rawdata < 0.0 )
		{
			rawdata = rawdata + 360.0;
		}
		elsif(rawdata > 360.0)
		{
			rawdata = rawdata = 360.0;
		};
		heading = me.smooth.smooth(rawdata);
		setprop('/instrumentation/GMU44['~me.module~']/heading',heading);
		setprop('/instrumentation/GMU44['~me.module~']/headingRaw',rawdata);

		power = getprop('/instrumentation/GMU44[' ~ me.module ~ ']/operable');
		serviceable = getprop('/instrumentation/GMU44[' ~ me.module ~ ']/serviceable');
		if(power == 0 or serviceable == 0)
		{
			setprop('/instrumentation/GMU44['~me.module~']/heading', 0);
			settimer(func { me.watchdog() }, 0.01);
		}
		else
		{
			settimer(func { me.update() },0.04);
		}
	},
	watchdog: func()
	{
		print('watchdog');
		power = getprop('/instrumentation/GMU44['~me.module~']/operable');
		serviceable = getprop('/instrumentation/GMU44['~me.module~']/serviceable');
		if(power == 1 and serviceable == 1)
		{
			settimer(func { me.update() }, rand()*5);
		}
		else
		{
			settimer(func { me.watchdog()}, 1);
		}

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
