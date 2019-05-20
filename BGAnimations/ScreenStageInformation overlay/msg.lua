local phrases = {
"Perfectionist Mode is best used for obtaining SS scores without wasting time.",
"Some modifiers will be overridden by certain charts.",
"Report any bugs to Rhythm Lunatic. Or don't.",
"Make sure to hit hold heads accurately, or you will be punished with worse judgements on following holds. Because StepMania is a great engine.",
"Check the options list for the Screen Filter feature. It will allow a BGA to be viewed without affecting any gameplay. Loser.",
"If you already played for awhile, give “Pro mode” a whirl and test your timing skills. Also helps determine what is on and off sync.",
"The cuter the anime girl, the harder the charts will be. I guarantee it.",
"Playing Rave It Out during certain times of the year can cause weather changes in game.",
"Some songs have unique trivia. This song is not one of them. (Add your own by reading the Song Structure Documentation.txt)",
"Some songs have unique loading screen backgrounds... If you've put in the specialBG.png.",
"Getting >90% accuracy in a song that requires 2 hearts will get you an extra heart which can be used to play another song.",
"If you're on the bonus stage and the song title is glowing red, try getting >95% accuracy for a surprise..."
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
	--bg
	Def.Sprite{
		InitCommand=cmd(LoadFromCurrentSongBackground;Cover;diffuse,color(".2,.2,.2,1"));
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
	LoadFont("letters/_ek mukta Bold 40px")..{
		Condition=UnlockedOMES_RIO();
		Text=THEME:GetString("ScreenStageInformation","GetFullCombo");
		InitCommand=cmd(Center;addx,600;diffusealpha,0;--[[diffuseleftedge,Color("Purple");faderight,1]]);
		OnCommand=cmd(decelerate,inanit+inefft;addx,-600;diffusealpha,.5;linear,stayat;diffusealpha,1;);
		OffCommand=cmd(decelerate,outtwt;diffusealpha,0);
	};
	LoadFont("letters/_ek mukta Bold 40px")..{
		Condition=UnlockedOMES_RIO();
		Text=THEME:GetString("ScreenStageInformation","GetFullCombo");
		InitCommand=cmd(Center;addx,-600;diffusealpha,0;--[[diffuserightedge,Color("Blue");fadeleft,1]]);
		OnCommand=cmd(decelerate,inanit+inefft;addx,600;diffusealpha,.5;linear,stayat;diffusealpha,1;);
		OffCommand=cmd(decelerate,outtwt;diffusealpha,0);
	};
	
	--Debug
	LoadFont(DebugFont)..{	--songhasmsg
		Condition=DoDebug;
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
