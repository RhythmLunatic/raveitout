--local p;

--The thing you want to be displayed in the ActorScroller. It has to be a table because I said so.
local scrollerItemTable = {"Item 1", "Item 2", "Item 3", "Item 4"}



local t = Def.ActorFrame{
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
	

};

--Declare your ActorScroller.
local as = Def.ActorScroller{
    --Like I said, the example and the wiki tells you everything you need to know about these constructors.
    NumItemsToDraw=20,
    SecondsPerItem=.3,
    TransformFunction=function(self,offset,itemIndex,numItems)
        self:y(80*offset);
    end,

    -- Scroller commands
    InitCommand=cmd(rotationz,15;xy,325,SCREEN_CENTER_Y;),
    --This is the input handler for the scroller.
    CodeMessageCommand=function(self, param)
        if param.Name == "Up" or param.Name == "Left" then
            if self:GetDestinationItem() > 0 then
                self:SetDestinationItem(self:GetDestinationItem()-1);
                SOUND:PlayOnce(THEME:GetPathS("Common", "value"), true);
            end;
        elseif param.Name == "Down" or param.Name == "Right" then
            if self:GetDestinationItem() < self:GetNumItems()-1 then
                self:SetDestinationItem(self:GetDestinationItem()+1);
                SOUND:PlayOnce(THEME:GetPathS("Common", "value"), true);
            end;
        elseif param.Name == "Start" then
            SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen");
        elseif param.Name == "Back" then
            SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToPrevScreen");
        end;
        --Like I said earlier, GainFocusCommand and LoseFocusCommand aren't part of an ActorScroller, they're part of ScreenSelectMaster. Therefore it has to be reimplemented.
		SCREENMAN:SystemMessage((self:GetDestinationItem()+1).."/"..#scrollerItemTable)
        for i=1,self:GetNumItems() do --self:GetNumItems() might work better?
            if self:GetDestinationItem()+1 == i then
                self:GetChild(i):playcommand("GainFocus")
            else
                self:GetChild(i):playcommand("LoseFocus")
            end;
        end;
    end
}

for i,v in ipairs(scrollerItemTable) do
    as[#as+1] = Def.ActorFrame{
		Name=i; --Do not forget this! You need to give the items an index for GainFocus and LoseFocus to work!
		LoadFont("Common Normal")..{
			Text=v;
			--InitCommand=cmd(diffuse,Color("Red");setsize,20,20;diffuse,Color("Red"));
			--GainFocusCommand=cmd(stoptweening;linear,.5;diffuse,Color("Red"));
			GainFocusCommand=function(self)
				SCREENMAN:SystemMessage("GainFocus "..self:GetName());
				self:diffuse(Color("Red"))
				--self:zoom(999);
			end;
			LoseFocusCommand=cmd(stoptweening;linear,.5;diffuse,Color("White"));
		};
	}
end;

t[#t+1] = as;


return t;
