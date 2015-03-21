screen1 = {};
var GDU104XINIT = {
    new: func(screenID,mode)
    {
        var m = { parents:[  GDU104XINIT   ] };
        m.canvas = canvas.new({
                "name": "screen"~screenID,
                "size": [1024, 1024],
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
    screen1.PFD.updateSpeed(ias);
    pitch = getprop("orientation/pitch-deg");
    roll = getprop("orientation/roll-deg");
    screen1.PFD.updateAi(roll,pitch);
    settimer(func updater(), 0.05);
};

setlistener("/nasal/canvas/loaded", func{
    screen1 = GDU104XINIT.new(1,'PFD');
    updater();

},1);
