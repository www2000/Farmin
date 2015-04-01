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
		var svg_keys = ["LindSpeed","SpeedtLint1","SpeedtLint10",
		"SpeedtLint100", "Horizon","bankPointer","bankPointerLineL",
		"bankPointerLineR","Compass","SlipSkid","CompassText","VSI",
		"VSIText","HorizonLine", "PitchScale","AltLint10","AltLint100",
		"AltLint1000","AltLint10000"];
		foreach(var key; svg_keys) {
			print(key);
			m[key] = nil;
			m[key] = pfd.getElementById(key);
			m[key].updateCenter();
			m[key].trans	= m[key].createTransform();
			m[key].rot		= m[key].createTransform();

		};
		#5,715272637

		#clip
		m.bankPointerLineL.set("clip", "rect(0,1024,768,459.500)");
		m.bankPointerLineR.set("clip", "rect(0,459.500,768,0)");
		m.PitchScale.set("clip", "rect(134,590,394,330)");
		m.AltLint10.set("clip", "rect(251.5,1024,317.5,0)");
		m.AltLint100.set("clip", "rect(264.5,1024,304.5,0)");
		m.AltLint1000.set("clip", "rect(264.5,1024,304.5,0)");
		m.AltLint10000.set("clip", "rect(264.5,1024,304.5,0)");
		m.SpeedtLint1.set("clip", "rect(251.5,1024,317.5,0)");
		m.SpeedtLint10.set("clip", "rect(264.5,1024,304.5,0)");
		m.SpeedtLint100.set("clip", "rect(264.5,1024,304.5,0)");
		#note to my self clip for the Pitch Scale is: top = 134 right = 590 bottem = 394 left = 330
		return m
	},

	updateAi: func(roll,pitch){
		if (pitch > 80 )
		{
			pitch = 80;
		}
		elsif(pitch < -80)
		{
			pitch = -80;
		}

		RollR = -roll*D2R;

		AP	= 57.5;
		AN	= 27.5;
		BP	= 37.5;
		BN	= 40;

		HLAPRN = math.sqrt(1/(math.pow(math.cos(RollR)/AP,2)+(math.pow(math.sin(RollR)/BN,2))));
		HLANBN = math.sqrt(1/(math.pow(math.cos(RollR)/AN,2)+(math.pow(math.sin(RollR)/BN,2))));
		HLAPBP = math.sqrt(1/(math.pow(math.cos(RollR)/AP,2)+(math.pow(math.sin(RollR)/BP,2))));
		HLANBP = math.sqrt(1/(math.pow(math.cos(RollR)/AN,2)+(math.pow(math.sin(RollR)/BP,2))));

		RAP	= ((roll > -90) and (roll <= 90));
		RAN = ((roll <= -90) or (roll > 90));
		RBP = (roll >= 0);
		RBN = (roll < 0);
		if((pitch >= 0) and (RAP and RBN))
		{
			limit = HLAPRN;
		}
		elsif((pitch >= 0) and (RAN and RBN))
		{
			limit = HLANBN;
		}
		elsif((pitch >= 0)and (RAP and RBP))
		{
			limit = HLAPBP;
		}
		elsif((pitch >= 0)and (RAN and RBP))
		{
			limit = HLANBP;
		}
		elsif((pitch < 0) and (RAN and RBP))
		{
			limit = HLAPRN;
		}
		elsif((pitch < 0) and (RAP and RBP))
		{
			limit = HLANBN;
		}
		elsif((pitch < 0)and (RAN and RBN))
		{
			limit = HLAPBP;
		}
		elsif((pitch < 0)and (RAP and RBN))
		{
			limit = HLANBP;
		}

		if(pitch > limit)
		{
			Hpitch = limit;
		}
		elsif(-pitch > limit)
		{
			Hpitch = -limit;
		}
		else
		{
			Hpitch = pitch;
		}

		me.Horizon.rot.setRotation(RollR, me.PitchScale.getCenter());
		me.Horizon.trans.setTranslation(0,Hpitch*6.8571428);

		me.HorizonLine.rot.setRotation(RollR, me.PitchScale.getCenter());
		me.HorizonLine.trans.setTranslation(0,pitch*6.8571428);
		me.PitchScale.rot.setRotation(RollR, me.PitchScale.getCenter());
		me.PitchScale.trans.setTranslation(0,pitch*6.8571428);

		brot = me.bankPointer.getCenter();
		me.bankPointer.rot.setRotation(RollR,brot);
		me.bankPointerLineL.rot.setRotation(RollR,brot);
		me.bankPointerLineR.rot.setRotation(RollR,brot);

		if (RollR < 0) #top, right, bottom, left
		{
			me.bankPointerLineL.set("clip", "rect(0,1,1,0)"); #459,500
			me.bankPointerLineR.set("clip", "rect(0,459.500,768,0)");
		}
		elsif (RollR > 0)
		{
			me.bankPointerLineL.set("clip", "rect(0,1024,768,459.500)"); #459,500
			me.bankPointerLineR.set("clip", "rect(0,1,1,0)");
		}
		else
		{
			me.bankPointerLineL.set("clip", "rect(0,1024,768,459.500)"); #459,500
			me.bankPointerLineR.set("clip", "rect(0,459.500,768,0)");
		}
	},

	UpdateHeading: func(Heading)
	{
		me.Compass.setRotation(-Heading*D2R);
		me.CompassText.setText(sprintf("%03.0f°",math.floor(Heading)));
	},

	updateSpeed: func(speed)
	{
		if(speed != nil)
		{
			me.data.speed = speed;
			Offset1 = 0;
			Offset10 = 0;

			if (speed < 20)
			{
				speed = 20;
				me.LindSpeed.set("clip", "rect(114px, 239px, 284,5px, 154px)");
			}
			elsif (speed >= 20 and  speed < 50)
			{
				me.LindSpeed.set("clip", sprintf("rect(114px, 239px, %1.0fpx, 154px)", math.floor(284.5 + ((speed-20) * 5.71225) ) ) );
			}
			else
			{
				me.LindSpeed.set("clip", "rect(114px, 239px, 455px, 154px)");
			};

			if (speed > 20)
			{
				me.LindSpeed.setTranslation(0,speed*5.71225);
			}else{

				#me.SpeedNonLint.setText("---");
				me.LindSpeed.setTranslation(0,114,245);
				me.LindSpeed.set("clip", "rect(114px, 239px, 455px, 154px)");
			};

			speed1		= math.mod(speed,10);
			speed10		= int(math.mod(speed/10,10));
			speed100	= int(math.mod(speed/100,10));
			speed0_1 	= speed1 - int(speed1);
			if (speed1 >= 9)
			{
				speed10 += speed0_1;
			}

			if (speed1 >= 9 and speed10 >= 9)
			{
				speed100 += speed0_1;
			}

			if(speed >= 10)
			{
				Offset1 = 10;
			}
			if(speed >= 100)
			{
				Offset10 = 10;
			}
			me.LindSpeed.setTranslation(0,speed*5.71225);
			me.SpeedtLint1.setTranslation(0,(speed1+Offset1)*36);
			me.SpeedtLint10.setTranslation(0,(speed10+Offset10)*36);
			me.SpeedtLint100.setTranslation(0,(speed100)*36);
		}
		else
		{
			me.LindSpeed.Element.set("clip", "rect(114px, 239px, 455px, 154px)");
 		}
	},
	updateSpeedTrend: func(Speedtrent)
	{
		me.data.speedTrent;

	},
	updateSlipSkid: func(slipskid){
		me.SlipSkid.setTranslation(slipskid*5.73,0);

	},

	updateAlt: func(alt)
	{

		if(alt !=nil)
		{
			if(alt > -1000 and alt < 1000000)
			{
				me.AltLint10.show();
				me.AltLint100.show();
				me.AltLint1000.show();
				me.AltLint10000.show();

				Offset10 = 0;
				Offset100 = 0;
				Offset1000 = 0;
				if(alt < 0)
				{
					Ne = 1;
					alt = -alt
				}
				else
				{
					Ne = 0;
				}

				Alt10		= math.mod(alt,100);
				Alt100		= int(math.mod(alt/100,10));
				Alt1000		= int(math.mod(alt/1000,10));
				Alt10000	= int(math.mod(alt/10000,10));
				Alt20 		= math.mod(Alt10,20)/20;
				if (Alt10 >= 80)
				{
					Alt100 += Alt20
				};

				if (Alt10 >= 80 and Alt100 >= 9)
				{
					Alt1000 += Alt20
				};

				if (Alt10 >= 80 and Alt100 >= 9 and Alt1000 >= 9)
				{
					Alt10000 += Alt20
				};

				if (alt > 100)
				{
					Offset10 = 100;
				}

				if (alt > 1000)
				{
					Offset100 = 10;
				}

				if (alt > 10000)
				{
					Offset1000 = 10;
				}

				if(!Ne)
				{
					me.AltLint10.setTranslation(0,(Alt10+Offset10)*1.2498);
					me.AltLint100.setTranslation(0,(Alt100+Offset100)*30);
					me.AltLint1000.setTranslation(0,(Alt1000+Offset1000)*36);
					me.AltLint10000.setTranslation(0,(Alt10000)*36);
				}
				elsif(Ne)
				{
					me.AltLint10.setTranslation(0,(Alt10+Offset10)*-1.2498);
					me.AltLint100.setTranslation(0,(Alt100+Offset100)*-30);
					me.AltLint1000.setTranslation(0,(Alt1000+Offset1000)*-36);
					me.AltLint10000.setTranslation(0,(Alt10000)*-36);
				}
			}
			else
			{
				me.AltLint10.hide();
				me.AltLint100.hide();
				me.AltLint1000.hide();
				me.AltLint10000.hide();
			}

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
		me.VSIText.setText(VSIText);
		me.VSI.setTranslation(0,VSIOffset);
	}
};
