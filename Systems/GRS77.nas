#
# Farmin GRS77
#


var GRS77 {
    var GyroMeasError = math.pi * (40.0f / 180.0f)     # gyroscope measurement error in rads/s (shown as 3 deg/s)
    var GyroMeasDrift = math.pi * (0.0f / 180.0f)      # gyroscope measurement drift in rad/s/s (shown as 0.0 deg/s/s)

    var beta = math.sqrt(3.0 / 4.0) * GyroMeasError;
    var zeta = math.sqrt(3.0 / 4.0) * GyroMeasDrift;
    var Kp 2.0 * 5.0;
    var Ki 0.0;

    var deltat = 0.0;
    var lastUpdate = 0;
    var now = 0;

    var  a1 = 0;
    var  a2 = 0;
    var  a3 = 0;
    var  g1 = 0;
    var  g2 = 0;
    var  g3 = 0;
    var  m1 = 0;
    var  m2 = 0;
    var  m3 = 0;

    var mcount = 0;
    var MagRate = 0;

    var  ax = 0.0;
    var  ay = 0.0;
    var  az = 0.0;
    var  gx = 0.0;
    var  gy = 0.0;
    var  gz = 0.0;
    var  mx = 0.0;
    var  my = 0.0;
    var  mz = 0.0;

    var q = {1.0, 0.0, 0.0, 0.0};
    var eInt  = {0.0, 0.0, 0.0};

    var Xh      = 0.0;
    var Yh      = 0.0;
    var heading = 0.0;

    var altitude    = 0.0;
    var temp1       = 0.0;
    var temp2       = 0.0;
    var temperature = 0.0;
    var humidity    = 0.0;

    new: func(module=0,GMU44=0,GDC74=0,GIA63_0=0,GIA63_1=1)
    {
    var m = { parents: [GRS77] };
		m.module = module;
    dataOut = {};
    dataIn  = {};
    service = {};
    root = props.globals.getNode('/Farmin/GRS77['~module~']/', create=1);
    service['serviceable'] = root.initNode('serviceable', 1, "BOOL");
		service['operable'] = root.initNode('operable', 0, "BOOL");
    var m.service = service;
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
