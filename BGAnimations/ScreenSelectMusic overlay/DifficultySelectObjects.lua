--This file handles the positioning of foreground objects when you're selecting a difficulty.
local pn,infx,infy = ...;
local txytune =		-25					--Text info altitude (Y axis) finetuning
local txxtune =		0.015625*_screen.w	--Text info separation from center (X axis) finetuning (must be always a positive value)	--20 equivalent is 0.03125*_screen.w (when using 4:3)
local saz =			0.75				--Chart info Step Artist Zoom ("saz! en toda la boca!")
local diffy =		40					--Object Y axis difference
local maxwidar =	_screen.cx*0.7	--Chart info Step Artist maxwidth value
local maxwidinf =	_screen.cx*1.1	--Chart info Text maxwidth value
local alignment = (pn == PLAYER_1) and right or left;
local negativeOffset = (pn == PLAYER_1) and 1 or -1;
local start = (pn == PLAYER_1) and SCREEN_LEFT or SCREEN_RIGHT;

local function OppositePlayer(pn)
	if pn == PLAYER_1 then
		return PLAYER_2
	end;
	return PLAYER_1
end;

--[[
This really shouldn't be here in the first place but somehow p3 and p4 don't get unjoined
when you press esc and this is an easier fix than actually fixing the damn thing
Somehow it doesn't completely crash the game so whatever I don't really give a shit
]]
if pn == "PlayerNumber_P3" or pn == "PlayerNumber_P4" then
	return Def.ActorFrame{};
end;

return Def.ActorFrame{
	InitCommand=cmd(x,start;y,_screen.cy+110;vertalign,middle,horizalign,alignment);
	SongChosenMessageCommand=cmd(stoptweening;decelerate,0.125;x,SCREEN_CENTER_X);
	SongUnchosenMessageCommand=cmd(stoptweening;accelerate,0.125*1.5;x,start;);
	
	LoadActor(pname(pn).."_info")..{		--PLAYER INFO
		InitCommand=cmd(zoomto,250,45;x,-SCREEN_CENTER_X*negativeOffset;y,-235;);
		OnCommand=function(self)
			if pn == PLAYER_1 then
				self:faderight(1):horizalign(left);
			else
				self:fadeleft(1):horizalign(right);
			end;
		end;
		--PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(pn));
	};
	
	
	LoadActor("ready")..{		--PLAYER READY
		InitCommand=cmd(visible,false;horizalign,center;x,SCREEN_LEFT-200*negativeOffset;y,-150);
		StepsChosenMessageCommand=function(self,param)
			if param.Player == pn and GAMESTATE:GetNumSidesJoined() == 2 then
				self:visible(GAMESTATE:IsHumanPlayer(pn));
			end;
		end;
		StepsUnchosenMessageCommand=cmd(visible,false);
		SongUnchosenMessageCommand=cmd(visible,false);
		["CurrentSteps"..pname(pn).."ChangedMessageCommand"]=cmd(visible,false);
	};
	Def.ActorFrame{		--Chart Info and more for P1
		InitCommand=cmd(y,-diffy);
		--Artist text
		LoadFont("monsterrat/_montserrat semi bold 60px")..{
			InitCommand=cmd(x,-60*negativeOffset;y,-175;zoom,0.215;uppercase,true;maxwidth,900;horizalign,alignment;skewx,-0.25;);
			PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(pn);queuecommand,"CurrentSteps"..pname(pn).."ChangedMessage");
			["CurrentSteps"..pname(pn).."ChangedMessageCommand"]=function(self)
				if GAMESTATE:GetCurrentSteps(pn) then
					--self:visible(true);
					local author = GAMESTATE:GetCurrentSteps(pn):GetAuthorCredit();
					if author ~= "" then
						self:maxwidth(900); --the original code did not do this but it appears like it intended to... -tertu
						self:settext(author);
					else
						self:maxwidth(1000);
						self:settext("Not available");
					end
				end;
			end;
		};
		LoadFont("monsterrat/_montserrat semi bold 60px")..{	
			InitCommand=cmd(x,-60*negativeOffset;y,-160;zoom,0.215;uppercase,true;maxwidth,900;horizalign,alignment;skewx,-0.25;);
			--PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(pn);queuecommand,"CurrentSteps"..pname(pn).."ChangedMessage");
			["CurrentSteps"..pname(pn).."ChangedMessageCommand"]=function(self)
				if GAMESTATE:GetCurrentSteps(pn) then
					self:settext(StepsTypeToString(GAMESTATE:GetCurrentSteps(pn)));
					--self:settext("123456789012345678901234567890");
					self:visible(true);
				else
					self:visible(false);
				end;
			end;
		};
		LoadActor(THEME:GetPathG("","_Figures/circle"))..{
			InitCommand=cmd(x,(-infx-txxtune)*negativeOffset;setsize,30,30;x,-40*negativeOffset;y,-175+7.5;);
			Name="Circle";
			["CurrentSteps"..pname(pn).."ChangedMessageCommand"]=function(self)
				if GAMESTATE:GetCurrentSteps(pn) then
					if GAMESTATE:GetCurrentSteps(pn):GetAuthorCredit() ~= "" then
						self:visible(true);
					else
						self:visible(false);
					end
				end;
			end;
		};
		LoadFont("monsterrat/_montserrat semi bold 60px")..{								--SPEEDMOD Display
			InitCommand=cmd(x,-40*negativeOffset;y,-175+7.5;zoom,0.215;maxwidth,130;skewx,-0.25;diffuse,color(".2,.2,.2,1"));
			["CurrentSteps"..pname(pn).."ChangedMessageCommand"]=function(self)
				if GAMESTATE:GetCurrentSteps(pn) then
					local author = GAMESTATE:GetCurrentSteps(pn):GetAuthorCredit();
					if author ~= "" then
						self:visible(true);
						local s = "";
						local sArr = split(" ",author);
						for i,v in ipairs(sArr) do
							s=s..strleft(sArr[i],1)
						end;
						self:settext(s);
					else
						self:visible(false);
					end
				end;
			end;
		};
		LoadActor("mask")..{
			InitCommand=cmd(zoomto,38,38;x,-40.5*negativeOffset;y,-175+7;MaskSource);
		};
		LoadActor(THEME:GetPathG("","USB_stuff/avatars/blank"))..{
			InitCommand=cmd(x,-40*negativeOffset;y,-175+7.5;MaskDest);
			["CurrentSteps"..pname(pn).."ChangedMessageCommand"]=function(self)
				if GAMESTATE:GetCurrentSteps(pn) then
					local author = GAMESTATE:GetCurrentSteps(pn):GetAuthorCredit();
					if author ~= "" and FILEMAN:DoesFileExist(THEME:GetCurrentThemeDirectory().."Graphics/USB_stuff/avatars/"..author..".jpg") then
						self:visible(true);
						self:Load(THEME:GetCurrentThemeDirectory().."Graphics/USB_stuff/avatars/"..author..".jpg")
						self:setsize(30,30);
						self:GetParent():GetChild("Circle"):visible(false);
					else
						self:visible(false);
					end
				else
					self:visible(false);
				end;
			end;
		};
		
		--there was some course stuff here but as it never worked properly i just removed it -tertu
		
		LoadFont("monsterrat/_montserrat semi bold 60px")..{								--SPEEDMOD Display
			InitCommand=cmd(x,-60*negativeOffset;y,-infy+txytune+10+3+20+26.25+30/3;zoom,0.215;horizalign,alignment;vertalign,top;maxwidth,900;skewx,-0.25;);
			OnCommand=function(self)
				local s = GAMESTATE:GetCurrentSong()
				if s then
					local rawbpm = s:GetDisplayBpms();
					local lobpm = math.ceil(rawbpm[1]);
					local hibpm = math.ceil(rawbpm[2]);
					local songBPMString;
					if s:IsDisplayBpmRandom() then
						songBPMString = "????"
					elseif lobpm == hibpm then
						songBPMString = lobpm
					else
						songBPMString = lobpm.."-"..hibpm
					end;
					self:settext("SONG BPM: "..songBPMString);
				end;
			end;
			["CurrentSteps"..pname(pn).."ChangedMessageCommand"]=cmd(playcommand,"On");
		};
		--[[LoadFont("monsterrat/_montserrat semi bold 60px")..{								--SPEEDMOD Display
			InitCommand=cmd(x,-60*negativeOffset;y,-infy+txytune+10+3+20+26.25+15;zoom,0.215;horizalign,alignment;vertalign,top;maxwidth,900;skewx,-0.25;);
			OnCommand=function(self)
				local xmod = GAMESTATE:GetPlayerState(pn):GetCurrentPlayerOptions():XMod();
				local cmod = GAMESTATE:GetPlayerState(pn):GetCurrentPlayerOptions():CMod();
				local mmod = GAMESTATE:GetPlayerState(pn):GetCurrentPlayerOptions():MMod();
				local curmod;
				if cmod then
					curmod = "C Mod "..cmod
					--speedvalue = cmod
				elseif mmod then
					curmod = mmod.." AV"
					--speedvalue = mmod
				else
					curmod = xmod.."x"
				end;
				self:settext("CURRENT SPEEDMOD: "..curmod);
			end;
			SpeedModChangedMessageCommand=function(self,params)
				if params.Player == pn then
					self:playcommand("On");
				end;
			end;
			OptionsListClosedMessageCommand=function(self,params)
				if params.Player == pn then
					self:playcommand("On");
				end;
			end;
		};]]
		LoadActor(THEME:GetPathG("","_Figures/circle"))..{
			InitCommand=cmd(setsize,30,30;x,-40*negativeOffset;y,-(infy+txytune+10+3+20+26.25+15)/2);
		};
		LoadFont("monsterrat/_montserrat semi bold 60px")..{								--SPEEDMOD Display
			InitCommand=cmd(x,-40*negativeOffset;y,-(infy+txytune+10+3+20+26.25+13)/2;zoom,0.215;maxwidth,130;skewx,-0.25;diffuse,color(".2,.2,.2,1"));
			OnCommand=function(self)
				local xmod = GAMESTATE:GetPlayerState(pn):GetCurrentPlayerOptions():XMod();
				local cmod = GAMESTATE:GetPlayerState(pn):GetCurrentPlayerOptions():CMod();
				local mmod = GAMESTATE:GetPlayerState(pn):GetCurrentPlayerOptions():MMod();
				local curmod;
				if cmod then
					curmod = cmod
					--speedvalue = cmod
				elseif mmod then
					curmod = mmod
					--speedvalue = mmod
				else
					curmod = xmod.."x"
				end;
				self:settext(curmod);
			end;
			SpeedModChangedMessageCommand=function(self,params)
				if params.Player == pn then
					self:playcommand("On");
				end;
			end;
			OptionsListClosedMessageCommand=function(self,params)
				if params.Player == pn then
					self:playcommand("On");
				end;
			end;
		};
		LoadFont("monsterrat/_montserrat semi bold 60px")..{								--SPEEDMOD Display
			InitCommand=cmd(x,-60*negativeOffset;y,-infy+txytune+10+3+20+26.25+24;zoom,0.215;horizalign,alignment;vertalign,top;maxwidth,900;skewx,-0.25;);
			OnCommand=function(self)
				local steps = GAMESTATE:GetCurrentSong()
				if steps and not steps:IsDisplayBpmRandom() then
					local xmod = GAMESTATE:GetPlayerState(pn):GetCurrentPlayerOptions():XMod();
					local cmod = GAMESTATE:GetPlayerState(pn):GetCurrentPlayerOptions():CMod();
					local mmod = GAMESTATE:GetPlayerState(pn):GetCurrentPlayerOptions():MMod();
					local equSpeed
					if cmod then
						equSpeed = cmod
					elseif mmod then
						local rawbpm = steps:GetDisplayBpms();
						local lobpm = math.ceil(rawbpm[1]);
						local hibpm = math.ceil(rawbpm[2]);
						if lobpm == hibpm then
							equSpeed = mmod
						else
							equSpeed = math.floor(lobpm*(mmod/hibpm)).."-"..mmod
						end;
						local res = mmod/hibpm
						if res == math.floor(res) then
							equSpeed=equSpeed.." ("..res.."x)"
						else
							equSpeed=equSpeed.." ("..string.format("%.03f",res).."x)"
						end;
					else
						local rawbpm = steps:GetDisplayBpms();
						local lobpm = math.ceil(rawbpm[1]);
						local hibpm = math.ceil(rawbpm[2]);
						if lobpm == hibpm then
							equSpeed = lobpm*xmod
						else
							equSpeed = lobpm*xmod.."-"..hibpm*xmod
						end;
					end;
					self:settext("SCROLL: "..equSpeed);
				else
					self:settext("SCROLL: ????");
				end;
			end;
			SpeedModChangedMessageCommand=function(self,params)
				if params.Player == pn then
					self:playcommand("On");
				end;
			end;
			OptionsListClosedMessageCommand=function(self,params)
				if params.Player == pn then
					self:playcommand("On");
				end;
			end;
			["CurrentSteps"..pname(pn).."ChangedMessageCommand"]=cmd(playcommand,"On");
		};
		

		LoadFont("monsterrat/_montserrat semi bold 60px")..{
			Text="YOUR BEST:";
			InitCommand=cmd(x,-60*negativeOffset;y,-infy+txytune+125;addy,5;zoom,0.25;skewx,-0.25;horizalign,alignment;vertalign,top;queuecommand,"Set";);
		};
		LoadFont("monsterrat/_montserrat semi bold 60px")..{--Machine Top Score (numbers)
			InitCommand=cmd(x,-60*negativeOffset;y,-infy+txytune+10+3+20+75+12+18;addy,5;zoom,0.25;skewx,-0.25;horizalign,alignment;vertalign,top;queuecommand,"Set";);
			CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");

			["CurrentSteps"..pname(pn).."ChangedMessageCommand"]=cmd(queuecommand,"Set");
			--PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(pn);queuecommand,"Set");
			SetCommand=function(self)
				-- ROAD24: and more checks
				-- TODO: decide what to do when no song is selected
				local cursong =	GAMESTATE:GetCurrentSong()
				if cursong and GAMESTATE:IsPlayerEnabled(pn) then
					if cursong:IsLong() then
						stagemaxscore = 200000000
					elseif cursong:IsMarathon() then
						stagemaxscore = 300000000
					else
						stagemaxscore = 100000000
					end;
					profile = PROFILEMAN:GetProfile(pn);
					scorelist = profile:GetHighScoreList(GAMESTATE:GetCurrentSong(),GAMESTATE:GetCurrentSteps(pn));
					local scores = scorelist:GetHighScores();
					local topscore = scores[1];
					if topscore then
					--	if topscore >= stagemaxscore then		--temporary workaround
					--		pscore = stagemaxscore
					--	else
							pscore = topscore:GetScore();
					--	end
					else
						pscore = "0";
					end
					--local percen = tonumber(string.format("%.03f",((pscore/stagemaxscore)*100)));
					if topscore then
						--self:settext(pscore.." - "..percen.."%");
						self:settext(pscore);
					else
						self:settext("0");
					end;
				end;
			end;
		};
		
		Def.Sprite {
			InitCommand=cmd(x,-15*negativeOffset;y,-infy+txytune+10+3+20+75+12+12;addy,10;zoom,0.15;horizalign,alignment;queuecommand,"Set";);
			CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");
			["CurrentSteps"..pname(pn).."ChangedMessageCommand"]=cmd(queuecommand,"Set");
			--PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(pn);queuecommand,"Set");
			SetCommand=function(self)
				local song = GAMESTATE:GetCurrentSong();
				if song then
					self:diffusealpha(1);
					profile = PROFILEMAN:GetProfile(pn);
					scorelist = profile:GetHighScoreList(GAMESTATE:GetCurrentSong(),GAMESTATE:GetCurrentSteps(pn));
					assert(scorelist);
					local scores = scorelist:GetHighScores();
					local topscore = scores[1];
					
					if topscore then 
						local grade = getGradeFromScore(topscore)
						self:Load(THEME:GetPathG("","GradeDisplayEval/"..grade));
					else
						--if no score
						self:diffusealpha(0);
					end
				else
					--if no song
					self:diffusealpha(0);
				end;
			end;
		};
	
		LoadFont("monsterrat/_montserrat semi bold 60px")..{	--Machine Top Score HOLDER (name)
			Text="MACHINE BEST:";
			InitCommand=cmd(x,-60*negativeOffset;y,-infy+txytune+123+35;addy,5;zoom,0.25;skewx,-0.25;horizalign,alignment;vertalign,top;);
		};
		LoadFont("monsterrat/_montserrat semi bold 60px")..{--Machine Top Score (numbers)
			InitCommand=cmd(x,-60*negativeOffset;y,-infy+txytune+10+3+20+75+12+15+36;addy,5;zoom,0.25;skewx,-0.25;horizalign,alignment;vertalign,top;queuecommand,"Set";);
			CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");

			["CurrentSteps"..pname(pn).."ChangedMessageCommand"]=cmd(queuecommand,"Set");
			--PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(pn);queuecommand,"Set");
			SetCommand=function(self)
				-- ROAD24: and more checks
				-- TODO: decide what to do when no song is selected
				local cursong =	GAMESTATE:GetCurrentSong()
				if cursong and GAMESTATE:IsPlayerEnabled(pn) then
					if cursong:IsLong() then
						stagemaxscore = 200000000
					elseif cursong:IsMarathon() then
						stagemaxscore = 300000000
					else
						stagemaxscore = 100000000
					end;
					profile = PROFILEMAN:GetMachineProfile();
					scorelist = profile:GetHighScoreList(GAMESTATE:GetCurrentSong(),GAMESTATE:GetCurrentSteps(pn));
					local scores = scorelist:GetHighScores();
					local topscore = scores[1];
					if topscore then
					--	if topscore >= stagemaxscore then		--temporary workaround
					--		pscore = stagemaxscore
					--	else
							pscore = topscore:GetScore();
					--	end
					else
						pscore = "0";
					end
					local percen = tonumber(string.format("%.03f",((pscore/stagemaxscore)*100)));
					if topscore then
						--self:settext(pscore.." - "..percen.."%");
						self:settext(pscore);
					else
						self:settext("0");
					end;
				end;
			end;
		};
		
		Def.Sprite {
			InitCommand=cmd(x,-15*negativeOffset;y,-infy+txytune+10+3+20+75+12+12+33;addy,10;zoom,0.15;horizalign,alignment;queuecommand,"Set";);
			CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");
			["CurrentSteps"..pname(pn).."ChangedMessageCommand"]=cmd(queuecommand,"Set");
			--PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(pn);queuecommand,"Set");
			SetCommand=function(self)
				local song = GAMESTATE:GetCurrentSong();
				if song then
					self:diffusealpha(1);
					profile = PROFILEMAN:GetMachineProfile();
					scorelist = profile:GetHighScoreList(GAMESTATE:GetCurrentSong(),GAMESTATE:GetCurrentSteps(pn));
					assert(scorelist);
					local scores = scorelist:GetHighScores();
					local topscore = scores[1];
					
					if topscore then 
						local grade = getGradeFromScore(topscore)
						self:Load(THEME:GetPathG("","GradeDisplayEval/"..grade));
					else
						--if no score
						self:diffusealpha(0);
					end
				else
					--if no song
					self:diffusealpha(0);
				end;
			end;
		};
	};
	
};
