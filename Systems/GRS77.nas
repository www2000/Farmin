#
# Farmin GRS77
#


var GRS77 {
    new: func(module=0)
    {
        var m = { parents: [GRS77] };
		m.module = module;
        root = props.globals.initNode('/Farmin/GRS77['~m.module~']')
		root.initNode('Attitude',0,'DOUBLE');
		root.initNode('ROT',0,'DOUBLE');
        root.globals.initNode('/SlipSkid',0,'DOUBLE');
        root.globals.initNode('Pitch',0,'DOUBLE');
        root.globals.initNode('serviceable', 1, "BOOL");
		root.globals.initNode('operable', 0, "BOOL");
		m.smooth = smooth.new(30);
		return m;
    },
    update: func()
    {
        #
    },
    watchdog: func()
    {
        #
    },
    offLine: func()
    {
        #
    },
    run: func()
    {
        #
    },
};
