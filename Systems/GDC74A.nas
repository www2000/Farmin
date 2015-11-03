#
#  GDC74A
#
# Spec
# Aircraft Pressure Altitude Range -1400 feed to 50000 feet
# Aircraft Vertical Speed Range  -20000 feet/min to 20000 feet/min
# Aircraft Airspeed Range 450K nots
# Aircraft Mach Range <1.00 Mach
# Aircraft TAT Temperature Range -85°C to +85°C
# Unit Operating Temperature Range -55°C to +70°C
# Power Requirments
# +70°C  27.5Vdc 200 mA, 13.8Vdc 410mA
# +25°C  27.5Vdc 200 mA, 13.8Vdc 410mA
# -55°C  27.5Vdc 235 mA, 13.8Vdc 480mA
constants   = {};
constants.rho0_kg_p_m3              = 1.225;
constants.p0_Pa                     = 101325.0;
constants.MPS_TO_KT                 = 1.9438444924406046432;
constants.RESPONSIVENESS            = 50.0;
constants.T0_K                      = 288.15;   # K (=15degC)
constants.gamma                     = 1.4;
constants.R_m2_p_s2_p_K             = 287.05;
constants.MPS_TO_KT                 = 1.9438444924406046432;
constants.PA_TO_INHG                = 0.0002952998330101010;
constants.INHG_TO_PA                = 3386.388640341;
constants.SLUGFT3_TO_KGPM3          = 515.379;


var GDC47A = {
    new: func(module=0, static=0,pitot=0)
    {
        var m = { parents: [GDC47A] };
        var data                = {};
        var dataOut             = {};
        var Airspeed_node       = {};
        var Altimeter_node      = {};
        var Vspeed_node         = {};
        var dataIn              = {};
        var airspeed_internal   = {};
        var service             = {};

        root = props.globals.getNode('/Farmin/GDC74['~module~']/', create=1);

        # system
        service.serviceable     = root.initNode('serviceable', 1, "BOOL");
        service.operable        = root.initNode('operable', 0, "BOOL");

        # Outside Temperature
        dataOut.OATC            = root.initNode('OATC',0,'DOUBLE');
        dataOut.OATF            = root.initNode('OATF',0,'DOUBLE');

        # Airspeed
        Airspeed_node.IASkt     = root.initNode('indicated-speed-kt',0,'DOUBLE');
        Airspeed_node.TASkt     = root.initNode('true-speed-kt',0,'DOUBLE');
        Airspeed_node.IMN       = root.initNode('indicated-mach',0,'DOUBLE');

        # Altimeter
        Altimeter_node.indAlt   = root.initNode('indicated-altitude-ft',0,'DOUBLE');
        Altimeter_node.CAlt     = root.initNode('mode-c-alt-ft',0,'DOUBLE');
        #Altimeter_node.SAlt     = root.initNode('mode-s-alt-ft',0,'DOUBLE'); #disable for GDC74A
        Altimeter_node.PressAlt = root.initNode('pressure-alt-ft',0,'DOUBLE');
        dataIn.setHpa           = root.initNode('setting-hpa',1013.25,'DOUBLE');
        dataIn.setInhg          = root.initNode('setting-inhg',0,'DOUBLE');

        # Vertical Speed
        Vspeed_node.fpm         = root.initNode('indicated-speed-fpm',0,'DOUBLE');
        Vspeed_node.kts         = root.initNode('indicated-speed-kts',0,'DOUBLE');
        Vspeed_node.mps         = root.initNode('indicated-speed-mps',0,'DOUBLE');

        # system
        root.initNode('serviceable', 1, "BOOL");
        root.initNode('operable', 0, "BOOL");

        dataIn._total_pressure          = props.globals.getNode('/systems/pitot['~pitot~']/measured-total-pressure-inhg');
        dataIn._static_pressure         = props.globals.getNode('/systems/static['~static~']/pressure-inhg');
        dataIn._static_temperature_C    = props.globals.getNode('/environment/temperature-degc');
        dataIn._density_node            = props.globals.getNode('/environment/density-slugft3');

        # internel variabels
        data.pt                         = 0;
        data.p                          = 0;
        data.qc                         = 0;
        data.static_temperature_C       = 0;
        data.PressAlt                   = 0;
        data.kollsmanHpa                = 0;
        data.kollsmanInhg               = 0;
        data.kollsman_alt               = 0;
        data.dt                         = 0;
        data.current_alt                = 0;
        data.LastVSfpm                  = 0;
        data.lastUpdate                 = systime();
        airspeed_internal.currendSpeed  = 0;

        dataOut.Airspeed = Airspeed_node;
        dataOut.Altimeter = Altimeter_node;
        dataOut.Vspeed = Vspeed_node;
        m.dataOut = dataOut;
        m.dataIn = dataIn;
        m.data = data;
        dataOut.Airspeed = Airspeed_node;
        m.airspeed_internal = airspeed_internal;
        m.service = service;
        return m;
    },

    update_loop: func()
    {
        #getdata
        var lastUpdate              = systime();
        me.data.dt                  = lastUpdate - me.data.lastUpdate;
        me.data.lastUpdate          = lastUpdate;
        var pt                      = me.dataIn._total_pressure.getValue();
        var p                       = me.dataIn._static_pressure.getValue();
        var static_temperature_C    = me.dataIn._static_temperature_C.getValue();
        var setHpa                  = me.dataIn.setHpa.getValue();
        var setInhg                 = me.dataIn.setInhg.getValue();
        var power                   = me.service.operable.getValue();
		var serviceable             = me.service.serviceable.getValue();
        var update_static           = 0;
        var update_pitot            = 0;
        var update_temp             = 0;
        var update_kollsman         = 0;
        d = me.data;
        if(pt != me.data.pt)
        {
            me.data.pt = pt;
            update_pitot    = 1;
        }
        if(p != me.data.p)
        {
            me.data.p = p;
            update_static   = 1;
        }
        if((setHpa != me.data.kollsmanHpa) or (setInhg != me.data.kollsmanInhg))
        {
            update_kollsman = 1;
        }
        if(static_temperature_C != me.data.static_temperature_C)
        {
            me.data.static_temperature_C = static_temperature_C;
            update_temp = 1;
        }
        if(power == 0 or serviceable == 0)
		{
			settimer(func { me.offLine() }, 0);
		}
		else
		{
            if(update_kollsman) me.update_Kollsman();
            if(update_static or update_pitot or update_temperature) me.update_speed();
            if(update_static or update_kollsman) me.update_Alt();
            if(update_temp) me.update_temp();
            settimer(func { me.update_loop(); }, 0);
		}
    },

    update_temp: func()
    {
        me.dataOut.OATC.setValue(me.data.static_temperature_C);
        me.dataOut.OATF.setValue(C2F(me.data.static_temperature_C));
    },

    update_speed: func()
    {
        # nasal port of airspeed_
        var dt      = me.data.dt;
        var p       = me.data.p;
        var pt      = me.data.pt;
        var qc      = ( pt - p ) * constants.INHG_TO_PA;
        var qc      = math.max(qc , 0.0);
        var v_cal = math.sqrt( 7 * constants.p0_Pa/constants.rho0_kg_p_m3 * ( math.pow( 1 + qc/constants.p0_Pa  , 1/3.5 )  -1 ) );
        var last_speed_kt = me.airspeed_internal.currendSpeed;
        var current_speed_kt = v_cal * constants.MPS_TO_KT;
        me.airspeed_internal.currendSpeed = current_speed_kt;
        var filtered_speed = fgGetLowPass(last_speed_kt,current_speed_kt, dt * 1);

        me.dataOut.Airspeed.IASkt.setDoubleValue(filtered_speed);
        me.update_Mach();
    },

    update_Mach: func()
    {
        var oatK = me.data.static_temperature_C + constants.T0_K - 15;
        oatK = math.max(oatK, 0.001);
        var c = math.sqrt(constants.gamma * constants.R_m2_p_s2_p_K * oatK);
        var p   = me.data.p * constants.INHG_TO_PA;
        var pt  = me.data.pt * constants.INHG_TO_PA;
        p = math.max(p, 0.001);
        var rho = me.dataIn._density_node.getValue() * constants.SLUGFT3_TO_KGPM3;
        rho = math.max(rho, 0.001);
        pt = math.max(pt, p);
        var V_true = math.sqrt( 7 * p/rho * (math.pow( 1 + (pt-p)/p , 0.2857142857142857 ) -1 ));
        var mach = math.max(V_true / c,0);
        me.dataOut.Airspeed.IMN.setDoubleValue(mach);
        me.dataOut.Airspeed.TASkt.setDoubleValue(V_true * constants.MPS_TO_KT);
    },

    update_Kollsman: func()
    {
        setHpa                  = sprintf("%.2f",me.dataIn.setHpa.getValue());
        setInhg                 = sprintf("%.2f",me.dataIn.setInhg.getValue());
        if(setHpa != me.data.kollsmanHpa )
        {
            setInhg = sprintf("%.2f",(constants.PA_TO_INHG*setHpa)*100);
            me.dataIn.setInhg.setValue(setInhg);
        }
        elsif(setInhg != me.data.kollsmanInhg)
        {
            setHpa = sprintf("%.2f",(constants.INHG_TO_PA*setInhg)/100);
            me.dataIn.setHpa.setValue(setHpa);
        }
        p = setInhg;
        me.data.kollsmanInhg    = setInhg;
        me.data.kollsmanHpa     = setHpa;
        me.data.kollsman_alt = (1-math.pow(p/29.9212553471122, 0.190284)) * 145366.45;

    },
    update_Alt: func()
    {
        #var tau = 0.01;
        #var trat = tau > 0 ? me.dt/tau : 100;
        var p = me.data.p;
        var raw_pa = (1-math.pow(p/29.9212553471122, 0.190284)) * 145366.45;
        me.dataOut.Altimeter.CAlt.setDoubleValue(100* math.round(raw_pa/100));
        #me.dataOut.Altimeter.SAlt.setDoubleValue(10* math.round(raw_pa/10));

        dt = me.data.dt;
        VSfpm = fgGetLowPass((raw_pa - me.data.current_alt) * (1/dt) * 60, me.data.LastVSfpm, dt*100);
        me.dataOut.Vspeed.fpm.setDoubleValue(VSfpm);
        me.dataOut.Vspeed.kts.setDoubleValue(VSfpm);
        me.dataOut.Vspeed.mps.setDoubleValue(VSfpm);
        me.data.LastVSfpm = VSfpm;
        press_alt = raw_pa;
        me.dataOut.Altimeter.PressAlt.setDoubleValue(press_alt);
        me.dataOut.Altimeter.indAlt.setDoubleValue(press_alt - me.data.kollsman_alt);
        me.data.current_alt = raw_pa;
    },

    offLine: func()
    {
        var power = me.service.operable.getValue();
		var serviceable = me.service.serviceable.getValue();
		if(power == 1 and serviceable == 1)
		{
			settimer(func { me.update_loop() }, 2);
		}
		else
		{
			settimer(func { me.offLine()}, 1);
		};
    },
    run: func()
    {
        settimer(func { me.offLine() },0.01);
    },
};
var run = func(){
test = GDC47A.new();
test.run();
};
setlistener("/sim/signals/fdm-initialized", run);
