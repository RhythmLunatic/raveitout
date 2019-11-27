local names = {};
for crsWorldName,crsWorld in pairs(RIO_COURSE_GROUPS) do
	names[#names+1] = crsWorldName;
end;
assert(#names > 0);

--==========================
--Item Scroller. Must be defined at the top to have 'scroller' var accessible to the rest of the lua.
--==========================
local scroller = setmetatable({disable_wrapping= false}, item_scroller_mt)
local numWheelItems = #names*3

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
		  		--subself:SetDrawByZPosition(true);
		  		--subself:zoom(.75);
			end;
				
			Def.BitmapText{
				Name= "text",
				Font= "Common Normal",
				InitCommand=cmd(diffuse,Color("White"));
			};
		};
	end,
	-- item_index is the index in the list, ranging from 1 to num_items.
	-- is_focus is only useful if the disable_wrapping flag in the scroller is
	-- set to false.
	transform= function(self, item_index, num_items, is_focus)
		local offsetFromCenter = item_index-math.floor(numWheelItems/2)
		self.container:stoptweening();
		if math.abs(offsetFromCenter) < 5 then
			self.container:decelerate(.5);
			self.container:visible(true);
		else
			self.container:visible(false);
		end;
		if offsetFromCenter == 0 then
			self.container:diffuse(Color("Red"));
		else
			self.container:diffuse(Color("White"));
		end;
		self.container:x(offsetFromCenter*150)
	end,
	-- info is one entry in the info set that is passed to the scroller.
	set= function(self, info)
		self.container:GetChild("text"):settext(info)	
	end,
	gettext=function(self)
		return self.container:GetChild("text"):gettext()
	end,
}}

local t = Def.ActorFrame{
	CodeMessageCommand=function(self,params)
		if params.Name == "DownLeft" or params.Name == "Left" then
			scroller:scroll_by_amount(-1);
		elseif params.Name == "DownRight" or params.Name == "Right" then
			scroller:scroll_by_amount(1);
		elseif params.Name == "Center" or params.Name == "Start" then
			QUESTMODE.currentWorld = scroller:get_info_at_focus_pos()
			SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen")
		end;
	end;

	OnCommand=function(self)
		scroller:set_info_set(names, 1);
	end;
	
};

t[#t+1] = scroller:create_actors("foo", numWheelItems, item_mt, SCREEN_CENTER_X, SCREEN_CENTER_Y);

return t;
