local function getWavyText(s,x,y)
	local letters = Def.ActorFrame{}
	local spacing = 15
	for i = 1, #s do
		local c = s:sub(i,i)
		--local c = "a"
		letters[i] = LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
			Text=c;
			InitCommand=cmd(x,x-(#s)*spacing/2+i*spacing;y,y;effectoffset,i*.1;bob;);
		};
	end;
	return letters;
end;

local function getWavyTextPlusRainbow(s,x,y)
	local letters = Def.ActorFrame{}
	local spacing = 15
	for i = 1, #s do
		local c = s:sub(i,i)
		letters[i] = Def.ActorFrame{
			InitCommand=cmd(bob;x,x-(#s)*spacing/2+i*spacing;y,y;effectoffset,i*.1;);
			LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
				Text=c;
				InitCommand=cmd(rainbow;effectoffset,i*.1;);
			};
		};
	end;
	return letters;
end;

local xVelocity = 0
local t = Def.ActorFrame{
	Def.ActorFrame{
		FOV=90;
		LoadActor(THEME:GetPathG("RhythmLunatic","icon"))..{
			InitCommand=cmd(rainbow;customtexturerect,0,0,5,5;setsize,750,750;Center;texcoordvelocity,0,1.5;rotationx,-90/4*3.5;fadetop,1);
			CodeMessageCommand=function(self, params)
				if params.Name == "Start" or params.Name == "Center" then
					SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToPrevScreen");
				elseif params.Name == "Left" then
					xVelocity=xVelocity+.5;
				elseif params.Name == "Right" then
					xVelocity=xVelocity-.5;
				else
					--SCREENMAN:SystemMessage("Unknown button: "..params.Name);
				end;
				self:texcoordvelocity(xVelocity,1.5);
			end;
		};
	}
};
t[#t+1] = getWavyText("Rave It Out: Season 2",SCREEN_CENTER_X,SCREEN_CENTER_Y-120);
t[#t+1] = getWavyText("(Re)programmed by Rhythm Lunatic",SCREEN_CENTER_X,SCREEN_CENTER_Y-20);
t[#t+1] = getWavyText("Original code by NeobeatIKK (Sergio Madrid), Jose Jesus, Alisson de Oliveira",SCREEN_CENTER_X,SCREEN_CENTER_Y+80);
t[#t+1] = getWavyText("Greetz to StepPrime and StepF2 Team",SCREEN_CENTER_X,SCREEN_CENTER_Y+80);
t[#t+1] = getWavyTextPlusRainbow("Thank you for playing our game! And congratulations for finding this screen.",SCREEN_CENTER_X,SCREEN_BOTTOM-80)..{
	OnCommand=cmd(x,1000;linear,10;x,-1500;queuecommand,"On";);
};
return t;
