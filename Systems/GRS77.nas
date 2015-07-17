#
# Farmin GRS77
#


var GRS77 {
    new: func(module=0)
    {
        var m = { parents: [GRS77] };
		m.module = module;
		props.globals.initNode('/systems/GRS77['~m.module~']/OAT',0,'DOUBLE');
		props.globals.initNode('/systems/GRS77['~m.module~']/OAT',0,'DOUBLE');
        props.globals.initNode('/systems/GRS77['~m.module~']/OAT',0,'DOUBLE');
        props.globals.initNode('/systems/GRS77['~m.module~']/OAT',0,'DOUBLE');
        props.globals.initNode('/systems/GRS77['~m.module~']/OAT',0,'DOUBLE');
        props.globals.initNode('/systems/GRS77['~m.module~']/serviceable', 1, "BOOL");
		props.globals.initNode('/systems/GRS77['~m.module~']/operable', 0, "BOOL");
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
