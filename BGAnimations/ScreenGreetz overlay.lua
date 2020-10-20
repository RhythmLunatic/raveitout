-- working lua base64 codec (c) 2006-2008 by Alex Kloss
-- compatible with lua 5.1
-- http://www.it-rfc.de
-- licensed under the terms of the LGPL2

-- bitshift functions (<<, >> equivalent)
-- shift left
local function lsh(value,shift)
	return (value*(2^shift)) % 256
end

-- shift right
local function rsh(value,shift)
	return math.floor(value/2^shift) % 256
end

-- return single bit (for OR)
local function bit(x,b)
	return (x % 2^b - x % 2^(b-1) > 0)
end

-- logic OR for number values
local function lor(x,y)
	result = 0
	for p=1,8 do result = result + (((bit(x,p) or bit(y,p)) == true) and 2^(p-1) or 0) end
	return result
end

-- decryption table
local base64bytes = {['A']=0,['B']=1,['C']=2,['D']=3,['E']=4,['F']=5,['G']=6,['H']=7,['I']=8,['J']=9,['K']=10,['L']=11,['M']=12,['N']=13,['O']=14,['P']=15,['Q']=16,['R']=17,['S']=18,['T']=19,['U']=20,['V']=21,['W']=22,['X']=23,['Y']=24,['Z']=25,['a']=26,['b']=27,['c']=28,['d']=29,['e']=30,['f']=31,['g']=32,['h']=33,['i']=34,['j']=35,['k']=36,['l']=37,['m']=38,['n']=39,['o']=40,['p']=41,['q']=42,['r']=43,['s']=44,['t']=45,['u']=46,['v']=47,['w']=48,['x']=49,['y']=50,['z']=51,['0']=52,['1']=53,['2']=54,['3']=55,['4']=56,['5']=57,['6']=58,['7']=59,['8']=60,['9']=61,['-']=62,['_']=63,['=']=nil}

-- function decode
-- decode base64 input to string
local function base64decode(data)
	local chars = {}
	local result=""
	for dpos=0,string.len(data)-1,4 do
		for char=1,4 do chars[char] = base64bytes[(string.sub(data,(dpos+char),(dpos+char)) or "=")] end
		result = string.format('%s%s%s%s',result,string.char(lor(lsh(chars[1],2), rsh(chars[2],4))),(chars[3] ~= nil) and string.char(lor(lsh(chars[2],4), rsh(chars[3],2))) or "",(chars[4] ~= nil) and string.char(lor(lsh(chars[3],6) % 192, (chars[4]))) or "")
	end
	return result
end



local function getWavyText(s,x,y)
	local letters = Def.ActorFrame{}
	local spacing = 16
	for i = 1, #s do
		local c = s:sub(i,i)
		--local c = "a"
		letters[i] = LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
			Text=c;
			InitCommand=cmd(x,x-(#s)*spacing/2+i*spacing;y,y;effectoffset,i*.1;bob;);
		};
	end;
	return letters;
end;

local function getWavyTextPlusRainbow(s,x,y)
	local letters = Def.ActorFrame{}
	local spacing = 15
	for i = 1, #s do
		local c = s:sub(i,i)
		letters[i] = Def.ActorFrame{
			InitCommand=cmd(bob;x,x-(#s)*spacing/2+i*spacing;y,y;effectoffset,i*.1;);
			LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
				Text=c;
				InitCommand=cmd(rainbow;effectoffset,i*.1;);
			};
		};
	end;
	return letters;
end;

local xVelocity = 0
local t = Def.ActorFrame{
	Def.ActorFrame{
		FOV=90;
		LoadActor(THEME:GetPathG("RhythmLunatic","icon"))..{
			InitCommand=cmd(rainbow;customtexturerect,0,0,5,5;setsize,750,750;Center;texcoordvelocity,0,1.5;rotationx,-90/4*3.5;fadetop,1);
			CodeMessageCommand=function(self, params)
				if params.Name == "Start" or params.Name == "Center" then
					SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToPrevScreen");
				elseif params.Name == "Left" then
					xVelocity=xVelocity+.5;
				elseif params.Name == "Right" then
					xVelocity=xVelocity-.5;
				else
					--SCREENMAN:SystemMessage("Unknown button: "..params.Name);
				end;
				self:texcoordvelocity(xVelocity,1.5);
			end;
		};
	}
};
t[#t+1] = LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
	Text="Rave It Out: Season 2 Theme";
	InitCommand=cmd(xy,SCREEN_CENTER_X,50);
};
--t[#t+1] = getWavyText("Rave It Out: Season 2",SCREEN_CENTER_X,SCREEN_CENTER_Y-120);
t[#t+1] = getWavyText("(Re)programmed by Rhythm Lunatic",SCREEN_CENTER_X,SCREEN_CENTER_Y-100);
t[#t+1] = getWavyText("Original code by NeobeatIKK (Sergio Madrid), Jose Jesus, Alisson de Oliveira",SCREEN_CENTER_X,SCREEN_CENTER_Y)..{
	OnCommand=cmd(x,1200;linear,10.4;x,-1200;queuecommand,"On";);
};
t[#t+1] = getWavyText("Greetz to StepPrime, StepF2, STARLiGHT Team",SCREEN_CENTER_X,SCREEN_CENTER_Y+80);
t[#t+1] = getWavyTextPlusRainbow("Thank you for playing RAVE IT OUT! We hope you enjoyed it!",SCREEN_CENTER_X,SCREEN_BOTTOM-80)..{
	OnCommand=cmd(x,1000;linear,10;x,-1500;queuecommand,"On";);
};
return t;
