--local p;

--The thing you want to be displayed in the ActorScroller. It has to be a table because I said so.
local scrollerItemTable = {"Item 1", "Item 2", "Item 3", "Item 4"}


local function inputs(event)
	if event.type == "InputEventType_Release" then return end

	local button = event.button
	local realButton = ToEnumShortString(event.DeviceInput.button)

	if realButton == "left mouse button" or realButton == "right mouse button" or realButton == "middle mouse button" then
		local xpos = INPUTFILTER:GetMouseX();
		local ypos = INPUTFILTER:GetMouseY();
		SCREENMAN:SystemMessage(realButton.. " x: "..xpos..", y: "..ypos);
	elseif button == "Start" then
		SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen");
	elseif button == "Back" then
		SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToPrevScreen");
	else
		SCREENMAN:SystemMessage(button.. " " .. realButton);
	end;
end;


local t = Def.ActorFrame{
	OnCommand=function(self)
		--SCREENMAN:GetTopScreen():AddInputCallback(inputs);
	end;
	--[[Def.Quad{
		InitCommand=cmd(setsize,SCREEN_WIDTH,SCREEN_HEIGHT;Center);
	};]]
	--[[Def.Sprite{
		--Texture=THEME:GetPathG("","_BGMovies/Arcade.mpg");
		Texture=THEME:GetPathG("Banner","SortOrder_Title");
		InitCommand=cmd(Center;zoom,.5;SetEffectMode,"EffectMode_Saturation");
		Name="Proxy";
	};]]
	Def.Sprite{
		Texture=THEME:GetPathG("","_BGMovies/Arcade.mpg");
		--Texture=THEME:GetPathG("Banner","SOrtOrder_Title");
		InitCommand=cmd(xy,SCREEN_CENTER_X/2,SCREEN_CENTER_Y;zoom,.5;);
		CodeMessageCommand=function(self,param)
			if param.Name == "MenuRight" then
				self:stoptweening():linear(1):diffusealpha(0):linear(1):diffusealpha(1);
			end;
		end;
		Name="Proxy";
	};
	
	Def.ActorProxy{
		InitCommand=cmd(x,SCREEN_WIDTH/2;);
		OnCommand=function(self)
			self:SetTarget(self:GetParent():GetChild("Proxy"));
		end;
	};
	Def.ActorProxy{
		InitCommand=cmd(xy,SCREEN_WIDTH/2,SCREEN_HEIGHT/2;);
		OnCommand=function(self)
			self:SetTarget(self:GetParent():GetChild("Proxy"));
		end;
	};
	Def.ActorProxy{
		InitCommand=cmd(x,SCREEN_WIDTH;);
		OnCommand=function(self)
			self:SetTarget(self:GetParent():GetChild("Proxy"));
		end;
	};
	
	Def.SpriteAsync{
		Texture=THEME:GetPathG("Common","Arrow");
		InitCommand=cmd(Center);
	};
	

};


--[[local function bTos(b) return b and "true" or "false" end;

t[#t+1] = Def.ActorFrame{
	Def.BitmapText{
		Font="Common Normal";
		InitCommand=cmd(Center);
		Text=bTos(UNLOCKMAN:IsSongLocked(SONGMAN:FindSong("99-Easy/Gangnam Style")));
	}
}]]


return t;
