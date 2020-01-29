--[[
If you're trying to figure out how to do button inputs, don't use this.
this function uses DeviceInput because I need /mouse/ input, you normally
don't need that.
]]
local function inputs(event)
	--Check if player clicked screen, then skip to next screen if they did.
	local button = ToEnumShortString(event.DeviceInput.button)
	if button == "left mouse button" then
		--SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen");
	end
end;

local phrases = {
	"ZUN will sue",
	"Hi I'm kaiden",
	"Mokou is smoking hot. Literally.",
	"Brought to you by Waifu Hell",
	"Brought to you by Music Game Hell",
	"Brought to you by MAX300 Hell",
	"Guys what's sows",
	--"Actually, my name's Rick Djarc.",
	"An osu original",
	"& Knuckles",
	"I like rhythm games",
	"Wake me up inside",
	"When's Mahvel?",
	"When's Melty?",
	"It's Mahvel baybee!",
	"Writing bad StepMania themes since 2015",
	"Show me the metrics.ini",
	"Also check out Melty Blood Actress Again Current Code for SM5!",
	"Also check out Pump It Up: Delta 2!",
	"Also check out DanceDanceRevolution: SuperNOVA 3!",
	"Also check out DanceDanceRevolution: Starlight!",
	"Also check out Sushi Violation!",
	"stole the precious thing",
	"stole this theme (Sorry Cortes)",
	"Not actually a DJ",
	"SEEEEEEEHHHHHHHHGAAAAAAAAAAAAAAAAA!",
	"A real time music game that's hard and fast. It's too cool!",
	"TWO DEE ECKS GOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOLD!",
	"no u",
	"RIP Museca",
	"RIP Crossbeats",
	"RIP BeatStream",
	"Academy City's #1",
	"Are you tired of reading these yet?",
	"https://youtu.be/dQw4w9WgXcQ",
	"What is a man? A miserable little pile of secrets!"

};

return Def.ActorFrame{
	--Fade out
	OnCommand=function(self)
		self:sleep(6);
		self:linear(.5);
		self:diffusealpha(0);
		SCREENMAN:GetTopScreen():AddInputCallback(inputs);
	end;
	
	LoadActor(THEME:GetPathG("","stepmania"))..{
		InitCommand=cmd(Center;diffusealpha,0);
		OnCommand=cmd(decelerate,.5;diffusealpha,1;sleep,3;decelerate,.3;zoomy,0;zoomx,3);
	};
	
	LoadActor(THEME:GetPathG("RhythmLunatic","logo"))..{
		InitCommand=cmd(Center;cropright,1;diffusealpha,0);
		OnCommand=cmd(sleep,3;linear,.5;diffusealpha,1;decelerate,1;cropright,0;);
	};
	LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
        Text=phrases[math.random(#phrases)];
        InitCommand=cmd(Center;addy,50;diffusealpha,0;wrapwidthpixels,SCREEN_WIDTH;zoom,.75);
		OnCommand=cmd(sleep,4;linear,.1;diffusealpha,1);
    };
	
	--Don't do this, use PlayMusic metric setting!!
	--[[LoadActor(THEME:GetPathS("ScreenTitleMenu", "music"))..{
		OnCommand=cmd(play);
	};]]
};
