#
#  GDC47A
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
constants.INHG_TO_PA                = 3386.388640341;
constants.rho0_kg_p_m3              = 1.225;
constants.p0_Pa                     = 101325.0;
constants.MPS_TO_KT                 = 1.9438444924406046432;
constants.RESPONSIVENESS            = 50.0;
constants.T0_K                      = 288.15;   # K (=15degC)
constants.gamma                     = 1.4;
constants.R_m2_p_s2_p_K             = 287.05;
MPS_TO_KT                           = 1.9438444924406046432;


var GDC47A {
    new: func(module=0, static=0,pitot=0)
    {
        var m = { parents: [GDC47A] };
        var dataOut = {};
        dataOut.root = props.globals.getNode('/systems/GDC47A['~module~']/');
        # Outside Temperature
        dataOut.root.initNode('OATC',0,'DOUBLE');
        dataOut.root.initNode('OATF',0,'DOUBLE');
        # Airspeed
        dataOut.root.initNode('indicated-speed-kt',0,'DOUBLE');
        dataOut.root.initNode('true-speed-kt',0,'DOUBLE');
        dataOut.root.initNode('indicated-mach',0,'DOUBLE');

        # Altimeter
        dataOut.root.initNode('indicated-altitude-ft',0,'DOUBLE');
        dataOut.root.initNode('mode-c-alt-ft',0,'DOUBLE');
        #dataOut.root.initNode('mode-s-alt-ft',0,'DOUBLE'); #disable for GDC74A
        dataOut.root.initNode('pressure-alt-ft',0,'DOUBLE');
        dataOut.root.initNode('setting-hpa',0,'DOUBLE');
        dataOut.root.initNode('setting-inhg',0,'DOUBLE');

        # system
        dataOut.root.initNode('serviceable', 1, "BOOL");
        dataOut.root.initNode('operable', 0, "BOOL");

        var Airspeed_node = {};
        Airspeed_node.IASkt = dataOut.root.getNode('indicated-speed-kt');
        Airspeed_node.TASkt = dataOut.root.getNode('true-speed-kt');
        Airspeed_node.IMN = dataOut.root.getNode('indicated-mach');
        dataOut.Airspeed = Airspeed_node;

        var Altimeter_node = {};
        Altimeter_node.indAlt = dataOut.root.getNode('indicated-altitude-ft');
        Altimeter_node.CAlt = dataOut.root.getNode('mode-c-alt-ft');
        #Altimeter_node.SAlt = dataOut.root.getNode('mode-s-alt-ft'); #disable for GDC74A
        Altimeter_node.PressAlt = dataOut.root.getNode('pressure-alt-ft');
        dataOut.Altimeter = Altimeter_node;



        m.dataOut = dataOut;

        data = {};
        data.pt                       = 0;
        data.p                        = 0;
        data.qc                       = 0;
        data.static_temperature_C     = 0;
        data.PressAlt                 = 0;
        data.kollsmanInhg             = 0;
        data.dt                       = 0;
        m.data = data;

        var dataIn = [];
        dataIn._total_pressure          = props.globals.getNode('/systems/pitot['~pitot~']/measured-total-pressure-inhg');
        dataIn._static_pressure         = props.globals.getNode('/systems/static['~static~']/pressure-inhg');
        dataIn._static_temperature_C    = props.globals.getNode('/environment/temperature-degc');
        dataIn._density_node            = props.globals.getNode('/environment/density-slugft3');
        dataIn.setHpa                   = dataOut.root.getNode('setting-hpa');
        dataIn.setInhg                  = dataOut.root.getNode('setting-inhg');
        dataIn.dt                       = props.globals.getNode('/sim/time/delta-sec').getValue();
        m.dataIn = dataIn;

        airspeed_internal = {};
        airspeed_internal.currendSpeed = 0;
        m.airspeed_internal = airspeed_internal;

        return m;
    },

    update_loop: func()
    {
        #getdata
        me.dt   = me.dataIn.dt.getValue()
        pt      = me.dataIn._total_pressure.getValue();
        p       = me.dataIn._static_pressure.getValue();
        static_temperature_C = me.dataIn._static_temperature_C.getValue();

        var update_static   = 0;
        var update_pitot    = 0;
        var update_temp     = 0;
        d = me.data;
        if(pt == d.pt)
        {
            m.data.pt == pt;
            update_pitot    = 1;
        }
        if(p == d.p)
        {
            me.data.p == p;
            update_static   = 1;
        }
        if(static_temperature_C == d.static_temperature_C)
        {
            me.data.static_temperature_C = static_temperature_C;
            update_temp     = 1;
        }

        if(update_static or update_pitot or static_temperature_C) update_speed();
        if(update_static) update_Alt();
        if(update_static or static_temperature_C) update_Vspeed();

        settimer(func { me.update_loop(); }, 0.02);
    },

    update_speed: func()
    {
        # nasal port of airspeed_
        me.dt   = me.data.dt
        var p   = me.data.p;
        var pt  = me.data.pt;
        var qc = ( pt - p ) * constants.INHG_TO_PA;
        var qc = math.max(qc , 0.0);
        var v_cal = math.sqrt( 7 * constants.p0_Pa/constants.rho0_kg_p_m3 * ( math.pow( 1 + qc/constants.p0_Pa  , 1/3.5 )  -1 ) );
        var last_speed_kt = me.airspeed_internal.currendSpeed;
        var current_speed_kt = v_cal * constants.MPS_TO_KT;
        var filtered_speed = fgGetLowPass(last_speed_kt,current_speed_kt, dt * RESPONSIVENESS);

        me.dataOut.dataOut.Airspeed.IASkt.setDoubleValue(filtered_speed);
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
        var rho = me.dataIn._density_node.getValue() * SLUGFT3_TO_KGPM3;
        rho = math.max(rho, 0.001);

        pt = math.math(pt, p);
        var V_true = math.sqrt( 7 * p/rho * (math.pow( 1 + (pt-p)/p , 0.2857142857142857 ) -1 ));
        var mach = V_true / c;
        me.dataOut.dataOut.Airspeed.TASkt.setDoubleValue(mach);
        me.dataOut.dataOut.Airspeed.IMN.setDoubleValue(V_true * MPS_TO_KT);
    },

    update_Alt: func()
    {
        var tau = 0.01;
        var trat = tau > 0 ? me.dt/tau : 100;
        p = me.p;
        raw_pa = (1-math.pow(p/29.9212553471122, 0.190284)) * 145366.45;
        dataOut.Altimeter.CAlt.setDoubleValue(100* math.round(raw_pa/100));
        #dataOut.Altimeter.SAlt.setDoubleValue(10* math.round(raw_pa/10));
        press_alt = raw_pa;
        me.dataOut.pressure-alt-ft.setDoubleValue(press_alt);
        me.dataOut.indAlt.setDoubleValue(press_alt - me.kollsman)
    },


    update_Vspeed: func()
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
