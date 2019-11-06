return Def.ActorFrame{
	--[[Def.Sprite{
		InitCommand=cmd(x,_screen.cx;y,_screen.cy;diffusealpha,0);
		CurrentSongChangedMessageCommand=function(self)
			self:stoptweening():diffusealpha(0);
			if GAMESTATE:GetCurrentSong() then
				if true then
					self:sleep(.4):queuecommand("Load2");
				end;
			end;
		end;
		Load2Command=function(self)
			local bg = GetSongBackground(true)
			if bg then
				--SCREENMAN:SystemMessage(bg)
				self:Load(bg):zoomto(SCREEN_WIDTH,SCREEN_HEIGHT);
			else
				local randomBGAs = FILEMAN:GetDirListing("/RandomMovies/SD/")
				if #randomBGAs > 1 then
					local bga = randomBGAs[math.random(1,#randomBGAs)]
					--SCREENMAN:SystemMessage(bga);
					self:Load("/RandomMovies/SD/"..bga);
				else
					--SCREENMAN:SystemMessage("/RandomMovies/SD/"..randomBGAs[1]);
					self:Load("/RandomMovies/SD/"..randomBGAs[1])
				end;
			end;
			self:scaletocover(0,0,SCREEN_RIGHT,SCREEN_BOTTOM):linear(.2):diffusealpha(.2);
		end;
	};]]
	Def.Sprite{
		InitCommand=cmd(x,_screen.cx;y,_screen.cy;diffusealpha,0);
		CurrentSongChangedMessageCommand=function(self)
			self:stoptweening():diffusealpha(0);
			if GAMESTATE:GetCurrentSong() then
				if GAMESTATE:GetCurrentSong():GetPreviewVidPath() == nil then
					self:sleep(.4):queuecommand("Load2");
				end;
			end;
		end;
		Load2Command=function(self)
			local bg = GetSongBackground(true)
			if bg then
				--SCREENMAN:SystemMessage(bg)
				self:Load(bg):zoomto(SCREEN_WIDTH,SCREEN_HEIGHT);
			else
				local randomBGAs = FILEMAN:GetDirListing("/RandomMovies/SD/")
				if #randomBGAs > 1 then
					local bga = randomBGAs[math.random(1,#randomBGAs)]
					--SCREENMAN:SystemMessage(bga);
					self:Load("/RandomMovies/SD/"..bga);
				else
					--SCREENMAN:SystemMessage("/RandomMovies/SD/"..randomBGAs[1]);
					self:Load("/RandomMovies/SD/"..randomBGAs[1])
				end;
			end;
			self:scaletocover(0,0,SCREEN_RIGHT,SCREEN_BOTTOM):linear(.2):diffusealpha(1);
		end;
	};
	Def.Sprite{
		--Name = "BGAPreview";
		InitCommand=cmd(x,_screen.cx;y,_screen.cy);
		CurrentSongChangedMessageCommand=cmd(stoptweening;Load,nil;sleep,.4;queuecommand,"PlayVid2");
		PlayVid2Command=function(self)
			local song = GAMESTATE:GetCurrentSong()
			path = GetBGAPreviewPath("PREVIEWVID");
			--path = song:GetBannerPath();
			self:Load(path);
			self:diffusealpha(0);
			self:zoomto(SCREEN_WIDTH,SCREEN_HEIGHT);
			self:linear(0.2);
			if path == "/Backgrounds/Title.mp4" then
				self:diffusealpha(0.5);
			else
				self:diffusealpha(1);
			end
		end;
	};
}
