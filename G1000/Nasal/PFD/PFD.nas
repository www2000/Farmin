var PFD = {
	new: func(canvas_group)
	{
		var m = { parents: [PFD] };
		var data = {};
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
		var svg_keys = ["LindSpeed","SpeedNonLint","SpeedLastDigitLint"];
		foreach(var key; svg_keys) {
			m[key] = {};
			m[key].Element = pfd.getElementById(key);
			m[key].Center = pfd.getElementById(key).updateCenter()
			
		};
		#var svg_keys = ["LindSpeed","SpeedNonLint","SpeedLastDigitLint"];
		#foreach(var key; svg_keys) {
		#	m[key] = pfd.getElementById(key);
		#}
		return m
	},


#	updateSpeed: func(speed)
#	{
#		me.data.speed = speed;
#	},
#	updateSpeedTrend: func(Speedtrent)
#	{
#		me.data.speedTrent;
#	},
#	updateAlt(alt)
#	{
#
#	},
};
