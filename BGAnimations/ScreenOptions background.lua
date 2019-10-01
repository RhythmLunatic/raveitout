local sepx = 20
local textsize = 1.2;

local function GetString(s)
	return THEME:GetString("ScreenOptions", s)
end

local function SystemInfo(self)
	--local b12HrCloq = GetUserPrefB("12hr Clock")
	local clock = self:GetChild("SysyInfo")
	display = "Display: "..DISPLAY:GetDisplayWidth().."x"..DISPLAY:GetDisplayHeight();
	clock:settextf("%02i:%02i:%02i %s\n"..display, ((Hour() -1) %12) +1, Minute(), Second(), Hour() < 12 and "AM" or "PM" )
end

return Def.ActorFrame {
	InitCommand=cmd(SetUpdateFunction,SystemInfo);
		
	LoadFont("_fixedsys")..{ -- Title Operator Menu
		Text="OPERATOR MENU";
		InitCommand=cmd(xy,SCREEN_CENTER_X,SCREEN_TOP+sepx;SetTextureFiltering,false;vertalign,top;zoom,textsize;);
	};
	
	LoadFont("_fixedsys")..{
		Text="RAVE IT OUT FOR WEABOOS\n© 2016-2019 RIO DEVS & RHYTHM LUNATIC.";
		InitCommand=cmd(xy,20,SCREEN_HEIGHT-20;SetTextureFiltering,false;horizalign,left;vertalign,bottom;zoom,textsize;);
	};
	LoadFont("_fixedsys")..{
		--Text="MOVE - MENULEFT MENURIGHT MENUUP MENUDOWN\nSELECT - MENUSTART";
		Text="MOVE OPTIONS- DOWNLEFT DOWNRIGHT\n MOVE SUB-OPTIONS - UPLEFT UPRIGHT\nSELECT - CENTER";
		InitCommand=cmd(xy,SCREEN_CENTER_X,SCREEN_BOTTOM-50;SetTextureFiltering,false;vertalign,bottom;zoom,textsize;);
	};
	
	LoadFont("_fixedsys")..{
		Name="SysyInfo";
		InitCommand=cmd(xy,SCREEN_WIDTH-20,SCREEN_BOTTOM-20;SetTextureFiltering,false;horizalign,right;vertalign,bottom;zoom,textsize;);
	};
	
}
