#
# smooth
#
#
#

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
