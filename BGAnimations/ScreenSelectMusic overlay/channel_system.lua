local musicwheel; --Need a handle on the MusicWheel to work around a StepMania bug. Also needed to get the folders.

--==========================
--Special folders... lua doesn't have enums so this is as close as it gets.
--==========================
local WHEELTYPE_NORMAL = 0
local WHEELTYPE_PREFERRED = 1
local WHEELTYPE_SORTORDER = 2
--==========================
--Item Scroller. Must be defined at the top to have 'scroller' var accessible to the rest of the lua.
--==========================
local scroller = setmetatable({disable_wrapping= false}, item_scroller_mt)
local numWheelItems = 15

--Item scroller starts at 0, duh.
local currentItemIndex = 0;

-- Scroller function thingy
local item_mt= {
  __index= {
	-- create_actors must return an actor.  The name field is a convenience.
	create_actors= function(self, params)
	  self.name= params.name
		return Def.ActorFrame{		
			InitCommand= function(subself)
				-- Setting self.container to point to the actor gives a convenient
				-- handle for manipulating the actor.
		  		self.container= subself
		  		subself:SetDrawByZPosition(true);
		  		--subself:zoom(.75);
			end;
				

			
			Def.Sprite{
				Name="banner";
				--InitCommand=cmd(scaletofit,0,0,1,1;);
			};
			--[[Def.BitmapText{
				Name= "text",
				Font= "Common Normal",
				InitCommand=cmd(addy,100;DiffuseAndStroke,Color("White"),Color("Black");shadowlength,1);
			};]]
		};
	end,
	-- item_index is the index in the list, ranging from 1 to num_items.
	-- is_focus is only useful if the disable_wrapping flag in the scroller is
	-- set to false.
	transform= function(self, item_index, num_items, is_focus)
		local offsetFromCenter = item_index-math.floor(numWheelItems/2)
		--PrimeWheel(self.container,offsetFromCenter,item_index,numWheelItems)
		--self.container:hurrytweening(2);
		--self.container:finishtweening();
		self.container:stoptweening();
		if math.abs(offsetFromCenter) < 4 then
			self.container:decelerate(.45);
			self.container:visible(true);
		else
			self.container:visible(false);
		end;
		self.container:x(offsetFromCenter*350)
		--self.container:rotationy(offsetFromCenter*-45);
		self.container:zoom(math.cos(offsetFromCenter*math.pi/3)*.9):diffusealpha(math.cos(offsetFromCenter*math.pi/3)*.9);
		
		--[[if offsetFromCenter == 0 then
			self.container:diffuse(Color("Red"));
		else
			self.container:diffuse(Color("White"));
		end;]]
	end,
	-- info is one entry in the info set that is passed to the scroller.
	set= function(self, info)
		--self.container:GetChild("text"):settext(info);
		local banner;
		if info[1] == WHEELTYPE_SORTORDER then
			banner = THEME:GetPathG("Banner",info[3]);
		elseif info[1] == WHEELTYPE_PREFERRED then
			--Maybe it would be better to use info[3] and a graphic named CoopSongs.txt.png? I'm not sure.
			banner = THEME:GetPathG("Banner",info[2]);
		else
			banner = SONGMAN:GetSongGroupBannerPath(info[2]);
		end;
		if banner == "" then
			self.container:GetChild("banner"):Load(THEME:GetPathG("common","fallback group"));
  		else
  			self.container:GetChild("banner"):Load(banner);
  			--self.container:GetChild("text"):visible(false);
		end;
		self.container:GetChild("banner"):scaletofit(-500,-200,500,200);
	end,
	--[[gettext=function(self)
		--return self.container:GetChild("text"):gettext()
		return self.get_info_at_focus_pos();
	end,]]
}}

--==========================
--Calculate groups and such
--==========================
local hearts = GAMESTATE:GetSmallestNumStagesLeftForAnyHumanPlayer();
groups = {};
local shine_index = 1;
local names = SONGMAN:GetSongGroupNames()

selection = 1;
local spacing = 210;
local numplayers = GAMESTATE:GetHumanPlayers();

--This shit is completely broken in multiplayer.
-- Snap Songs
--[[if hearts >= 1*GAMESTATE:GetNumSidesJoined() then
	groups[#groups+1] = "00 Rave It Out (Snap Tracks)";
	if GAMESTATE:GetCurrentSong():GetGroupName() == "00 Rave It Out (Snap Tracks)" then selection = 1; end;
end;

local total_arcade_folders = #names-3;
--Arcade Songs
if hearts >=(2*GAMESTATE:GetNumSidesJoined()) then
	for i=2,total_arcade_folders do
		groups[#groups+1] = names[i];
	
		if GAMESTATE:GetCurrentSong():GetGroupName() == names[i] or GAMESTATE:GetPreferredSongGroup() == names[i] then 
			selection = i; 
		end
	end;
end

--Full Songs
if hearts >= 3*GAMESTATE:GetNumSidesJoined() then 	
	groups[#groups+1] = "80 Rave It Out (Full Tracks)";
	if GAMESTATE:GetCurrentSong():GetGroupName() == "80 Rave It Out (Full Tracks)" then selection = total_arcade_folders+1; end;
end;

-- Rave Songs
if hearts >= 4*GAMESTATE:GetNumSidesJoined() then 	
	groups[#groups+1] = "81 Rave It Out (Rave)";
	if GAMESTATE:GetCurrentSong():GetGroupName() == "81 Rave It Out (Rave)" then selection = total_arcade_folders+2; end;
end;

]]

--If the sort order is not default this will be overridden when the screen is on
local groups = {};
--SCREENMAN:SystemMessage(GAMESTATE:GetSortOrder())



--"Why does this screen take so fucking long to init?!" -Someone out there.
--Format is WHEELTYPE, name for audio and graphic (and folder name if preferred), sortorder or preferred sort file name.

function insertSpecialFolders()
	
	--Insert these... Somewhere.
	table.insert(groups, 1, {WHEELTYPE_SORTORDER, THEME:GetString("ScreenSelectGroup","SortOrder_AllDifficultyMeter"),			"SortOrder_AllDifficultyMeter"});
	table.insert(groups, 1, {WHEELTYPE_SORTORDER, THEME:GetString("ScreenSelectGroup","SortOrder_DoubleAllDifficultyMeter"),	"SortOrder_DoubleAllDifficultyMeter"});
	table.insert(groups, 1, {WHEELTYPE_SORTORDER, THEME:GetString("ScreenSelectGroup","SortOrder_Title"), 						"SortOrder_Title"});
	--SM grading is stupid
	--table.insert(groups, 1, {WHEELTYPE_SORTORDER, "Sort By Top Grades", "SortOrder_TopGrades"});
	table.insert(groups, 1, {WHEELTYPE_SORTORDER, THEME:GetString("ScreenSelectGroup","SortOrder_Artist"),	"SortOrder_Artist"});
	table.insert(groups, 1, {WHEELTYPE_SORTORDER, THEME:GetString("ScreenSelectGroup","SortOrder_BPM"),		"SortOrder_BPM"});
	table.insert(groups, 1, {WHEELTYPE_SORTORDER, THEME:GetString("ScreenSelectGroup","SortOrder_Origin"),	"SortOrder_Origin"});
end;

function genDefaultGroups()
	groups = {};
	for i,group in ipairs(getAvailableGroups()) do
		groups[i] = {WHEELTYPE_NORMAL,group}
	end;
	
	--Only show in multiplayer, since there's no need to show it in singleplayer.
	if GAMESTATE:GetNumSidesJoined() > 1 then
		table.insert(groups, 1, {WHEELTYPE_PREFERRED, "CO-OP Mode","CoopSongs.txt"})
	end;

	for i,pn in ipairs(GAMESTATE:GetEnabledPlayers()) do
		if getenv(pname(pn).."HasAnyFavorites") then
			table.insert(groups, i, {WHEELTYPE_PREFERRED, pname(pn).." Favorites", "Favorites.txt"})
		end;
	end;
	
	insertSpecialFolders();
	
	if GAMESTATE:GetCurrentSong() then
		local curGroup = GAMESTATE:GetCurrentSong():GetGroupName();
		for key,value in pairs(groups) do
			if curGroup == value[2] then
				selection = key;
			end
		end;
		setenv("cur_group",groups[selection][2]);
	else
		lua.ReportScriptError("The current song should have been set in ScreenSelectPlayMode!");
	end;
end;
function genSortOrderGroups()
	groups = {};
	for i,group in ipairs(musicwheel:GetCurrentSections()) do
		groups[i] = {WHEELTYPE_NORMAL,group}
	end;
	table.insert(groups, #groups+1, {WHEELTYPE_SORTORDER, THEME:GetString("ScreenSelectGroup","SortOrder_Group"), "SortOrder_Group"});
	insertSpecialFolders();
end;


if (GAMESTATE:GetSortOrder() == nil or GAMESTATE:GetSortOrder() == "SortOrder_Group" or GAMESTATE:GetSortOrder() == "SortOrder_Preferred") then
	genDefaultGroups();
end;


--=======================================================
--Input handler. Brought to you by PIU Delta NEX Rebirth.
--=======================================================
local button_history = {"none", "none", "none", "none"};
local function inputs(event)
	
	local pn= event.PlayerNumber
	local button = event.button
	-- If the PlayerNumber isn't set, the button isn't mapped.  Ignore it.
	--Also we only want it to activate when they're NOT selecting the difficulty.
	if not pn or not SCREENMAN:get_input_redirected(pn) then return end

	-- If it's a release, ignore it.
	if event.type == "InputEventType_Release" then return end
	
	if button == "Center" or button == "Start" then
		if groups[selection][1] == WHEELTYPE_SORTORDER then
			MESSAGEMAN:Broadcast("SortChanged",{newSort=groups[selection][3]})
			--Spin the groups cuz it will look cool.
			--It doesn't work..
			--SCREENMAN:SystemMessage("Test!");
			scroller:run_anonymous_function(function(self, info)
				self.container:stoptweening():linear(.3):rotationy(360):sleep(0):rotationy(0);
			end)
		else
			SCREENMAN:set_input_redirected(PLAYER_1, false);
			SCREENMAN:set_input_redirected(PLAYER_2, false);
			MESSAGEMAN:Broadcast("StartSelectingSong");
		end;
	elseif button == "DownLeft" or button == "Left" or button == "MenuLeft" then
		SOUND:PlayOnce(THEME:GetPathS("MusicWheel", "change"), true);
		if selection == 1 then
			selection = #groups;
		else
			selection = selection - 1 ;
		end;
		scroller:scroll_by_amount(-1);
		setenv("cur_group",groups[selection][2]);
		MESSAGEMAN:Broadcast("GroupChange");
		
	elseif button == "DownRight" or button == "Right" or button == "MenuRight" then
		SOUND:PlayOnce(THEME:GetPathS("MusicWheel", "change"), true);
		if selection == #groups then
			selection = 1;
		else
			selection = selection + 1
		end
		scroller:scroll_by_amount(1);
		setenv("cur_group",groups[selection][2]);
		MESSAGEMAN:Broadcast("GroupChange");
	--elseif button == "UpLeft" or button == "UpRight" then
		--SCREENMAN:AddNewScreenToTop("ScreenSelectSort");
	
	elseif button == "Back" then
		SCREENMAN:set_input_redirected(PLAYER_1, false);
		SCREENMAN:set_input_redirected(PLAYER_2, false);
		SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToPrevScreen");
	elseif button == "MenuDown" then
		--[[local curItem = scroller:get_actor_item_at_focus_pos().container:GetChild("banner");
		local scaledHeight = testScaleToWidth(curItem:GetWidth(), curItem:GetHeight(), 500);
		SCREENMAN:SystemMessage(curItem:GetWidth().."x"..curItem:GetHeight().." -> 500x"..scaledHeight);]]
		
		--local curItem = scroller:get_actor_item_at_focus_pos();
		--SCREENMAN:SystemMessage(ListActorChildren(curItem.container));
	else
		--SCREENMAN:SystemMessage(strArrayToString(button_history));
		--musicwheel:SetOpenSection("");
		--SCREENMAN:SystemMessage(musicwheel:GetNumItems());
		--[[local wheelFolders = {};
		for i = 1,7,1 do
			wheelFolders[#wheelFolders+1] = musicwheel:GetWheelItem(i):GetText();
		end;
		SCREENMAN:SystemMessage(strArrayToString(wheelFolders));]]
		--SCREENMAN:SystemMessage(musicwheel:GetWheelItem(0):GetText());
	end;
	
end;

local isPickingDifficulty = false;
local t = Def.ActorFrame{
	
	InitCommand=cmd(diffusealpha,0);
	OnCommand=function(self)
		SCREENMAN:GetTopScreen():AddInputCallback(inputs);
		musicwheel = SCREENMAN:GetTopScreen():GetChild('MusicWheel');
		if (GAMESTATE:GetSortOrder() == nil or GAMESTATE:GetSortOrder() == "SortOrder_Group" or GAMESTATE:GetSortOrder() == "SortOrder_Preferred") then
			scroller:set_info_set(groups, 1);
		else
			genSortOrderGroups();
			local curGroup = musicwheel:GetSelectedSection();
			--SCREENMAN:SystemMessage(curGroup);
			for key,value in pairs(groups) do
				if curGroup == value[2] then
					selection = key;
				end
			end;
			assert(groups,"REEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE")
			setenv("cur_group",groups[selection][2]);
			scroller:set_info_set(groups, 1);
		end;
		scroller:scroll_by_amount(selection-1)
	end;

	SongChosenMessageCommand=function(self)
		isPickingDifficulty = true;
	end;
	TwoPartConfirmCanceledMessageCommand=cmd(sleep,.1;queuecommand,"PickingSong");
	SongUnchosenMessageCommand=cmd(sleep,.1;queuecommand,"PickingSong");
	
	PickingSongCommand=function(self)
		isPickingDifficulty = false;
	end;
	
	CodeMessageCommand=function(self,param)
		local codeName = param.Name		-- code name, matches the one in metrics
		--player is not needed
		--local pn = param.PlayerNumber	-- which player entered the code
		if codeName == "GroupSelectPad1" or codeName == "GroupSelectPad2" or codeName == "GroupSelectButton1" or codeName == "GroupSelectButton2" then
			if isPickingDifficulty then return end; --Don't want to open the group select if they're picking the difficulty.
			MESSAGEMAN:Broadcast("StartSelectingGroup");
			--SCREENMAN:SystemMessage("Group select opened.");
			--No need to check if both players are present... Probably.
			SCREENMAN:set_input_redirected(PLAYER_1, true);
			SCREENMAN:set_input_redirected(PLAYER_2, true);
			musicwheel:Move(0);
		else
			--Debugging only
			--SCREENMAN:SystemMessage(codeName);
		end;
	end;
	
	StartSelectingGroupMessageCommand=function(self,params)
		local curItem = scroller:get_actor_item_at_focus_pos();
		--SCREENMAN:SystemMessage(ListActorChildren(curItem.container));
		curItem.container:GetChild("banner"):stoptweening():scaletofit(-500,-200,500,200);
		self:stoptweening():linear(.5):diffusealpha(1);
		SOUND:DimMusic(0.3,65536);
		MESSAGEMAN:Broadcast("GroupChange");
	end;

	StartSelectingSongMessageCommand=function(self)
		self:linear(.3):diffusealpha(0);
		scroller:get_actor_item_at_focus_pos().container:GetChild("banner"):linear(.3):zoom(0);
	end;
	
	--Why is this even here? It could be in the above function...
	SortChangedMessageCommand=function(self,params)
		--Reset button history when the sort selection screen closes.
		--button_history = {"none", "none", "none", "none"};
	
		if musicwheel:ChangeSort(params.newSort) then
			if GAMESTATE:GetSortOrder() == "SortOrder_Group" then
				genDefaultGroups();
			else
				genSortOrderGroups();
			end;
			selection = 1
			--SCREENMAN:SystemMessage("SortChanged")
			scroller:set_info_set(groups, 1);
			setenv("cur_group",groups[selection][2]);
			--scroller:set_info_set({"aaa","bbb","ccc","ddd"},1);
			--Update the text that says the current group.
			MESSAGEMAN:Broadcast("GroupChange");
		end;
	end;
}


local lastSort = nil;
function setSort(sort)
	lastSort = sort;
	SCREENMAN:GetTopScreen():GetMusicWheel():ChangeSort(sort);
end;

-- GENRE SOUNDS
t[#t+1] = LoadActor(THEME:GetPathS("","nosound.ogg"))..{
	InitCommand=cmd(stop);
	StartSelectingSongMessageCommand=function(self)
		SOUND:DimMusic(1,65536);
		
		--local sel = scroller:get_info_at_focus_pos();
		if groups[selection][1] == WHEELTYPE_PREFERRED then
			setSort("SortOrder_Preferred")
			SONGMAN:SetPreferredSongs(groups[selection][3]);
			self:load(THEME:GetPathS("","Genre/"..groups[selection][2]));
			SCREENMAN:GetTopScreen():GetMusicWheel():SetOpenSection(groups[selection][2]);
		else
			if GAMESTATE:GetSortOrder() == "SortOrder_Preferred" then
				setSort("SortOrder_Group")
				--MESSAGEMAN:Broadcast("StartSelectingSong");
				-- Odd, changing the sort order requires us to call SetOpenSection more than once
				SCREENMAN:GetTopScreen():GetMusicWheel():ChangeSort(sort);
				--[[SCREENMAN:GetTopScreen():CloseCurrentSection();
				SCREENMAN:GetTopScreen():GetMusicWheel():SetOpenSection("");
				SCREENMAN:GetTopScreen():PostScreenMessage( 'SM_SongChanged', 0.1 );]]
				SCREENMAN:GetTopScreen():GetMusicWheel():SetOpenSection(groups[selection][2]);
				--[[SCREENMAN:GetTopScreen():GetMusicWheel():Move(1)
				SCREENMAN:GetTopScreen():GetMusicWheel():Move(0);
				SCREENMAN:SystemMessage(SCREENMAN:GetTopScreen():GetMusicWheel():GetSelectedSection())
				SCREENMAN:GetTopScreen():GetMusicWheel():SetOpenSection(groups[selection]);
				SCREENMAN:GetTopScreen():GetMusicWheel():ChangeSort(sort);
				SCREENMAN:GetTopScreen():GetMusicWheel():SetOpenSection(groups[selection]);
				SCREENMAN:GetTopScreen():PostScreenMessage( 'SM_SongChanged', 0.1 );]]
			end;
			SCREENMAN:GetTopScreen():GetMusicWheel():SetOpenSection(groups[selection][2]);
			--SCREENMAN:SystemMessage(groups[selection]);
			--It works... But only if there's a banner.
			local fir = SONGMAN:GetSongGroupBannerPath(getenv("cur_group"));
			if fir then
				self:load(soundext(gisub(fir,'banner.png','info/sound')));
			end;
		end;
		SCREENMAN:GetTopScreen():PostScreenMessage( 'SM_SongChanged', 0.1 );

		--Unreliable, current song doesn't update fast enough.
		--[[if SONGMAN:WasLoadedFromAdditionalSongs(GAMESTATE:GetCurrentSong()) then
			self:load(soundext("/AdditionalSongs/"..getenv("cur_group").."/info/sound"));
		else
			self:load(soundext("/Songs/"..getenv("cur_group").."/info/sound"));
		end]]
		--Make it louder
		self:play();
		self:play();
	end;
};

--THE BACKGROUND VIDEO
t[#t+1] = LoadActor(THEME:GetPathG("","background/common_bg"))..{
		InitCommand=cmd(diffusealpha,0);
		StartSelectingGroupMessageCommand=cmd(stoptweening;linear,0.35;diffusealpha,1);
		StartSelectingSongMessageCommand=cmd(stoptweening;linear,0.3;diffusealpha,0);
	};

t[#t+1] = Def.Quad{
	InitCommand=cmd(Center;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;diffuse,0,0,0,0;fadetop,1;blend,Blend.Add);
	StartSelectingGroupMessageCommand=cmd(stoptweening;linear,0.35;diffusealpha,0.87);
	StartSelectingSongMessageCommand=cmd(stoptweening;linear,0.3;diffusealpha,0);
}
--FLASH
t[#t+1] = Def.Quad{
	InitCommand=cmd(Center;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;diffuse,1,1,1,0);
	StartSelectingSongMessageCommand=cmd(stoptweening;diffusealpha,1;linear,0.3;diffusealpha,0);
};

--Add scroller here
t[#t+1] = scroller:create_actors("foo", numWheelItems, item_mt, SCREEN_CENTER_X, SCREEN_CENTER_Y);

	--Current Group/Playlist
t[#t+1] = LoadActor("current_group")..{
		InitCommand=cmd(x,0;y,5;horizalign,left;vertalign,top;zoomx,1;cropbottom,0.3);
		StartSelectingGroupMessageCommand=cmd(stoptweening;linear,0.35;diffusealpha,1;playcommand,"Text");
		StartSelectingSongMessageCommand=cmd(stoptweening;linear,0.3;diffusealpha,0);
	};
	
t[#t+1] = LoadFont("monsterrat/_montserrat light 60px")..{	
		InitCommand=cmd(uppercase,true;horizalign,left;x,SCREEN_LEFT+18;y,SCREEN_TOP+10;zoom,0.185;skewx,-0.1);
		StartSelectingGroupMessageCommand=cmd(stoptweening;linear,0.35;diffusealpha,1;playcommand,"GroupChangeMessage");
		StartSelectingSongMessageCommand=cmd(stoptweening;linear,0.3;diffusealpha,0);
		GroupChangeMessageCommand=function(self)
			self:uppercase(true);
			self:settext("Set songlist");
		end;
	};
	
t[#t+1] = LoadFont("monsterrat/_montserrat semi bold 60px")..{
		Name="CurrentGroupName";
		InitCommand=cmd(uppercase,true;horizalign,left;x,SCREEN_LEFT+16;y,SCREEN_TOP+30;zoom,0.6;skewx,-0.25);
		StartSelectingGroupMessageCommand=cmd(stoptweening;linear,0.35;diffusealpha,1;playcommand,"GroupChangeMessage");
		StartSelectingSongMessageCommand=cmd(stoptweening;linear,0.3;diffusealpha,0);
		GroupChangeMessageCommand=function(self)
			--[[if string.find(getenv("cur_group"),"Rave It Out") then
				self:settext(string.sub(getenv("cur_group"), 17, string.len(getenv("cur_group"))-1));
			else
				self:settext(string.sub(getenv("cur_group"), 4, string.len(getenv("cur_group"))));
			end;]]
			if not getenv("cur_group") then
				self:settext("cur_group env var missing!");
			else
				self:settext(string.gsub(getenv("cur_group"),"^%d%d? ?%- ?", ""));
			end;
		end;
	};
	
--Game Folder counters
--Text BACKGROUND
t[#t+1] = LoadActor("songartist_name")..{
	InitCommand=cmd(x,_screen.cx;y,SCREEN_BOTTOM-75;diffusealpha,0;zoomto,547,46);
	StartSelectingGroupMessageCommand=cmd(stoptweening;linear,0.35;diffusealpha,1;playcommand,"Text");
	StartSelectingSongMessageCommand=cmd(stoptweening;linear,0.3;diffusealpha,0);
};

t[#t+1] = LoadFont("monsterrat/_montserrat light 60px")..{
	InitCommand=cmd(Center;zoom,0.2;y,SCREEN_BOTTOM-75;uppercase,true;strokecolor,0,0.15,0.3,0.5;diffusealpha,0;);
	StartSelectingGroupMessageCommand=cmd(stoptweening;linear,0.35;diffusealpha,1;playcommand,"GroupChangeMessage");
	StartSelectingSongMessageCommand=cmd(stoptweening;linear,0.3;diffusealpha,0);
	GroupChangeMessageCommand=function(self)
		self:finishtweening();
		self:linear(0.3);
		self:diffusealpha(1);
		songcounter = string.format(THEME:GetString("ScreenSelectGroup","SongCount"),#SONGMAN:GetSongsInGroup(getenv("cur_group"))-1)
		foldercounter = string.format("%02i",selection).." / "..string.format("%02i",#groups)
		self:settext(songcounter.."\n"..foldercounter);
	end;
};

t[#t+1] = 	LoadActor("arrow_shine")..{};
--[[t[#t+1] = Def.Quad{
	InitCommand=cmd(diffuse,color("0,0,0,.8");setsize,SCREEN_WIDTH,SCREEN_HEIGHT;Center);

};
t[#t+1] = LoadFont("monsterrat/_montserrat light 60px")..{
	InitCommand=cmd(x,SCREEN_CENTER_X;vertalign,top;diffuse,Color("White");zoom,.25;addy,100;);
	OnCommand=function(self)
		local sect = musicwheel:GetCurrentSections()
		local aa = ""
		for i = 1, #sect do
			aa = aa..sect[i].."\n,"
		end;
		self:settext(aa);
	end;
	SortChangedMessageCommand=cmd(playcommand,"On");
};]]

return t;
