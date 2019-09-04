--[[
Mission mode for RIO
Designed to be as idiot proof as possible

Setup:
1. Make a folder in Courses with the name of your mission group.
2. Fill it with up to 6 courses. In each course, put in a #MISSIONID tag with the number you want this course to be in the group. (Ranging from 1-6, since the theme only displays 6 missions at a time)
3. Add to this script.

Refer to https://github.com/stepmania/stepmania/wiki/Courses on help with making courses.
There is one unique tag you can put in RIO courses, which is #MINSCORE. This is the minimum score needed to pass the mission.

]]
--[[
Sorry jousway lol you can put it in the config.ini if you want
This controls the number of courses you can skip before going on to the next mission group.
So let's say you completed 3 out of 5 missions for the group it's set to 2, now you can
go on to the next group.
]]
NUM_MISSIONS_SKIPPABLE = 2
RIO_COURSE_GROUPS = {"The First Step", "The World Warrior"}

-- 'QUESTMODEMAN' was a bit too verbose
QUESTMODE = {
	savefile = "RIO_MissionSaveData.txt";
	[PLAYER_1] = nil,
	[PLAYER_2] = nil
}
QUESTMODE.HasPassedMission=function(self,player)
	assert(QUESTMODE[player],"LoadCurrentProgress hasn't been called yet!")
	
	
end;
QUESTMODE.SaveCurrentProgress=function(self,player)
	local path = PROFILEMAN:GetProfileDir(ProfileSlot[PlayerNumber:Reverse()[player]+1])..QUESTMODE.savefile
end;
QUESTMODE.LoadCurrentProgress=function(self,player)
	
end;
