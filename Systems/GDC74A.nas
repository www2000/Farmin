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
RESPONSIVENESS                      = 50.0;


var GDC47A {
    new: func(module=0, static=0,pitot=0)
    {
        var m = { parents: [GDC47A] };

        var DataOut = {};
        DataOut.root = props.globals.('/systems/GDC47A['~module~']/');
        DataOut.root.initNode('OATC',0,'DOUBLE');
        DataOut.root.initNode('OATF',0,'DOUBLE');
        DataOut.root.initNode('indicated-speed-kt',0,'DOUBLE');
        DataOut.root.initNode('true-speed-kt',0,'DOUBLE');
        DataOut..rootinitNode('indicated-mach',0,'DOUBLE');

        DataOut.root.initNode('serviceable', 1, "BOOL");
        DataOut.root.initNode('operable', 0, "BOOL");

        data = {};
        data.pt                       = 0;
        data.p                        = 0;
        data.qc                       = 0;
        data.static_temperature_C     = 0;
        m.data = data;

        m.DataOut = DataOut;
        var dataIn = [];
        dataIn._total_pressure = props.globals.('/systems/pitot['~pitot~']/measured-total-pressure-inhg');
        dataIn._static_pressure = props.globals.('/systems/static['~static~']/pressure-inhg');
        dataIn._static_temperature_C = props.globals.('/environment/temperature-degc');
        m.dataIn = dataIn;

        airspeed_internal = {};
        airspeed_internal.lastupdate = props.globals.('/sim/time/').getValue();
        airspeed_internal.currendSpeed = 0;
        m.airspeed_internal = airspeed_internal;
        return m;
    },

    update_loop: func()
    {
        #getdata
        pt = me.dataIn._total_pressure.getValue();
        p = me.dataIn._static_pressure.getValue();
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

        if(update_static or update_pitot) update_speed();
        if(update_static) update_Alt();
        if(update_static or static_temperature_C) update_Vspeed();

        settimer(func { me.update_loop(); }, 0.02);
    },

    update_speed: func()
    {
        # nasal port of airspeed_
        current_time = node.globals.
        var p   = me.data.p;
        var pt  = me.data.pt;
        var qc = ( pt - p ) * INHG_TO_PA;
        var qc = math.max(qc , 0.0);
        var v_cal = math.sqrt( 7 * constants.p0_Pa/constants.rho0_kg_p_m3 * ( math.pow( 1 + qc/constants.p0_Pa  , 1/3.5 )  -1 ) );
        var last_speed_kt = me.airspeed_internal.currendSpeed;
        var current_speed_kt = v_cal * constants.MPS_TO_KT;
        var fgGetLowPass(last_speed_kt,current_speed_kt, dt * RESPONSIVENESS);
        me.
    },

    update_Alt: func()
    {
        #
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
