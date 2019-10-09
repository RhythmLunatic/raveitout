local isDone = {
	PLAYER_1 = false,
	PLAYER_2 = false
}

return Def.ActorFrame{
	LoadActor("NewProfileBox", PLAYER_1)..{
		Condition=(GAMESTATE:IsSideJoined(PLAYER_1) and PROFILEMAN:GetProfile(PLAYER_1) and PROFILEMAN:GetProfile(PLAYER_1):GetTotalNumSongsPlayed() == 0);
		InitCommand=cmd(xy,SCREEN_WIDTH*.25,SCREEN_CENTER_Y+20);
	};
	LoadActor("NewProfileBox", PLAYER_2)..{
		Condition=(GAMESTATE:IsSideJoined(PLAYER_2) and PROFILEMAN:GetProfile(PLAYER_2) and PROFILEMAN:GetProfile(PLAYER_2):GetTotalNumSongsPlayed() == 0);
		InitCommand=cmd(xy,SCREEN_WIDTH*.75,SCREEN_CENTER_Y+20);
	};
	DoneSelectingMessageCommand=function(self,params)
		isDone[params.Player] = true;
		if GAMESTATE:IsSideJoined(PLAYER_1) and GAMESTATE:IsSideJoined(PLAYER_2) then
			if isDone[PLAYER_1] and isDone[PLAYER_2] then
				SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen");
			end;
		else
			SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen");
		end
	end;
	--[[LoadActor("circle")..{
		OnCommand=function(self)
			--local z = Resize(self:GetWidth(), self:GetHeight(), SCREEN_WIDTH, SCREEN_HEIGHT);
			--self:zoom(z):Center();
			self:ScaleToHeight(SCREEN_HEIGHT);
			self:Center();
		end;
	};]]
};
