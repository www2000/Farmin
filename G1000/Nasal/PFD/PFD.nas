var PFD = {
	new: func(canvas_group)
	{
		var m = { parents: [PFD] };
		m.data = {};
		var pfd = canvas_group;
		var font_mapper = func(family, weight)
		{
			if( family == "Liberation Sans" and weight == "normal" )
				return "LiberationFonts/LiberationSans-Regular.ttf";
			elsif( family == "Sans" and weight == "normal" )
				return "LiberationFonts/LiberationSans-Regular.ttf";
			elsif( family == "BoeingCDULarge" and weight == "normal" )
				return "BoeingCDU-Large.ttf";

		};
		canvas.parsesvg(pfd, "Aircraft/Instruments-3d/Farmin/G1000/Pages/PFD/PFD.svg", {'font-mapper': font_mapper});
		var Speed = {};
		var svg_keys = ["LindSpeed","SpeedNonLint","SpeedLastDigitLint", "Horizon"];
		foreach(var key; svg_keys) {
			m[key] = {};
			m[key].Element	= pfd.getElementById(key);
			m[key].Element.updateCenter();
			m[key].roll		= m[key].Element.createTransform();
			m[key].pitch 	= m[key].Element.createTransform();
		};
		#5,715272637
		return m
	},

	updateAi: func(Roll,Pitch){
		me.Horizon.roll.setRotation(-Roll*D2R, me.Horizon.Element.getCenter());
		me.Horizon.pitch.setTranslation(0,Pitch*10.5);
	},

	updateSpeed: func(speed)
	{
		me.data.speed = speed;
		mo = math.mod(math.floor(speed),10);
		me.SpeedLastDigitLint.Element.setText(sprintf("%1.0f",mo));
		me.SpeedNonLint.Element.setText(sprintf("%2.0f",math.floor(speed/10)));
		me.LindSpeed.Element.setTranslation(0,speed*5.71225);
	},
	#updateSpeedTrend: func(Speedtrent)
	#{
	#	me.data.speedTrent;
	#},

#	updateAlt(alt)
#	{
#
#	},
};
