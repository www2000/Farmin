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
            m.PFD = PFD.new(m.croot);
        }elsif(mode == "MFD"){
            #
        }
        return m;
    },
};

var updater = func(){
    ias =getprop("velocities/airspeed-kt");
    pitch = getprop("orientation/pitch-deg");
    roll = getprop("orientation/roll-deg");
    heading = getprop("orientation/heading-deg");
    alt = getprop("instrumentation/altimeter/indicated-altitude-ft");
    slipskid = getprop("instrumentation/slip-skid-ball/indicated-slip-skid");
    VSI = getprop("instrumentation/vertical-speed-indicator/indicated-speed-fpm");
    screen1.PFD.updateAi(roll,pitch);
    screen1.PFD.updateSpeed(ias);
    screen1.PFD.UpdateHeading(heading);
    screen1.PFD.updateAlt(alt);
    screen1.PFD.updateSlipSkid(slipskid);
    screen1.PFD.updateVSI(VSI);
    settimer(func updater(), 0.05);
};

setlistener("/nasal/canvas/loaded", func{
    screen1 = GDU104XINIT.new(1,'PFD');
    updater();

},1);
