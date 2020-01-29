--local p;
local t = Def.ActorFrame{
	Def.Sprite{
		Texture=THEME:GetPathG("","_BGMovies/Arcade.mpg");
		InitCommand=cmd(xy,SCREEN_CENTER_X/2,SCREEN_CENTER_Y;zoom,.5);
		Name="Proxy";
	};
	Def.ActorFrame{
		CodeMessageCommand=function(self,param)
			if param.Name == "MenuRight" then
				self:stoptweening():linear(1):diffusealpha(0):linear(1):diffusealpha(1);
			end;
		end;
		Def.ActorProxy{
			InitCommand=cmd(x,SCREEN_WIDTH/2);
			--InitCommand=cmd(xy,SCREEN_WIDTH*.75,SCREEN_CENTER_Y;);
			OnCommand=function(self)
				self:SetTarget(self:GetParent():GetParent():GetChild("Proxy"));
			end;
		}
		--[[Def.Sprite{
			Texture=THEME:GetPathG("","_BGMovies/Arcade.mpg");
			InitCommand=cmd(xy,SCREEN_WIDTH*.75,SCREEN_CENTER_Y;zoom,.5);
			Name="Proxy";
		};]]
	};

};

return t;
