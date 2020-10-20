-- Timerseconds for this screen is controlled by:
-- NextStageSleepTime+WallpaperSleepTime values in ScreenProfileSaveOverlay
-- Wallpaper transition system by ROAD24 and NeobeatIKK
-- and modified by Rhythm Lunatic!

local t =							Def.ActorFrame{};
local SongsPlayed =					STATSMAN:GetAccumPlayedStageStats():GetPlayedSongs();
local LastSong =					SongsPlayed[#SongsPlayed]
local ShowRIOLogo =					true; --Since we dont use RIO wallpapers for RIO:WE
--
function getRandomWall()
-- Cortes quiere random wallpaper, este script cargara de forma aleatoria
--  una imagen dentro del folder _RandomWalls en BGAnimations
	local sImagesPath = THEME:GetPathG("","_RandomWalls/HDWalls");
	local sRandomWalls = FILEMAN:GetDirListing(sImagesPath.."/",false,true);
	-- El random seed
	 math.randomseed(Hour()*3600+Second());
	return sRandomWalls[math.random(#sRandomWalls)];
end;

local bonusSongBG = nil;
--Always show bonus BG because it makes the songs cooler imo
if FILEMAN:DoesFileExist(LastSong:GetSongDir().."/specialBG.png") then
	bonusSongBG = LastSong:GetSongDir().."/specialBG.png"
	ShowRIOLogo = true;
elseif FILEMAN:DoesFileExist(LastSong:GetSongDir().."/specialBG.jpg") then
	bonusSongBG = LastSong:GetSongDir().."/specialBG.jpg"
	ShowRIOLogo = true;
end;

if bonusSongBG then
	t[#t+1] = Def.ActorFrame{
		LoadActor(bonusSongBG)..{
			InitCommand=cmd(Cover);
		};
	};
else
	t[#t+1] = Def.ActorFrame{
		LoadActor(getRandomWall())..{
			InitCommand=cmd(Cover);
		};
	};

end;
if ShowRIOLogo then				--load rio logo in bottom right corner
	--t[#t+1] = LoadActor("_wallpaperriologo.lua");
	t[#t+1] = LoadActor(THEME:GetPathG("","logo"))..{
		InitCommand=cmd(horizalign,right;vertalign,bottom;xy,SCREEN_RIGHT,SCREEN_BOTTOM-25;zoom,.25);
	};
end;



return t
