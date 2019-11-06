--Extra stage handler.
extraStageSong = nil;
local isExtraStage = IsExtraStagePIU()
if isExtraStage then
	local sDir = GAMESTATE:GetCurrentSong():GetSongDir()
	local arr = split("/",sDir)
	--SCREENMAN:SystemMessage(strArrayToString(arr));
	sDir = arr[2].."/"..arr[3].."/extra1.crs"
	--SCREENMAN:SystemMessage(sDir);
	--sDir = arr[1].."/"
	if FILEMAN:DoesFileExist(sDir) then
		local songName = split(":",GetTagValue(sDir,"SONG"))[1];
		--SCREENMAN:SystemMessage(songName);
		local songsInGroup = SONGMAN:GetSongsInGroup(arr[3])
		for i,song in ipairs(songsInGroup) do
			if song:GetMainTitle() == songName then
				extraStageSong = song:GetMainTitle()
				GAMESTATE:SetPreferredSong(song);
				break
			end;
		end;
		if not extraStageSong then
			SCREENMAN:SystemMessage("Couldn't find the extra stage song!");
		end;
	end;
end;

return Def.ActorFrame{
	Def.Quad{
		Name="BGQuad";
		InitCommand=cmd(setsize,1,33;vertalign,top;x,_screen.cx;y,SCREEN_BOTTOM-259;diffuse,color("0,0,0,.8");fadeleft,.5;faderight,.5);
		--[[CurrentSongChangedMessageCommand=function(self)
			local song = GAMESTATE:GetCurrentSong()
			if song then
				
			end;
		end;]]
	};

	LoadFont("bebas/_bebas neue bold 90px")..{
		Name="Title";
		InitCommand=cmd(uppercase,true;x,_screen.cx;y,SCREEN_BOTTOM-250;zoom,0.45;maxwidth,(_screen.w/0.9);skewx,-0.1);
		CurrentSongChangedMessageCommand=function(self)
			local song = GAMESTATE:GetCurrentSong()
			if song then
				self:settext(song:GetDisplayFullTitle());
				self:finishtweening();
				
				self:diffusealpha(0);
				if isExtraStage then
					if extraStageSong == song:GetMainTitle() then
						self:diffuseshift():effectcolor1(Color("Red")):effectcolor2(Color("White")):effectperiod(1);
					else
						self:effectcolor1(Color("White"))
						--self:diffusebottomedge(color("1,1,1,0"))
					end;
				end;
				self:x(_screen.cx+75);self:sleep(0.25);self:decelerate(0.75);self:x(_screen.cx);self:diffusealpha(1);
				self:GetParent():GetChild("BGQuad"):finishtweening():linear(.25):zoomx(self:GetWidth()*.45+100);
			else
				self:stoptweening();self:linear(0.25);self:diffusealpha(0);
			end;
		end;
	};
	
	LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
		Name="Artist";
		InitCommand=cmd(xy,_screen.cx-25,SCREEN_BOTTOM-210;skewx,-.1;zoom,.75;horizalign,right;maxwidth,SCREEN_CENTER_X);
		CurrentSongChangedMessageCommand=function(self)
			local song = GAMESTATE:GetCurrentSong();
			if song then
				self:settext(song:GetDisplayArtist());
				self:stoptweening():diffusealpha(0):linear(.25):diffusealpha(1);
			end;
		end;
	};
	LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
		InitCommand=cmd(xy,_screen.cx+25,SCREEN_BOTTOM-210;skewx,-.1;zoom,.75;horizalign,left;maxwidth,SCREEN_CENTER_X);
		CurrentSongChangedMessageCommand=function(self)

			local song = GAMESTATE:GetCurrentSong();
			-- ROAD24: more checks,
			-- TODO: decide what to do if no song is chosen, ignore or hide ??
			if song then
				local speedvalue;
				if song:IsDisplayBpmRandom() then
					speedvalue = "???";
				else
					local rawbpm = GAMESTATE:GetCurrentSong():GetDisplayBpms();
					local lobpm = math.ceil(rawbpm[1]);
					local hibpm = math.ceil(rawbpm[2]);
					if lobpm == hibpm then
						speedvalue = hibpm
					else
						speedvalue = lobpm.." - "..hibpm
					end;
				end;
				self:settext("BPM "..speedvalue);
				--(cmd(finishtweening;zoomy,0;zoomx,0.5;decelerate,0.33;zoom,0.2;)) (self)
				self:stoptweening():diffusealpha(0):linear(.25):diffusealpha(1);
			else
				self:stoptweening():diffusealpha(0);
			end;
		end;
	};
}
