#
# Farmin GRS77
#


var GRS77 {
    new: func(module=0,GMU44=0,GDC74=0,GIA63_0=0,GIA63_1=1)
    {
    var m = { parents: [GRS77] };
		m.module = module;
    m.dataOut = {};
    m.dataIn  = {};
    root = props.globals.getNode('/Farmin/GRS77['~module~']/', create=1);
		root.initNode('Attitude',0,'DOUBLE');
		root.initNode('ROT',0,'DOUBLE');
    root.initNode('SlipSkid',0,'DOUBLE');
    root.initNode('Pitch',0,'DOUBLE');
    root.initNode('serviceable', 1, "BOOL");
		root.initNode('operable', 0, "BOOL");

    

    #m.smooth = smooth.new(30);
		return m;
    },
    update: func()
    {
      #
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
      var power = me.service.operable.getValue();
      var serviceable = me.service.serviceable.getValue();
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
        me.offLine();
    },
};
