local phrases = {
"Perfectionist Mode is best used for obtaining SS scores without wasting time. You won’t regret it. Heh.",
"Some modifiers will be overridden by certain charts.",
"Report any bugs to “http://facebook.com/raveitoutgame”. Make sure you report them in a very aggresive manner. Memes are appreciated but not mandatory.",
"Make sure to hit hold heads accurately, or you will be punished with worse judgements on following holds. Yeah, it’s bullshit. Nah, we don’t care.",
"Check the options list for the Screen Filter feature. It will allow a BGA to be viewed without affecting any gameplay. Loser.",
"If you already played for awhile, give “Pro mode” a whirl and test your timing skills. Also helps determine what is on and off sync.",
"The cuter the song, the harder the charts will be. We guarantee it.",
"Rave It Out is basically “Pitbull: The Game”: every song has some reason to make someone angry. Dale.",
"Play a song that is by Kanye West by himself. Trust me.",
"Playing Rave It Out during certain times of the year can cause weather changes in game.",
"Quad and Quint arrow combinations are a norm in Rave It Out. Learning how to hit them will be to your benefit.",
"Some songs have specific trivia. This song is not one of them."
};

local message;

local songmsgpath = GAMESTATE:GetCurrentSong():GetSongDir().."msg.txt";
local songhasmsg = FILEMAN:DoesFileExist(songmsgpath)
if songhasmsg then
	local file = File.Read(songmsgpath)
	messages = file:split("\r\n");
	--SCREENMAN:SystemMessage(tostring(#messages).." "..strArrayToString(messages));
	message = messages[math.random(#messages)];
else
	message = phrases[math.random(#phrases)];
end;


--animation controls
local inanit = 0.5		--in animation time
local inefft = 2		--in effect time
local stayat = 5-inanit-inefft		--stay still animation time
local outtwt = 0.25		--out tweening time
local itemy = 13		--item list y separation
local MessageFont = "Common normal"

return Def.ActorFrame{
	Def.ActorFrame{	--main
		--bg
		Def.Sprite{
			InitCommand=cmd(LoadFromCurrentSongBackground;Cover;diffusealpha,0.2);
			OnCommand=cmd(sleep,stayat+inanit+inefft;linear,.4;diffusealpha,.8);
		};
	
		Def.Sprite{				--Song Jacket
			InitCommand=cmd(x,_screen.cx;y,_screen.cy;zoom,10;diffusealpha,0;);
			OnCommand=function(self)
				--[[if song:HasJacket() then
					self:Load(song:GetJacketPath());
				else
					self:Load(song:GetBannerPath());
				end]]
				self:Load(getLargeJacket());
				(cmd(accelerate,inanit;zoomto,300,300;diffusealpha,1;linear,inefft;zoomto,255,255;sleep,stayat))(self)
			end;
			OffCommand=cmd(decelerate,outtwt;rotationz,90*0.5;zoom,0.8;diffusealpha,0);
		};
		LoadFont(MessageFont)..{	--MESSAGE		
			InitCommand=cmd(xy,_screen.cx,SCREEN_BOTTOM-60;zoom,0.75;maxwidth,SCREEN_WIDTH;wrapwidthpixels,780;maxheight,100;settext,message);
		};
		Def.Quad{				--Fade in/out
			InitCommand=function(self)
				(cmd(FullScreen;diffuse,color("1,1,1,1");linear,inanit*0.5;diffuse,color("0,0,0,0")))(self);
				(cmd(sleep,(inanit*0.5)+inefft+(stayat)))(self);
				--[[ ^ this shit needs some explanation:
				-- inanit is always the half the time as the disc image one
				-- resolved should be:
				--  sleep,(0.5*0.5)+2+(5-(0.5+2))
				--  sleep,0.25+2+(5-2.5)
				--  sleep,0.25+2+2.5
				--  sleep,4.75
				--]]
				--(cmd(linear,inanit*0.5;diffuse,color("0,0,0,1")))(self);
			end;
		};
	};
	Def.ActorFrame{	--debug
		OnCommand=cmd(visible,DoDebug);
		LoadFont(DebugFont)..{	--songhasmsg
			InitCommand=cmd(xy,SCREEN_RIGHT,SCREEN_BOTTOM-(itemy*1);horizalign,right;zoom,0.5);
			OnCommand=function(self)
				if songhasmsg then
					self:settext("songhasmsg: true");
				else
					self:settext("songhasmsg: false");
				end;
			end;
		};
	};
};
