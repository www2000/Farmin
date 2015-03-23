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
		var svg_keys = ["LindSpeed","SpeedNonLint","SpeedLastDigitLint", "Horizon","bankPointer","bankPointerLineL", "bankPointerLineR","Compass","AltNonLintBig","AltNonLintSmall","AltLint","SlipSkid","CompassText"];
		foreach(var key; svg_keys) {
			print(key);
			m[key] = {};
			m[key].Element	= pfd.getElementById(key);
			m[key].Element.updateCenter();
			m[key].roll		= m[key].Element.createTransform();
			m[key].pitch 	= m[key].Element.createTransform();
		};
		#5,715272637

		#clip
		m.bankPointerLineL.Element.set("clip", "rect(0,1024,768,459.500)"); #459,500
		m.bankPointerLineR.Element.set("clip", "rect(0,459.500,768,0)"); #459,500
		return m
	},

	updateAi: func(Roll,Pitch){
		RollR = -Roll*D2R;
		me.Horizon.roll.setRotation(RollR, me.Horizon.Element.getCenter());
		me.Horizon.roll.setRotation(RollR, me.Horizon.Element.getCenter());

		Bpc = me.bankPointer.Element.getCenter();
		me.bankPointer.roll.setRotation(RollR, Bpc);
		me.bankPointerLineL.roll.setRotation(RollR, Bpc);
		me.bankPointerLineR.roll.setRotation(RollR, Bpc);

		me.Horizon.pitch.setTranslation(0,Pitch*10.5);
	},

	UpdateHeading: func(Heading)
	{
		me.Compass.Element.setRotation(-Heading*D2R);
		me.CompassText.Element.setText(sprintf("%03.0f°",math.floor(Heading)));
	},

	updateSpeed: func(speed)
	{
		me.data.speed = speed;

		if (speed > 20)
		{
			me.SpeedNonLint.Element.setText(sprintf("%2.0f",math.floor(speed/10)));
			SpLd = math.mod(math.floor(speed),10);
			me.SpeedLastDigitLint.Element.setText(sprintf("%1.0f",SpLd));
			me.LindSpeed.Element.setTranslation(0,speed*5.71225);
		}else{
			me.SpeedNonLint.Element.setText("---");
			me.SpeedLastDigitLint.Element.setText('');
			me.LindSpeed.Element.setTranslation(0,114,245);
			me.LindSpeed.Element.set("clip", "rect(114px, 239px, 455px, 154px)");
		};

		if (speed < 20)
		{
			me.LindSpeed.Element.set("clip", "rect(114px, 239px, 284,5px, 154px)");
		}
		elsif (speed > 20 and  speed < 50)
		{
			me.LindSpeed.Element.set("clip", sprintf("rect(114px, 239px, %1.0fpx, 154px)", math.floor(284.5 + ((speed-20) * 5.71225) ) ) );
		}
		else
		{
			me.LindSpeed.Element.set("clip", "rect(114px, 239px, 455px, 154px)");
		};
	},
	updateSpeedTrend: func(Speedtrent)
	{
		me.data.speedTrent;

	},
	updateSlipSkid: func(slipskid){
		me.SlipSkid.Element.setTranslation(slipskid*5.73,0);
	},



	updateAlt: func(alt)
	{
		if(alt !=nil)
		{
			if (alt < 0 )
			{
				altf = math.floor(-alt);
			}else{
				altf = math.floor(alt);
			}
			alt3 = math.mod(altf,100);
			me.AltLint.Element.setText(sprintf("%02d",alt3));
			alt2 = (math.mod(altf,1000)-alt3)/100;
			me.AltNonLintSmall.Element.setText(sprintf("%1d",alt2));
			alt1 = (alt - math.mod(altf,1000))/1000;
			me.AltNonLintBig.Element.setText(sprintf("%02d",alt1));
		}
	},
};
