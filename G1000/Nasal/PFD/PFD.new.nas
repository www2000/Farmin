var PFD = {

    new: func(canvas_group)
    {

        var m = {parents:[PFD]}

        #setup data
        var data = {};
        data.Pitch      = 0;
        data.Roll       = 0;
        data.Heading    = 0;
        data.AirSpeed   = 0;
        data.Slipskid   = 0;
        data.Alt        = 0;
        data.VSI        = 0;
        data.marker     = 0;
        data.speedtrent = 0;


        m.data = data;

        # setup Canvas
        var pfd = canvas_group;
        var font_mapper = func(family, weight)
		{
			if( family == "Liberation Sans" and weight == "normal" )
				return "LiberationFonts/LiberationSans-Regular.ttf";
			elsif( family == "Sans" and weight == "normal" )
				return "LiberationFonts/LiberationSans-Regular.ttf";
			elsif( family == "BoeingCDULarge" and weight == "normal" )
				return "LiberationFonts/LiberationSans-Regular.ttf";
		};

        canvas.parsesvg(pfd, "Aircraft/Instruments-3d/Farmin/G1000/Pages/PFD/PFD.svg", {'font-mapper': font_mapper});



        m.screen = {};


    },

    UpdateAirSpeed: func(AirSpeed){
        me.data.AirSpeed = AirSpeed;
    },
    UpdateAlt: func(Alt){
        me.data.Alt = Alt;
    },
    UpdateAI: func(){
        me.data.Pitch = Pitch;
        me.data.Roll = Roll;
    },
    UpdateHeading: func(){
        me.data.Heading = heading;
    },
    UpdateSlipSkid: func(SlipSkid){
        me.data.Slipskid = SlipSkid;
    },
    UpdateVSI: func(VSI){
        me.data.VSI = VSI;
    },
    UpdateVOR1: func(){
      me.VOR.
    }
    UpdateADF: func(){

    }
    UpdateMarkers: func(){

    }


}
