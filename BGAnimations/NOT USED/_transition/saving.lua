return Def.ActorFrame{
	OnCommand=cmd(sleep,1);
	LoadActor("map_shutter01")..{
		InitCommand=cmd(horizalign,right;xy,SCREEN_CENTER_X+225,SCREEN_CENTER_Y;zoom,1.35;);
	};
	LoadActor("map_shutter01")..{
		InitCommand=cmd(horizalign,right;xy,SCREEN_CENTER_X-225,SCREEN_CENTER_Y;zoom,1.35;rotationz,180;);
	};
	
	--[[LoadFont("Common Label")..{
		Text="Saving...";
		InitCommand=cmd(horizalign,right;vertalign,bottom;xy,SCREEN_WIDTH-10,SCREEN_BOTTOM-10);
	};]]

};