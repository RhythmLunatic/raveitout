-- values must be set from 0 to 1
--[[local ratio =	FadeOutRatio 	--screen width ratio
local ani =		FadeOutTween	--animation time

return Def.Quad{
	OnCommand=function(self)
		if GAMESTATE:IsEventMode() or DoDebug then ResetLife(); end;
	end;
};]]
return Def.ActorFrame{};