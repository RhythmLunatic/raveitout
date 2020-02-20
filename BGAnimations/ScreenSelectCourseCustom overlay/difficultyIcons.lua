local t = Def.ActorFrame{};


--[[	--Difficulty List Orbs Shadows
	for i=1,12 do
		t[#t+1] = LoadActor("DifficultyList/background_orb") .. {
			InitCommand=cmd(diffusealpha,0.85;zoom,0.375;x,_screen.cx-245+i*35;y,_screen.cy+107;horizalign,left);
		};
	end;]]
local numOrbs = 12
for i=1,numOrbs,1 do
	t[#t+1] = Def.ActorFrame{
		InitCommand=cmd(diffusealpha,0.85;zoom,0.375;x,_screen.cx+(i-numOrbs/2-1)*35+35/2;y,_screen.cy+107;horizalign,left);
		Def.Sprite{
			Texture=THEME:GetPathB("ScreenSelectMusic","overlay/DifficultyList/background_orb");
			--InitCommand=cmd(x,120*(i-numOrbs/2));
		};
		Def.Sprite{
			Name="LabelBG";
			Texture=THEME:GetPathG("StepsDisplayListRow","frame/cdiffcourse.png");
			InitCommand=cmd(zoom,.8);
		};
		LoadFont("monsterrat/_montserrat semi bold 60px")..{
			Name="Label";
			InitCommand=cmd(skewx,-0.15;y,2);
		};
		CurrentCourseChangedMessageCommand=function(self)
			local c = GAMESTATE:GetCurrentCourse();
			if c then
				local trailEntries = GAMESTATE:GetCurrentCourse():GetAllTrails()[1]:GetTrailEntries();
				self:GetChild("LabelBG"):visible(i <= #trailEntries)
				self:GetChild("Label"):visible(i <= #trailEntries)
				if i <= #trailEntries then
					local steps = trailEntries[i]:GetSteps()
					local meter = steps:GetMeter();
					if meter >= 99 then
						self:GetChild("Label"):settext("??");
					else
						self:GetChild("Label"):settextf("%02d",meter);
					end;
				end;
			else
				self:visible(false);
			end;
		end;
	};
end;

return t;
