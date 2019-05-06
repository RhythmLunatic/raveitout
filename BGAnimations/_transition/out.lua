return Def.ActorFrame{
	OnCommand=cmd(sleep,1);
	LoadActor("map_shutter03")..{
		InitCommand=cmd(horizalign,right;xy,0,SCREEN_CENTER_Y;zoom,.9);
		OnCommand=cmd(decelerate,.5;x,SCREEN_CENTER_X+148);
	};
	LoadActor("map_shutter03")..{
		InitCommand=cmd(horizalign,right;xy,SCREEN_WIDTH,SCREEN_CENTER_Y;rotationz,180;zoom,.9);
		OnCommand=cmd(decelerate,.5;x,SCREEN_CENTER_X-148);
	}

};
