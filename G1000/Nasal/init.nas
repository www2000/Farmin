screen1 = {};
var GDU104XINIT = {
    new: func(screenID,mode)
    {
        var m = { parents:[  GDU104XINIT   ] };
        m.canvas = canvas.new({
                "name": "screen"~screenID,
                "size": [1024, 768],
                "view": [1024, 768],
                "mipmapping": 1
        });
        m.canvas.addPlacement({"node": "Screen", "parent":"screen"~screenID});
        #m.canvas.setColorBackground(0.12,0.20,0.16);
        m.canvas.setColorBackground(1,1,1);
        m.croot = m.canvas.createGroup();

        if(mode == "PFD"){
            m.PFD = {};
            m.top = m.canvas.createGroup();
            m.PFD = PFD.new(m.croot);
        }elsif(mode == "MFD"){
            #
        };
        var font_mapper = func(family, weight)
		{
			if( family == "Liberation Sans" and weight == "normal" )
				return "LiberationFonts/LiberationSans-Regular.ttf";
            #elsif( family == "Liberation Sans Narrow" and weight == "normal" )
    		#	return "LiberationFonts/LiberationSansNarrow-Regular.ttf";
			elsif( family == "Sans" and weight == "normal" )
				return "LiberationFonts/LiberationSans-Regular.ttf";
			elsif( family == "BoeingCDULarge" and weight == "normal" )
				return "LiberationFonts/LiberationSans-Regular.ttf";

		};
        #m.top = {};
        canvas.parsesvg(m.top, "Aircraft/Instruments-3d/Farmin/G1000/Pages/top.svg", {'font-mapper': font_mapper});
        return m;
    },
};

var updater = func(){
    ias =getprop("velocities/airspeed-kt") or 0.00;
    pitch = getprop("orientation/pitch-deg")  or 0.00;
    roll = getprop("orientation/roll-deg")  or 0.00;
    heading = getprop("orientation/heading-deg")  or 0.00;
    alt = getprop("instrumentation/altimeter/indicated-altitude-ft")  or 0.00;
    slipskid = getprop("instrumentation/slip-skid-ball/indicated-slip-skid")  or 0.00;
    VSI = getprop("instrumentation/vertical-speed-indicator/indicated-speed-fpm")  or 0.00;
    ILS = getprop("instrumentation/nav/gs-needle-deflection-norm")  or 0.00;
    screen1.PFD.updateAi(roll,pitch);
    screen1.PFD.updateSpeed(ias);
    screen1.PFD.UpdateHeading(heading);
    screen1.PFD.updateAlt(alt);
    screen1.PFD.updateSlipSkid(slipskid);
    screen1.PFD.updateVSI(VSI);
    screen1.PFD.updateILS(ILS);
    settimer(func updater(), 0.05);
};

var updaterSlow = func()
{
    if(getprop("instrumentation/marker-beacon/outer"))
    {
        screen1.PFD.updateMarkers(1);
    }
    elsif(getprop("instrumentation/marker-beacon/middle"))
    {
        screen1.PFD.updateMarkers(2);
    }
    elsif(getprop("instrumentation/marker-beacon/inner"))
    {
        screen1.PFD.updateMarkers(3);
    }
    else
    {
        screen1.PFD.updateMarkers(0);
    }
    settimer(func updaterSlow(), 0.5);
}

setlistener("/nasal/canvas/loaded", func{
    screen1 = GDU104XINIT.new(1,'PFD');
    updater();
    thread.newthread(updaterSlow);

},1);
