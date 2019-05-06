return Def.ActorFrame{
	LoadActor("map_shutter01")..{
		InitCommand=cmd(horizalign,right;Center;zoom,1.35;addx,225);
		OnCommand=cmd(accelerate,.5;x,0);
	};
	LoadActor("map_shutter01")..{
		InitCommand=cmd(horizalign,right;Center;zoom,1.35;rotationz,180;addx,-225);
		OnCommand=cmd(accelerate,.5;x,SCREEN_WIDTH);
	}

};