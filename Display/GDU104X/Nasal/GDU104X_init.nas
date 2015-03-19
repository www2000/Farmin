
io.load_nasal(getprop("/sim/fg-root") ~ "Aircraft/Instruments3d/Farmin/Display/GDU104X/Nasal/PFD/PFD.nas", "PFD");
var GDU104X_INIT = func(ScreenID,mode)
{
    m.canvas = canvas.new({
      "name": "PFD-Test",
      "size": [1024, 1024],
      "view": [1024, 768],
      "mipmapping": 1
    });

    # ... and place it on the object called PFD-Screen
    m.canvas.addPlacement({"node": "Screen", "parent":"screen"~screenID});
    m.canvas.setColorBackground(0.12,0.20,0.16);
    if(mode == "PFD"){

    }elsif(mode == "MFD"){

    }
    return root;
};


setlistener("/nasal/canvas/loaded", func{

},1)
