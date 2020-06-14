--optionlist controls
local OPLIST_WIDTH =		THEME:GetMetric("CustomRIO","OpQuadWidth")		--option list quad width
local olania =		0.1			--optionlist animation time in
local olanib =		0.2			--optionlist animation time out
local olhei	=		SCREEN_HEIGHT*0.75	--optionlist quadheight
local oltfad =		0.125		--optionlist top fade value (0..1)
local olbfad =		0.5			--optionlist bottom fade value
local ollfad =		0			--optionlist left  fade value
local olrfad =		0			--optionlist right fade value
local OPLIST_splitAt = THEME:GetMetric("OptionsList","MaxItemsBeforeSplit")
--Start to shift the optionsList up at this row
local OPLIST_ScrollAt = 16

local t = Def.ActorFrame{};

local function CurrentNoteSkin(p)
	local state = GAMESTATE:GetPlayerState(p)
	local mods = state:GetPlayerOptionsArray( 'ModsLevel_Preferred' )
	local skins = NOTESKIN:GetNoteSkinNames()

	for i = 1, #mods do
		for j = 1, #skins do
			if string.lower( mods[i] ) == string.lower( skins[j] ) then
			   return skins[j];
			end
		end
	end
end
--OpList
for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
	--This keeps the name of the current OptionsList because OptionsListLeft and OptionsListRight does not know what list this is otherwise
	local currentOpList
	--The amount of rows in the current optionsList menu.
	local numRows
	--This gets a handle on the optionsList Actor so it can be adjusted.
	local optionsListActor
	--If player 1, move towards left. If player 2, move towards right.
	local moveTowards = (pn == PLAYER_1) and SCREEN_LEFT+OPLIST_WIDTH/2 or SCREEN_RIGHT-OPLIST_WIDTH/2
	--The offscreen position.
	local startPosition = (pn==PLAYER_1) and moveTowards-OPLIST_WIDTH or moveTowards+OPLIST_WIDTH
	t[#t+1] = Def.ActorFrame{
		InitCommand=cmd(x,startPosition);
		OnCommand=function(self)
			--Named OptionsListP1 or OptionsListP2
			optionsListActor = SCREENMAN:GetTopScreen():GetChild("OptionsList"..pname(pn))
			--assert(optionsListActor,"No actor!")
		end;
		CodeMessageCommand = function(self, params)
			if params.Name == 'OptionList' then
				SCREENMAN:GetTopScreen():OpenOptionsList(params.PlayerNumber)
			end;
		end;
		OptionsListOpenedMessageCommand=function(self,params)
			if params.Player == pn then
				setenv("currentplayer",pn);
				self:decelerate(olania);
				self:x(moveTowards);
			end
		end;
		OptionsListClosedMessageCommand=function(self,params)
			if params.Player == pn then
				self:stoptweening();
				self:accelerate(olanib);
				self:x(startPosition);
			end;
		end;
		Def.Quad{			--Fondo difuminado
			InitCommand=cmd(draworder,998;diffuse,0,0,0,0.75;y,_screen.cy;zoomto,OPLIST_WIDTH,olhei;fadetop,oltfad;fadebottom,olbfad);
		};
		LoadFont("bebas/_bebas neue bold 90px")..{	--Texto "OPTION LIST"
			Text="OPTION LIST";
			InitCommand=cmd(draworder,999;y,_screen.cy-(olhei/2.25);vertalign,bottom;zoom,0.35;);
		};
		
		LoadFont("Common Normal")..{
			--Text="Hello World!";
			InitCommand=cmd(draworder,999;y,_screen.cy-(olhei/2.25)+10;vertalign,top;zoom,.5;wrapwidthpixels,350);
			OptionsListOpenedMessageCommand=function(self,params)
				if params.Player == pn then
					currentOpList = "SongMenu"
					--This batshit code finds the value of [ScreenOptionsMaster] SongMenu,1
					self:settext(THEME:GetString("OptionExplanations",string.gsub(THEME:GetMetric("ScreenOptionsMaster",THEME:GetMetric("OptionsList","TopMenu")..",1"):split(";")[1],"name,","")))
				end;
			end;
			AdjustCommand=function(self,params)
				--SCREENMAN:SystemMessage(currentOpList..", "..params.Selection.." "..THEME:GetMetric("ScreenOptionsMaster",currentOpList..","..params.Selection+1))
				if params.Player == pn then
					if currentOpList == "SongMenu" or currentOpList == "System" then
						
						if params.Selection+1 <= numRows then
							local itemName = string.gsub(THEME:GetMetric("ScreenOptionsMaster",currentOpList..","..params.Selection+1):split(";")[1],"name,","")
							self:settext(THEME:GetString("OptionExplanations",itemName))
						else
							self:settext("Exit.");
						end;
					elseif currentOpList == "NoteSkins" then
						local curRow;
						--This global var is exported by OptionRowAvailableNoteskins()
						if OPLIST_splitAt < OPTIONSLIST_NUMNOTESKINS then
							curRow = math.floor((params.Selection)/2)+1
						else
							curRow = params.Selection+1
						end;
						--SCREENMAN:SystemMessage(curRow)
						if curRow>OPLIST_ScrollAt then
							optionsListActor:stoptweening():linear(.2):y((SCREEN_CENTER_Y-100)+THEME:GetMetric("OptionsList","ItemsSpacingY")*(OPLIST_ScrollAt-curRow))
						else
							optionsListActor:stoptweening():linear(.2):y(SCREEN_CENTER_Y-100)
						end;
					end;
				end;
				--SCREENMAN:SystemMessage(itemName)
			end;
			OptionsListRightMessageCommand=function(self,params)
				self:playcommand("Adjust",params);
			end;
			OptionsListLeftMessageCommand=function(self,params)
				self:playcommand("Adjust",params);
			end;
			
			OptionsListStartMessageCommand=function(self,params)
				self:playcommand("Adjust",params);
				--[[if params.Player == pn then
					if currentOpList == "NoteSkins" then
						local curRow;
						--This global var is exported by OptionRowAvailableNoteskins()
						if OPLIST_splitAt < OPTIONSLIST_NUMNOTESKINS then
							curRow = math.floor((OPTIONSLIST_NUMNOTESKINS)/2)+1
						else
							curRow = OPTIONSLIST_NUMNOTESKINS+1
						end;
						--SCREENMAN:SystemMessage(curRow)
						if curRow>OPLIST_ScrollAt then
							optionsListActor:stoptweening():linear(.2):y((SCREEN_CENTER_Y-100)+THEME:GetMetric("OptionsList","ItemsSpacingY")*(OPLIST_ScrollAt-curRow))
						else
							optionsListActor:stoptweening():linear(.2):y(SCREEN_CENTER_Y-100)
						end;
					end;
				end;]]
			end;
			OptionsMenuChangedMessageCommand=function(self,params)
				--SCREENMAN:SystemMessage("MenuChanged: Menu="..params.Menu);
				if params.Player == pn then
					currentOpList=params.Menu
					optionsListActor:stoptweening():y(SCREEN_CENTER_Y-100) --Reset the positioning
					if params.Menu ~= "SongMenu" and params.Menu ~= "System" then
						self:settext(THEME:GetString("OptionExplanations",params.Menu))
					else
						--SCREENMAN:SystemMessage(params.Size);
						numRows = tonumber(THEME:GetMetric("ScreenOptionsMaster",currentOpList))
					end;
				end;
			end;
		};
		LoadFont("Common Normal")..{
			Text="Current Velocity:";
			InitCommand=cmd(draworder,999;y,_screen.cy-(olhei/2.25)+35;vertalign,top;zoom,.5;wrapwidthpixels,350;diffusebottomedge,Color("HoloBlue");visible,false);
			OnCommand=function(self,params)
				self:playcommand("UpdateText");
			end;
			UpdateTextCommand=function(self)
				--[[
					More ternary shit
					If an MMod is set this will evaluate to true and will be concatenated to the string,
					but if it's false then the conditional will pick "None" and that will be concatenated instead.
				  ]]
				self:settext("Current Velocity: "..(GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred"):MMod() or "None"));
			end;
			SpeedModChangedMessageCommand=function(self,params)
				if params.Player == pn and currentOpList == "SpeedMods" then
					self:playcommand("UpdateText");
				end;
			end;
			AdjustCommand=function(self,params)
				if currentOpList == "SongMenu" then
					--Because hardcoding this couldn't possibly go wrong
					if params.Selection == 4 then
						self:playcommand("UpdateText");
						self:visible(true);
					else
						self:visible(false);
					end;
				end;
			end;
			OptionsListRightMessageCommand=function(self,params)
				if params.Player == pn then
					self:playcommand("Adjust",params);
				end;
			end;
			OptionsListLeftMessageCommand=function(self,params)
				if params.Player == pn then
					self:playcommand("Adjust",params);
				end;
			end;
		};
		--For the combo judgement only
		Def.Sprite{
			InitCommand=cmd(y,SCREEN_CENTER_Y-116;draworder,999;zoom,.8);
			OptionsMenuChangedMessageCommand=function(self,params)
				if params.Player == pn then
					if params.Menu == "JudgmentType" then
						if ActiveModifiers[pname(pn)]["JudgmentGraphic"] ~= "None" then
							self:Load(THEME:GetPathG("Judgment", ActiveModifiers[pname(pn)]["JudgmentGraphic"])):SetAllStateDelays(1);
						end;
						self:stoptweening():visible(true)--[[:diffusealpha(0):linear(.2):diffusealpha(1)]];
					else
						self:visible(false)
					end;
				end;
			end;
			AdjustCommand=function(self,params)
				if params.Player == pn and currentOpList == "JudgmentType" then
					if params.Selection == #OptionRowJudgmentGraphic().Choices then
						self:Load(THEME:GetPathG("Judgment", ActiveModifiers[pname(pn)]["JudgmentGraphic"])):SetAllStateDelays(1);
					elseif OptionRowJudgmentGraphic().judgementFileNames[params.Selection+1] ~= "None" then
						self:Load(THEME:GetPathG("Judgment", OptionRowJudgmentGraphic().judgementFileNames[params.Selection+1])):SetAllStateDelays(1);
					else
						--SCREENMAN:SystemMessage(params.Selection..", "..#OptionRowJudgmentGraphic().Choices)
						self:Load(nil);
					end;
				end;
			end;
			OptionsListRightMessageCommand=function(self, params)
				self:playcommand("Adjust",params);
			end;
			OptionsListLeftMessageCommand=function(self,params)
				self:playcommand("Adjust", params);
			end;
		
		};
		--Using an ActorFrame here causes draworder issues.
		LoadActor("optionIcon")..{
			InitCommand=cmd(draworder,100;zoomy,0.34;zoomx,0.425;diffusealpha,.75;y,_screen.cy-(olhei/2.25)+40;draworder,998);
			OptionsMenuChangedMessageCommand=function(self,params)
				--SCREENMAN:SystemMessage("MenuChanged: Menu="..params.Menu);
				if params.Player == pn then
					if params.Menu == "NoteSkins" then
						self:stoptweening():linear(.3):diffusealpha(1);
					else
						self:diffusealpha(0);
					end;
				end;
			end;
		};

		--ActorFrame that holds the noteskin
		Def.ActorFrame{
			InitCommand=cmd(x,1;y,_screen.cy-(olhei/2.25)+40;draworder,999;zoom,.35);
			OptionsMenuChangedMessageCommand=function(self,params)
				if params.Player == pn then
					if params.Menu == "NoteSkins" then
						self:playcommand("On")
						self:stoptweening():linear(.3):diffusealpha(1);
					else
						self:diffusealpha(0);
					end;
				end;
			end;
			OnCommand=function(self)
				highlightedNoteSkin = CurrentNoteSkin(pn);
				self:RemoveAllChildren()
				self:AddChildFromPath(THEME:GetPathB("ScreenSelectMusic","overlay/Noteskin.lua"))
				
			end;
			AdjustCommand=function(self,params)
				if params.Player == pn and currentOpList == "NoteSkins" then
					if params.Selection < OPTIONSLIST_NUMNOTESKINS then
						--This is a global var, it's used in Noteskin.lua.
						highlightedNoteSkin = OPTIONSLIST_NOTESKINS[params.Selection+1];
						self:RemoveAllChildren()
						self:AddChildFromPath(THEME:GetPathB("ScreenSelectMusic","overlay/Noteskin.lua"))
					else
						self:playcommand("On");
					end;
				end;
			end;
			OptionsListRightMessageCommand=function(self,params)
				self:playcommand("Adjust",params);
			end;
			OptionsListLeftMessageCommand=function(self,params)
				self:playcommand("Adjust",params);
			end;
		};
	};
end;

return t;
