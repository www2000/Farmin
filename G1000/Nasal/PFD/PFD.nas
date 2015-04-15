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

		var svg_keys = ["Horizon","bankPointer","bankPointerLineL",
		"bankPointerLineR","Compass","SlipSkid","CompassText","VSI",
		"VSIText","HorizonLine", "PitchScale"];
		#speed
		svg_keys ~= ["LindSpeed","SpeedtLint1","SpeedtLint10","SpeedtLint100"];
		#alt
		svg_keys ~= ["AltLint10","AltLint100","AltLint1000","AltLint10000"];
		svg_keys ~= ["AltBigU1","AltBigU2","AltBigU3","AltBigU4","AltBigU5","AltBigU6",];
		svg_keys ~= ["AltBigD1","AltBigD2","AltBigD3","AltBigD4","AltBigD5","AltBigD6",];
		svg_keys ~= ["AltSmallU1","AltSmallU2","AltSmallU3","AltSmallU4","AltSmallU5","AltSmallU6",];
		svg_keys ~= ["AltSmallD1","AltSmallD2","AltSmallD3","AltSmallD4","AltSmallD5","AltSmallD6",];
		svg_keys ~= ["AltBigC","AltSmallC","LintAlt"];
		svg_keys ~= ["Marker","MarkerBG","MarkerText"];
		svg_keys ~= ["MAPL","MAPR"];

		svg_keys = svg_keys ~[];
		foreach(var key; svg_keys) {
			print(key);
			m[key] = nil;
			m[key] = pfd.getElementById(key);
			m[key].updateCenter();
			m[key].trans	= m[key].createTransform();
			m[key].rot		= m[key].createTransform();
			m[key].hide();

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

		m.LintAlt.set("clip", "rect(114px, 1024px, 455px, 0px)");
		#note to my self clip for the Pitch Scale is: top = 134 right = 590 bottem = 394 left = 330

		#Enable map
		m.MAPdata = pfd.createChild("map");
		m.MAPdata.setController("Aircraft position");
		m.MAPdata.setRange(25);
		m.MAPdata.setTranslation(861,601);
		var r = func(name,vis=1,zindex=nil) return caller(0)[0];
		foreach(var type; [r('TFC'), r('APS')] )
			m.MAPdata.addLayer(factory: canvas.SymbolLayer, type_arg: type.name, visible: type.vis, priority: type.zindex,);
		m.MAPdata.set("clip", "rect(493, 1011, 709, 711)");
		m.MAPdata.hide();

		return m
	},

	updateAi: func(roll,pitch){
		if (pitch > 80 )
		{
			var pitch = 80;
		}
		elsif(pitch < -80)
		{
			var pitch = -80;
		}

		var RollR = -roll*D2R;

		var AP	= 57.5;
		var AN	= 27.5;
		var BP	= 37.5;
		var BN	= 40;

		var HLAPRN = math.sqrt(1/(math.pow(math.cos(RollR)/AP,2)+(math.pow(math.sin(RollR)/BN,2))));
		var HLANBN = math.sqrt(1/(math.pow(math.cos(RollR)/AN,2)+(math.pow(math.sin(RollR)/BN,2))));
		var HLAPBP = math.sqrt(1/(math.pow(math.cos(RollR)/AP,2)+(math.pow(math.sin(RollR)/BP,2))));
		var HLANBP = math.sqrt(1/(math.pow(math.cos(RollR)/AN,2)+(math.pow(math.sin(RollR)/BP,2))));

		var RAP	= ((roll > -90) and (roll <= 90));
		var RAN = ((roll <= -90) or (roll > 90));
		var RBP = (roll >= 0);
		var RBN = (roll < 0);
		if((pitch >= 0) and (RAP and RBN))
		{
			var limit = HLAPRN;
		}
		elsif((pitch >= 0) and (RAN and RBN))
		{
			var limit = HLANBN;
		}
		elsif((pitch >= 0)and (RAP and RBP))
		{
			var limit = HLAPBP;
		}
		elsif((pitch >= 0)and (RAN and RBP))
		{
			var limit = HLANBP;
		}
		elsif((pitch < 0) and (RAN and RBP))
		{
			var limit = HLAPRN;
		}
		elsif((pitch < 0) and (RAP and RBP))
		{
			var limit = HLANBN;
		}
		elsif((pitch < 0)and (RAN and RBN))
		{
			var limit = HLAPBP;
		}
		elsif((pitch < 0)and (RAP and RBN))
		{
			var limit = HLANBP;
		}

		if(pitch > limit)
		{
			var Hpitch = limit;
		}
		elsif(-pitch > limit)
		{
			var Hpitch = -limit;
		}
		else
		{
			var Hpitch = pitch;
		}

		me.Horizon.rot.setRotation(RollR, me.PitchScale.getCenter());
		me.Horizon.trans.setTranslation(0,Hpitch*6.8571428);

		me.HorizonLine.rot.setRotation(RollR, me.PitchScale.getCenter());
		me.HorizonLine.trans.setTranslation(0,pitch*6.8571428);
		me.PitchScale.rot.setRotation(RollR, me.PitchScale.getCenter());
		me.PitchScale.trans.setTranslation(0,pitch*6.8571428);

		var brot = me.bankPointer.getCenter();
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
			var Offset1 = 0;
			var Offset10 = 0;

			if (speed < 20)
			{
				var speed = 20;
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
			};

			var speed1		= math.mod(speed,10);
			var speed10		= int(math.mod(speed/10,10));
			var speed100	= int(math.mod(speed/100,10));
			var speed0_1 	= speed1 - int(speed1);
			if (speed1 >= 9)
			{
				var speed10 += speed0_1;
			}

			if (speed1 >= 9 and speed10 >= 9)
			{
				var speed100 += speed0_1;
			}

			if(speed >= 10)
			{
				var Offset1 = 10;
			}
			if(speed >= 100)
			{
				var Offset10 = 10;
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

	updateAlt: func(Alt)
	{

		if(Alt !=nil)
		{
			me.AltLint10.show();
			me.AltLint100.show();
			me.AltLint1000.show();
			me.AltLint10000.show();
			if(Alt> -1000 and Alt< 1000000)
			{
				var Offset10 = 0;
				var Offset100 = 0;
				var Offset1000 = 0;
				if(Alt< 0)
				{
					var Ne = 1;
					var Alt= -Alt
				}
				else
				{
					var Ne = 0;
				}

				var Alt10		= math.mod(Alt,100);
				var Alt100		= int(math.mod(Alt/100,10));
				var Alt1000		= int(math.mod(Alt/1000,10));
				var Alt10000	= int(math.mod(Alt/10000,10));
				var Alt20 		= math.mod(Alt10,20)/20;
				if (Alt10 >= 80)
				{
					var Alt100 += Alt20
				};

				if (Alt10 >= 80 and Alt100 >= 9)
				{
					var Alt1000 += Alt20
				};

				if (Alt10 >= 80 and Alt100 >= 9 and Alt1000 >= 9)
				{
					var Alt10000 += Alt20
				};

				if (Alt> 100)
				{
					var Offset10 = 100;
				}

				if (Alt> 1000)
				{
					var Offset100 = 10;
				}

				if (Alt> 10000)
				{
					var Offset1000 = 10;
				}

				if(!Ne)
				{
					me.AltLint10.setTranslation(0,(Alt10+Offset10)*1.2498);
					me.AltLint100.setTranslation(0,(Alt100+Offset100)*30);
					me.AltLint1000.setTranslation(0,(Alt1000+Offset1000)*36);
					me.AltLint10000.setTranslation(0,(Alt10000)*36);
					me.LintAlt.setTranslation(0,(math.mod(Alt,100))*0.57375);
					var altCentral = (int(Alt/100)*100);
				}
				elsif(Ne)
				{
					me.AltLint10.setTranslation(0,(Alt10+Offset10)*-1.2498);
					me.AltLint100.setTranslation(0,(Alt100+Offset100)*-30);
					me.AltLint1000.setTranslation(0,(Alt1000+Offset1000)*-36);
					me.AltLint10000.setTranslation(0,(Alt10000)*-36);
					me.LintAlt.setTranslation(0,(math.mod(Alt,100))*-0.57375);
					var altCentral = -(int(Alt/100)*100);
				}
				me["AltBigC"].setText("");
				me["AltSmallC"].setText("");
				var placeInList = [1,2,3,4,5,6];
				foreach(var place; placeInList)
				{
					var altUP = altCentral + (place*100);
					var offset = -30.078;
					if (altUP < 0)
					{
						var altUP = -altUP;
						var prefix = "-";
						var offset += 15.039;
					}
					else
					{
						var prefix = "";
					}
					if(altUP == 0)
					{
						var AltBigUP	= "";
						var AltSmallUP	= "0";

					}
					elsif(math.mod(altUP,500) == 0 and altUP != 0)
					{
						var AltBigUP	= sprintf(prefix~"%1d", altUP);
						var AltSmallUP	= "";
					}
					elsif(altUP < 1000 and (math.mod(altUP,500)))
					{
						var AltBigUP	= "";
						var AltSmallUP	= sprintf(prefix~"%1d", int(math.mod(altUP,1000)));
						var offset = -30.078;
					}
					elsif((altUP < 10000) and (altUP >= 1000) and (math.mod(altUP,500)))
					{
						var AltBigUP	= sprintf(prefix~"%1d", int(altUP/1000));
						var AltSmallUP	= sprintf("%1d", int(math.mod(altUP,1000)));
						var offset += 15.039;
					}
					else
					{
						var AltBigUP	= sprintf(prefix~"%1d", int(altUP/1000));
						var mod = int(math.mod(altUP,1000));
						var AltSmallUP	= sprintf("%1d", mod);
						var offset += 30.078;
					}

					me["AltBigU"~place].setText(AltBigUP);
					me["AltSmallU"~place].setText(AltSmallUP);
					me["AltSmallU"~place].setTranslation(offset,0);
					var altDOWN = altCentral - (place*100);
					var offset = -30.078;
					if (altDOWN < 0)
					{
						var altDOWN = -altDOWN;
						var prefix = "-";
						var offset += 15.039;
					}
					else
					{
						var prefix = "";
					}
					if(altDOWN == 0)
					{
						var AltBigDOWN	= "";
						var AltSmallDOWN	= "0";

					}
					elsif(math.mod(altDOWN,500) == 0 and altDOWN != 0)
					{
						var AltBigDOWN	= sprintf(prefix~"%1d", altDOWN);
						var AltSmallDOWN	= "";
					}
					elsif(altDOWN < 1000 and (math.mod(altDOWN,500)))
					{
						var AltBigDOWN	= "";
						var AltSmallDOWN	= sprintf(prefix~"%1d", int(math.mod(altDOWN,1000)));
						var offset = -30.078;
					}
					elsif((altDOWN < 10000) and (altDOWN >= 1000) and (math.mod(altDOWN,500)))
					{
						var AltBigDOWN	= sprintf(prefix~"%1d", int(altDOWN/1000));
						var AltSmallDOWN	= sprintf("%1d", int(math.mod(altDOWN,1000)));
						var offset += 15.039;
					}
					else
					{
						var AltBigDOWN	= sprintf(prefix~"%1d", int(altDOWN/1000));
						var mod = int(math.mod(altDOWN,1000));
						var AltSmallDOWN	= sprintf("%1d", mod);
						var offset += 30.078;
					}
					me["AltBigD"~place].setText(AltBigDOWN);
					me["AltSmallD"~place].setText(AltSmallDOWN);
					me["AltSmallD"~place].setTranslation(offset,0);
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
				var VSIOffset = -148.21875;
			}
			elsif(VSI < -4250)
			{
				var VSIOffset = 148.21875;
			}
			else
			{
				var VSIOffset = (-VSI)*0.034875;
			};
			if((VSI < 100) and (VSI > -100))
			{
				var VSIText = "";
			}
			elsif((VSI < -10000) or (VSI > 10000))
			{
				var VSIText = "----";
			}
			else
			{
				var VSIText = sprintf("%1d",int(VSI/50)*50);
			}
		}
		else
		{
			var VSIText = "";
			var VSIOffset = 0
		};
		#print (VSIText ~ " " ~ sprintf("%1.0f", VSI));
		me.VSIText.setText(VSIText);
		me.VSI.setTranslation(0,VSIOffset);
	},

	updateMarkers: func(marker)
	{
		if(marker == 0)
		{
			me.Marker.hide();
		}
		if(marker == 1) #OM
		{
			me.Marker.show();
			me.MarkerBG.setColorFill(0.603921569,0.843137255,0.847058824);
			me.MarkerText.setText('O');
		}
		if(marker == 2) #MM
		{
			me.Marker.show();
			me.MarkerBG.setColorFill(1,0.870588235,0.11372549);
			me.MarkerText.setText('M');
		}
		if(marker == 3) #IM
		{
			me.Marker.show();
			me.MarkerBG.setColorFill(1,1,1);
			me.MarkerText.setText('I');
		}
	},

	#SetMap: func(post)
	#{
	#	if(post = 1)

	#	elsif(post = 2)
	#	{

	#	}
	#},
};
