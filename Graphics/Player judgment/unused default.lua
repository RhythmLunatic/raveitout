local duration_between_frames = 0.0333

local frames = {
	COOL = {
		{ Frame=0,	Delay=duration_between_frames},
		{ Frame=1,	Delay=duration_between_frames},
		{ Frame=2,	Delay=duration_between_frames},
		{ Frame=3,	Delay=duration_between_frames}
	},

	GOOD = {
		{ Frame=4,	Delay=duration_between_frames}
	},
   

	BAD = {
		{ Frame=5,	Delay=duration_between_frames}

   }

};

local c = {};
local player = Var "Player";
local mult = 3;

return Def.ActorFrame {
	Def.Sprite{
		Name="Judgment";
		Texture="JudgmentFont";
		InitCommand=cmd(y,0;visible,false);
		ResetCommand=cmd(finishtweening;stopeffect;visible,false);
		
		JudgmentMessageCommand=function(self, param)
			if param.Player ~= player then return end;
			if not param.TapNoteScore then return end;
			if param.HoldNoteScore then return end;

			self:visible( true );

			if param.TapNoteScore == "TapNoteScore_W1" then
				self:SetStateProperties( frames.COOL )
			else if param.TapNoteScore == "TapNoteScore_Miss" then
				self:SetStateProperties( frames.BAD )
			else
				self:SetStateProperties( frames.GOOD )
			end;

			local startsize = mult;

			--[[(cmd(
				stoptweening;zoomx,startsize;zoomy,startsize;animate,true;linear,0.15;
				linear,0.2;sleep,0.4;
				linear,0.3;zoomy,0;))(c.Judgment);]]
			self:stoptweening():zoom(startsize):animate(true):linear(.15):zoomy(0);
		--	JudgeCmds[param.TapNoteScore](c.Judgment);

			--c.JudgmentFrame:stoptweening();
			
			end;

		end;
	};
};