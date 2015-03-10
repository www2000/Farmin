var GMU44 = {
	new: func()
	{
		var m = { parents: [GMU44] };
		m.links = [];
		m.running = 0;
		return m;
	},
	setup: func(link)
	{
		append(me.links,link);
	},
	run: func()
	{
		me.running = 1
		thread.newthread( func me.update() );
	},
	update: func()
	{
		sendData = getprop('/orientation/heading-magnetic-deg');
		foreach(var l; me.links)
		{
			link(sendData);
		}
		if(running)
		{
			settimer(me.update,0);
		}
	},
	shutdown: func()
	{

	},
};

#test data
var foobar = func(data)
{
	print('foobar');
	print(data);
};
compass = GMU44.new();
compass.setup(foobar);
compass.run();
print(tr);
