--[[
For title screen. Will show InternalName:Version
Ex:
RIO:2018-10-04
DISPLAY TYPE: HD
]]
SysInfo = {
	InternalName = "RIO4W",
	Version = "2020-01-31",
}

RIO_FOLDER_NAMES = {
	EasyFolder = "99-Easy", --To be removed at a later date, but I'm working on it...
	SpecialFolder = "99-Special",
	SnapTracksFolder = "00-Snap Tracks", --To be removed at a later date, but I'm working on it...
	--[[
	If this is set the game will use it for arcade mode. If not, it will pick a random folder,
	but ONLY if you aren't playing with a profile. Profiles will resume from their last played song
	as StepMania intended.
	Also the code for picking a random song is somewhere in ScreenSelectPlayMode.
	]]
	DefaultArcadeFolder,
	--The groups that are shown in the group select in the order you want them displayed.
	--If this is empty all groups will be shown.
	PREDEFINED_GROUP_LIST = {}
}

--[[
What course folders will show in mixtapes mode.
It's necessary because we have mission mode folders
and we don't want them to pollute the mixtapes folders...

Class types: Normal, Pro, Gauntlet
]]
RIO_COURSE_FOLDERS = {
	"Class (Singles)",
	"Class (Doubles)",
	--"PIU Class (Singles)",
	--"PIU Class (Doubles)",
	"Mixtapes",
	"Leggendaria",
	"Default"
}

--Take a wild guess. #SONGTYPE:shortcut will override this.
MAX_SECONDS_FOR_SHORTCUT = 95

--Number of hearts a mission will take in quest mode.
HEARTS_PER_MISSION = 3

--Extra stage song.
--If true, uses the song below, if false, uses extra1.crs.
USE_ES_SONG = true
ES_SONG = "09-Season 2 FINAL/Faded"
--The song that gets picked for the One More Extra Stage.
OMES_SONG = "Ace For Aces (OMES Test)"

-- These names will not show up over the difficulty icons.
STEPMAKER_NAMES_BLACKLIST = {
	"C.Cortes",
	"A.Vitug",
	"C.Rivera",
	"J.España",
	"Anbia",
	"C.Guzman",
	"C.Sacco",
	"A.DiPasqua",
	"A.Bruno",
	"P.Silva",
	"P. Silva",
	"M.Oliveira",
	"M.Oliveria",
	"W.Fitts",
	"Z.Elyuk",
	"P.Cardoso",
	"A.Perfetti",
	"S.Hanson",
	"D.Juarez",
	"P.Shanklin",
	"P. Shanklin",
	"S.Cruz",
	"C.Valdez",
	"E.Muciño",
	"V.Kim",
	"V. Kim",
	"V.Rusfandy",
	"T.Lee",
	"M.Badilla",
	"P.Agam",
	"P. Agam",
	"B.Speirs",
	"N.Codesal",
	"F.Keint",
	"F.Rodriguez",
	"T.Rodriguez",
	"B.Mahardika",
	"A.Sofikitis",
	"Furqon",
	"Blank",
	--S2 names
	"A.Sora",
	"Accelerator",
	"S. Ferri",
	"G.Shawn"
}


--Based on GAMESTATE:GetCurrentSong():GetDisplayFullTitle().."||"..GAMESTATE:GetCurrentSong():GetDisplayArtist()
--List of songs that will get your recording blocked worldwide
--[[STREAM_UNSAFE_AUDIO = {
	"Breaking The Habit||Linkin Park",
	"She Wolf (Falling to Pieces)||David Guetta ft. Sia",
	"Untouched||The Veronicas",
	"Cold||Crossfade",
	"Sexy Bitch||David Guetta feat. Akon",
	"Talk Dirty||Jason DeRulo feat. 2 Chainz",
	"Face My Fears||Utada Hikaru ft. Skrillex" --Test song
}

--List of BGAs that will get your recording blocked worldwide
--Where is this parameter used?
STREAM_UNSAFE_VIDEO = {
	"Good Feeling",
	"I Wanna Go",
	"Jaleo",
	"Breakin' A Sweat",
	"Through the Fire and Flames",
	"How I Feel",
	"Don't Stop The Party"
}]]

--Looking for titles and avatars? Check unlocks.lua.
