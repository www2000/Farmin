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
				return "LiberationFonts/LiberationSans-Regular.ttf";

		};
		canvas.parsesvg(pfd, "Aircraft/Instruments-3d/Farmin/G1000/Pages/PFD/PFD.svg", {'font-mapper': font_mapper});
		var Speed = {};
		var svg_keys = ["LindSpeed","SpeedNonLint","SpeedLastDigitLint", "Horizon","bankPointer","bankPointerLineL", "bankPointerLineR","Compass","AltNonLintBig","AltNonLintSmall","AltLint","SlipSkid","CompassText","VSI","VSIText","PitchScale","HorizonLine"];
		foreach(var key; svg_keys) {
			print(key);
			m[key] = {};
			m[key].Element	= pfd.getElementById(key);
			m[key].Element.updateCenter();
			m[key].center	= m[key].Element.getCenter();
			m[key].roll		= m[key].Element.createTransform();
			m[key].pitch 	= m[key].Element.createTransform();
		};
		#5,715272637

		#clip

		m.bankPointerLineL.Element.set("clip", "rect(0,1024,768,459.500)");
		m.bankPointerLineR.Element.set("clip", "rect(0,459.500,768,0)");
		m.PitchScale.Element.set("clip", "rect(134,590,394,330)");
		#note to my self clip for the Pitch Scale is: top = 134 right = 590 bottem = 394 left = 330
		return m
	},

	updateAi: func(Roll,Pitch){
		#offset = 392.504021806/2;
		offset = 10;
		#if(Pitch < 1.3962634)
		#{
		#	Pitch = 1.3962634;
		#}
		#elsif (Pitch > -1.3962634)
		#{
		#	Pitch = 1.3962634;
		#};
		RollR = -Roll*D2R;

		Bpc  = me.bankPointer.Element.getCenter();
		me.bankPointer.roll.setRotation(RollR, Bpc);
		me.bankPointerLineL.roll.setRotation(RollR, Bpc);
		me.bankPointerLineR.roll.setRotation(RollR, Bpc);

		me.Horizon.roll.setRotation(RollR, Bpc);
		me.HorizonLine.roll.setRotation(RollR, Bpc);
		me.PitchScale.roll.setRotation(RollR, Bpc);

		print(Bpc);
		if (RollR < 0) #top, right, bottom, left
		{
			me.bankPointerLineL.Element.set("clip", "rect(0,1,1,0)"); #459,500
			me.bankPointerLineR.Element.set("clip", "rect(0,459.500,768,0)");
		}
		elsif (RollR > 0)
		{
			me.bankPointerLineL.Element.set("clip", "rect(0,1024,768,459.500)"); #459,500
			me.bankPointerLineR.Element.set("clip", "rect(0,1,1,0)");
		}
		else
		{
			me.bankPointerLineL.Element.set("clip", "rect(0,1024,768,459.500)"); #459,500
			me.bankPointerLineR.Element.set("clip", "rect(0,459.500,768,0)");
		}
		me.Horizon.pitch.setTranslation(0,Pitch*offset);
		me.HorizonLine.pitch.setTranslation(0,Pitch*offset);
		me.PitchScale.pitch.setTranslation(0,Pitch*offset);
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

	updateVSI: func(VSI)
	{
		if(VSI != nil)
		{

			if(VSI > 4250)
			{
				VSIOffset = -148.21875;
			}
			elsif(VSI < -4250)
			{
				VSIOffset = 148.21875;
			}
			else
			{
				VSIOffset = (-VSI)*0.034875;
			};
			if((VSI < 100) and (VSI > -100))
			{
				VSIText = "";
			}
			elsif((VSI < -10000) or (VSI > 10000))
			{
				VSIText = "----";
			}
			else
			{
				VSIText = sprintf("%1d",int(VSI/50)*50);
			}
		}
		else
		{
			VSIText = "";
			VSIOffset = 0
		};
		#print (VSIText ~ " " ~ sprintf("%1.0f", VSI));
		me.VSIText.Element.setText(VSIText);
		me.VSI.Element.setTranslation(0,VSIOffset);
	}
};
