local t = Def.ActorFrame{};

local function GetTagValue(readfile,tag)
	local fnd = string.find(readfile , "#"..tag..":")
	if not fnd then return nil end
	local last = string.find(readfile , ";" , fnd)
	local found = string.sub(readfile,fnd,last)
	found = string.gsub(found, "\r", "")
	found = string.gsub(found, "\n", "")
	found = string.gsub(found,  "#"..tag..":", "")
	found = string.gsub(found, ";", "")
	return found
end;

--To generate shapes
function parallelogramGen(width,height,clr)
	return Def.ActorFrame{
		Def.Quad{
			InitCommand=cmd(setsize,width-height,height;diffuse,clr);
		};
		Def.ActorMultiVertex{
			InitCommand=function(self)
				self:xy((width-height)/2,-height/2);
				self:SetDrawState{Mode="DrawMode_Triangles"}
				self:SetVertices({
					{{0, 0, 0}, clr},
					{{height, 0, 0}, clr},
					{{0, height, 0}, clr}
			
				});
			end;
		};
		Def.ActorMultiVertex{
			InitCommand=function(self)
				self:xy(-(width+height)/2,-height/2);
				self:SetDrawState{Mode="DrawMode_Triangles"}
				self:SetVertices({
					{{height, height, 0}, clr},
					{{0, height, 0}, clr},
					{{height, 0, 0}, clr}
				});
			end;
		};

	};
end

function rectGen(width, height, lineSize, bgColor)
    return Def.ActorFrame{
    
        --Background transparency
        Def.Quad{
            InitCommand=cmd(setsize,width, height;diffuse,bgColor);
            
        };
        --Bottom line
        Def.Quad{
            InitCommand=cmd(setsize,width + lineSize, lineSize;addy,height/2;--[[horizalign,0;vertalign,2]]);
            
        };
        --Top line
        Def.Quad{
            InitCommand=cmd(setsize,width + lineSize, lineSize;addy,-height/2;--[[horizalign,2;vertalign,0]]); --2 = right aligned
            
        };
        --Left line
        Def.Quad{
            InitCommand=cmd(setsize,lineSize, height + lineSize;addx,-width/2;--[[vertalign,0;horizalign,2]]); --2 = right aligned
            
        };
        --Right line
        Def.Quad{
            InitCommand=cmd(setsize,lineSize, height + lineSize;addx,width/2;--[[vertalign,2;horizalign,0]]); --2 = bottom aligned
            
        };
    };
end;

function CanSafelyEnterGameplayCourse()
	for pn in ivalues(GAMESTATE:GetEnabledPlayers()) do
		if GAMESTATE:GetCurrentTrail(pn) == nil and GAMESTATE:IsPlayerEnabled(pn) then
			return false,"Trail for "..pname(pn).." was not set.";
		end
	end;
	if not GAMESTATE:GetCurrentCourse() then
		return false,"No course was set."
	end;
	if GAMESTATE:GetCurrentSong() then
		return false,"There is a song set in GAMESTATE."
	end;
	if not GAMESTATE:IsCourseMode() then
		return false,"The IsCourseMode flag was not set."
	end;
	return true
end


--Hackjob for now, fix this later.
GAMESTATE:SetCurrentSong(nil);
for pn in ivalues(GAMESTATE:GetEnabledPlayers()) do
	GAMESTATE:SetCurrentStyle("Single");
	GAMESTATE:GetPlayerState(pn):GetPlayerOptions('ModsLevel_Preferred'):NoteSkin("delta-note")
	GAMESTATE:ApplyPreferredSongOptionsToOtherLevels()
end;

--1 indexed, because lua.
local currentMissionNum;
local currentGroupNum = 1;
local NUM_MISSION_GROUPS = #RIO_COURSE_GROUPS[QUESTMODE.currentWorld]
--Needs to be defined up here
local GroupCache = {};

function setCurrentCourse()
	local course = GroupCache.courses[currentMissionNum]
	GAMESTATE:SetCurrentCourse(course);
	local trail = course:GetAllTrails()[1]
	if trail then
		for pn in ivalues(GAMESTATE:GetEnabledPlayers()) do
			GAMESTATE:SetCurrentTrail(pn, trail)
			--GAMESTATE:SetCurrentSteps(pn, trail:GetTrailEntry(0):GetSteps());
		end;
	else
		SCREENMAN:SystemMessage("Trail was nil! Number of trails: "..#course:GetAllTrails().. " | Course: "..course:GetDisplayFullTitle());
	end;
	
	QUESTMODE.CurMissionRequirements = {
		minGrade = GroupCache.courseRequirements[currentMissionNum].minGrade,
		minCombo = GroupCache.courseRequirements[currentMissionNum].minCombo,
		minAccuracy = GroupCache.courseRequirements[currentMissionNum].minAccuracy,
		maxBreak = GroupCache.courseRequirements[currentMissionNum].maxBreak
	};
	--setenv("BreakCombo",GroupCache.courseRequirements[currentMissionNum].limitBreak or THEME:GetMetric("CustomRIO","MissToBreak"));
end

function updateGroupCache()
	GroupCache.currentGroup = RIO_COURSE_GROUPS[QUESTMODE.currentWorld][currentGroupNum];
	--Clear courses from the table.
	GroupCache.courses = {}
	GroupCache.courseRequirements = {};
	for course in ivalues(SONGMAN:GetCoursesInGroup(GroupCache.currentGroup,false)) do
		--assert(course,"Hey idiot, don't give an invalid course");
		local readfile = File.Read( course:GetCourseDir() )
		local missionNum = GetTagValue(readfile,"MISSIONID")
		if missionNum and missionNum ~= "" then
			missionNum = tonumber(missionNum)
			GroupCache.courses[missionNum] = course
		else
			lua.ReportScriptError("Course "..course:GetDisplayFullTitle().. " doesn't have a #MISSIONID tag.")
		end;
		
		GroupCache.courseRequirements[missionNum] = {
			minGrade = GetTagValue(readfile,"MINGRADE"),
			minCombo = GetTagValue(readfile,"MINCOMBO"),
			minAccuracy = GetTagValue(readfile,"MINACCURACY"),
			maxBreak = GetTagValue(readfile,"MAXBREAK")
			--limitBreak = GetTagValue(readfile,"LIMITBREAK") --limit break is fucking dumb anyway just use #LIFE for missions
		}
		
	end
	GroupCache.numCourses = #GroupCache.courses;
	assert(GroupCache.numCourses > 0,"GroupCache did not generate corrrectly. Course folder '"..GroupCache.currentGroup.."' either has no valid songs or doesn't exist.");
	--Reset the mission num when switching groups.
	currentMissionNum = 1;
	setCurrentCourse();
	MESSAGEMAN:Broadcast("CurrentMissionGroupChanged");
end;
updateGroupCache();


t[#t+1] = Def.ActorFrame{
	--Header stuff
	LoadActor(THEME:GetPathB("","ScreenSelectMusic overlay/current_group"))..{
		InitCommand=cmd(x,SCREEN_LEFT;y,SCREEN_TOP+5;horizalign,left;vertalign,top;zoomx,1;cropbottom,0.3);
	};
	LoadFont("monsterrat/_montserrat light 60px")..{	
		InitCommand=cmd(uppercase,true;horizalign,left;x,SCREEN_LEFT+18;y,SCREEN_TOP+10;zoom,0.185;skewx,-0.1);
		OnCommand=function(self)
			self:uppercase(true);
			self:settext("QUEST MODE");
		end;
	};
	LoadFont("monsterrat/_montserrat semi bold 60px")..{	
		InitCommand=cmd(uppercase,true;horizalign,left;x,SCREEN_LEFT+16;y,SCREEN_TOP+30;zoom,0.6;skewx,-0.255);
		OnCommand=function(self)
			self:uppercase(true);
			self:settext("SELECT A MISSION");
		end;
	};
	
	--TIME
	--[[LoadFont("monsterrat/_montserrat light 60px")..{
			Text="TIME";
			InitCommand=cmd(x,SCREEN_CENTER_X-25;y,SCREEN_BOTTOM-92;zoom,0.6;skewx,-0.2);
	};]]
	
	Def.Quad{
		InitCommand=cmd(diffuse,color("0,0,0,.5");setsize,300,50;xy,200,90;);
	};
	LoadFont("Common Normal")..{
		Text="Mission Group Name Goes here";
		InitCommand=cmd(xy,200,90;wrapwidthpixels,300);
		OnCommand=function(self)
			self:settext(GroupCache.currentGroup);
		end;
		CurrentMissionGroupChangedMessageCommand=cmd(playcommand,"On");
	
	};
	Def.Quad{
		InitCommand=cmd(diffuse,color("0,0,0,.5");setsize,120,20;xy,200+160,90-50/2;horizalign,left;vertalign,top;);
	};
	Def.ActorMultiVertex{
		InitCommand=function(self)
			self:xy(200+160+120,90-50/2);
			self:SetDrawState{Mode="DrawMode_Triangles"}
            self:SetVertices({
                {{0, 0, 0}, color("0,0,0,.5")},
        		{{0, 20, 0}, color("0,0,0,.5")},
				{{20, 0, 0}, color("0,0,0,.5")}
            });
        end;
	};
	--[[LoadFont("Common Normal")..{
		Condition=RIO_COURSE_GROUPS[currentGroupNum+1];
		Text=RIO_COURSE_GROUPS[currentGroupNum+1];
		InitCommand=cmd(xy,200+160,90-50/2;horizalign,left;vertalign,top;maxwidth,120);
	};]]
	
	--Mission 2...
	parallelogramGen(130,20,color("0,0,0,.5"))..{
		InitCommand=cmd(xy,560,90-50/2+20/2;);
	};
	--Mission 3..
	parallelogramGen(130,20,color("0,0,0,.5"))..{
		InitCommand=cmd(xy,560+130+5,90-50/2+20/2;);
	};
	

	--Mission info..
	Def.Quad{
		InitCommand=cmd(setsize,410,300;diffuse,color("0,0,0,.5");xy,200+160,100;horizalign,left;vertalign,top;);
	};
	--Mission title
	LoadFont("monsterrat/_montserrat semi bold 60px")..{	
		InitCommand=cmd(xy,200+160+410/2,110;vertalign,top;zoom,0.6;skewx,-0.255;maxwidth,650);
		--Text="aaaaaaaaaaaaaaaaaaaaaaaaaaaa";
		OnCommand=cmd(settext,GroupCache.courses[currentMissionNum]:GetDisplayFullTitle();stoptweening;diffusealpha,0;x,200+160+410/2+75;decelerate,0.5;x,200+160+410/2;diffusealpha,1;);
		CurrentCourseChangedMessageCommand=cmd(playcommand,"On");
		CurrentMissionGroupChangedMessageCommand=cmd(playcommand,"On");
	};
	--Title underline
	Def.Quad{
		InitCommand=cmd(setsize,410,2;diffuse,color("1,1,1,1");xy,200+160,140;horizalign,left;vertalign,top;fadeleft,.8;faderight,.8;);
	};
	--Mission requirements
	--[[Def.Sprite{
		Texture=THEME:GetPathG("QuestMode","MissionRequirements");
		InitCommand=cmd(Resize,SCREEN_WIDTH,SCREEN_HEIGHT;Center);
	};]]
	Def.ActorFrame{
		CurrentCourseChangedMessageCommand=function(self)
			local r = QUESTMODE.CurMissionRequirements;
			if r.maxBreak then
				self:GetChild("BreakText"):settext(r.maxBreak):visible(true);
				self:GetChild("BreakBG"):diffusealpha(1);
			else
				self:GetChild("BreakText"):visible(false);
				self:GetChild("BreakBG"):diffusealpha(.5);
			end;
			
			if r.minCombo then
				self:GetChild("ComboText"):settext(r.minCombo):visible(true);
				self:GetChild("ComboBG"):diffusealpha(1);
			else
				self:GetChild("ComboText"):visible(false);
				self:GetChild("ComboBG"):diffusealpha(.5);
			end;
			
			if r.minGrade then
				self:GetChild("GradeText"):Load(THEME:GetPathG("","GradeDisplayEval/"..r.minGrade)):visible(true);
				self:GetChild("GradeBG"):diffusealpha(1);
			else
				self:GetChild("GradeText"):visible(false);
				self:GetChild("GradeBG"):diffusealpha(.5);
			end;
			
			if r.minAccuracy then
				self:GetChild("AccuracyText"):settext(r.minAccuracy.."%"):visible(true);
				self:GetChild("AccuracyBG"):diffusealpha(1);
			else
				self:GetChild("AccuracyText"):visible(false);
				self:GetChild("AccuracyBG"):diffusealpha(.5);
			end;
			
		end;
	
		InitCommand=cmd(xy,200+160+410/2,110+220;);
		Def.Sprite{
			Name="MissionBG";
			Texture=THEME:GetPathG("QuestMode","MissionBG");
			InitCommand=cmd(zoom,.67);
			--InitCommand=cmd(zoomy,.2;zoomx,.46;diffusealpha,.5);
		};
		--left
		Def.Sprite{
			Name="BreakBG";
			Texture=THEME:GetPathG("QuestMode","BreakRequirement");
			InitCommand=cmd(zoom,.67;addx,-180+360/4*1-360/4/2);
		};
		LoadFont("monsterrat/_montserrat light 60px")..{
			Name="BreakText";
			--(SCREEN_WIDTH/numChoices*i-SCREEN_WIDTH/numChoices/2)
			InitCommand=cmd(zoom,.5;addy,-5;addx,-180+360/4*1-360/4/2;maxwidth,130);
			OnCommand=function(self)
				--self:uppercase(true);
				self:settext("123");
			end;
		};
		
		--Left
		Def.Sprite{
			Name="ComboBG";
			Texture=THEME:GetPathG("QuestMode","ComboRequirement");
			InitCommand=cmd(zoom,.67;addx,-180+360/4*2-360/4/2);
		};
		LoadFont("monsterrat/_montserrat light 60px")..{
			Name="ComboText";
			InitCommand=cmd(zoom,.5;addy,-5;addx,-180+360/4*2-360/4/2;maxwidth,130);
			OnCommand=function(self)
				--self:uppercase(true);
				self:settext("456");
			end;
		};
		
		Def.Sprite{
			Name="AccuracyBG";
			Texture=THEME:GetPathG("QuestMode","AccuracyRequirement");
			InitCommand=cmd(zoom,.67;addx,-180+360/4*3-360/4/2);
		};
		LoadFont("monsterrat/_montserrat light 60px")..{
			Name="AccuracyText";
			InitCommand=cmd(zoom,.5;addy,-5;addx,-180+360/4*3-360/4/2;maxwidth,130);
			OnCommand=function(self)
				self:settext("15%");
			end;
		};
		--Left
			Def.Sprite{
			Name="GradeBG";
			Texture=THEME:GetPathG("QuestMode","GradeRequirement");
			InitCommand=cmd(zoom,.67;addx,-180+360/4*4-360/4/2);
		};
		Def.Sprite{
			Name="GradeText";
			Texture=THEME:GetPathG("","GradeDisplayEval/B");
			--The grade icons are 2px off for whatever dumb reason
			InitCommand=cmd(zoom,.25;addy,-5;addx,-182+360/4*4-360/4/2;);
		};
	};
	
	
	--Mission description, if there is one
	LoadFont("facu/_zona pro bold 40px")..{
		Text="Mission Description Goes Here";
		InitCommand=cmd(xy,360+410/2,288;vertalign,bottom;maxwidth,700;skewx,-0.255;zoom,.5);
		OnCommand=cmd(settext,GroupCache.courses[currentMissionNum]:GetDescription();stoptweening;diffusealpha,0;decelerate,.2;diffusealpha,1;);
		CurrentCourseChangedMessageCommand=cmd(playcommand,"On");
	};

	--[[Def.Quad{
		InitCommand=cmd(setsize,410,80;diffuse,color("1,1,1,.2");xy,200+160,150;horizalign,left;vertalign,top;);
	};]]
	
	Def.Quad{
		InitCommand=cmd(diffuse,color("1,1,1,.5");setsize,300,35;xy,200,135;);
		CodeMessageCommand=function(self, params)
			if params.Name == "UpLeft" then
				if currentGroupNum > 1 then
					currentGroupNum = currentGroupNum-1;
					updateGroupCache();
					SOUND:PlayOnce(THEME:GetPathS("","iidx/syssd_sub_opt"),true);
				end;
			elseif params.Name== "UpRight" then
				if currentGroupNum < NUM_MISSION_GROUPS then
					currentGroupNum = currentGroupNum+1;
					updateGroupCache();
					SOUND:PlayOnce(THEME:GetPathS("","iidx/syssd_sub_opt"),true);
				end;
			elseif params.Name == "DownLeft" then
				if currentMissionNum > 1 then
					currentMissionNum = currentMissionNum -1;
					setCurrentCourse()
					MESSAGEMAN:Broadcast("CurrentCourseChanged")
					self:stoptweening():decelerate(.2):y(135+35*(currentMissionNum-1));
					SOUND:PlayOnce(THEME:GetPathS("MusicWheel","change"),true);
				end;
			elseif params.Name == "DownRight" then
				if currentMissionNum < GroupCache.numCourses then
					currentMissionNum = currentMissionNum + 1;
					setCurrentCourse()
					MESSAGEMAN:Broadcast("CurrentCourseChanged")
					self:stoptweening():decelerate(.2):y(135+35*(currentMissionNum-1));
					SOUND:PlayOnce(THEME:GetPathS("MusicWheel","change"),true);
				end;
			elseif params.Name == "Center" then
				local can, reason = CanSafelyEnterGameplayCourse()
				if can then
					SOUND:PlayOnce(THEME:GetPathS("","ready/offcommand"));
					GAMESTATE:prepare_song_for_gameplay();
					SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen");
				else
					lua.ReportScriptError("Cannot enter gameplay: "..reason);
				end
			end;
		end;
		CurrentMissionGroupChangedMessageCommand=cmd(stoptweening;decelerate,.2;xy,200,135;);
	};
};



--I don't think this is correct
local q = Def.ActorFrame{
	InitCommand=cmd(xy,75,100);
};
for i = 1,6 do
	q[i] = Def.ActorFrame{
		InitCommand=cmd(addy,35*i);
		Def.Quad{
			InitCommand=cmd(diffuse,color(".5,.5,.5,.5");setsize,30,30);
		};
		Def.Sprite{
			Texture=THEME:GetPathG("","medal_gold");
			InitCommand=cmd(zoom,.15;addx,-40;);
			OnCommand=cmd(playcommand,"Update");
			CurrentMissionGroupChangedMessageCommand=cmd(playcommand,"Update");
			UpdateCommand=function(self)
				self:stoptweening():diffusealpha(0);
				--self:sleep(i*.05):decelerate(.2):diffusealpha(1);
				if i <= GroupCache.numCourses and QUESTMODE[GAMESTATE:GetMasterPlayerNumber()][QUESTMODE.currentWorld][GroupCache.courses[i]:GetDisplayFullTitle()] then
					self:sleep(i*.05):decelerate(.2):diffusealpha(1);
				end;
			end;
		
		};
		LoadFont("_roboto Bold 54px")..{
			Text=i;
			InitCommand=cmd(zoom,.6;addy,3);
		};
		LoadFont("letters/_ek mukta Bold 24px")..{
			Text="Mission title goes here";
			InitCommand=cmd(horizalign,left;x,20;addy,2);
			OnCommand=function(self)
				self:stoptweening():diffusealpha(0);
				if i <= GroupCache.numCourses then
					self:settext(GroupCache.courses[i]:GetDisplayFullTitle());
				else
					self:settext("");
				end;
				self:sleep(i*.05):decelerate(.2):diffusealpha(1);
			end;
			CurrentMissionGroupChangedMessageCommand=cmd(playcommand,"On");
		};
	};
end;
t[#t+1] = q;

local j = Def.ActorFrame{
	InitCommand=cmd(xy,200+160+15,130;);
};
--I don't expect there to be more than 4 songs.
for i = 1,4 do
	j[i] = Def.ActorFrame{
		InitCommand=cmd(addy,30*i;);
		OnCommand=function(self)
			local course = GAMESTATE:GetCurrentCourse();
			self:stoptweening():diffusealpha(0);
			local trailEntries = GroupCache.courses[currentMissionNum]:GetAllTrails()[1]:GetTrailEntries();
			if i <= #trailEntries then
				self:GetChild("SongName"):settext(trailEntries[i]:GetSong():GetDisplayFullTitle());
				if true then
					local steps = trailEntries[i]:GetSteps()
					local meter = steps:GetMeter();
					if meter >= 99 then
						self:GetChild("Label"):settext("??");
					else
						self:GetChild("Label"):settextf("%02d",meter);
					end;
					
					local StepsType = steps:GetStepsType();
					local labelBG = self:GetChild("LabelBG");
					if StepsType then
						sString = THEME:GetString("StepsDisplay StepsType",ToEnumShortString(StepsType));
						if sString == "Single" then
							--There is no way to designate a single trail as DANGER, unfortunately.
							if meter >= 99 then
								labelBG:setstate(4);
							else
								labelBG:setstate(0);
							end
						elseif sString == "Double" then
							labelBG:setstate(1);
						elseif sString == "SinglePerformance" or sString == "Half-Double" then
							labelBG:setstate(2);
						elseif sString == "DoublePerformance" or sString == "Routine" then
							labelBG:setstate(3);	
						else
							labelBG:setstate(5);
						end;
					end;
				end;
				self:sleep(.05*i):decelerate(.2):diffusealpha(1);
			else
				--Do nothing.
			end;
		end;
		CurrentCourseChangedMessageCommand=cmd(playcommand,"On");
		CurrentMissionGroupChangedMessageCommand=cmd(playcommand,"On");
		
		LoadActor(THEME:GetPathG("StepsDisplayListRow","frame/_icon"))..{
			Name="LabelBG";
			InitCommand=cmd(zoom,0.3;addy,2;animate,false);--draworder,140;);
		};
		LoadFont("monsterrat/_montserrat semi bold 60px")..{
			Name="Label";
			InitCommand=cmd(zoom,0.25;skewx,-0.15;y,0.5);
		};
		-- NEW LABEL
		--[[LoadActor(THEME:GetPathG("StepsDisplayListRow","frame/danger"))..{
			InitCommand=cmd(zoom,0.5;y,22);
			OnCommand=cmd(diffuseshift; effectoffset,1; effectperiod, 0.5; effectcolor1, 1,1,0,1; effectcolor2, 1,1,1,1;);
			SetMessageCommand=function(self,param)
				profile = PROFILEMAN:GetMachineProfile();
				scorelist = profile:GetHighScoreList(GAMESTATE:GetCurrentSong(),param.Steps);
				scores = scorelist:GetHighScores();
				topscore = scores[1];
				
				local descrp = param.Steps:GetDescription();

				if descrp == "DANGER!" then
					self:visible(true);
				else
					self:visible(false);
				end;
			
			end;
		};]]
		LoadFont("facu/_zona pro bold 40px")..{
			Name="SongName";
			Text="Song names here";
			InitCommand=cmd(horizalign,left;zoom,.5;addx,15;maxwidth,700);

		};
	};
end;
t[#t+1] = j;

t[#t+1] = LoadActor(THEME:GetPathG("","USB_stuff"));

return t;
