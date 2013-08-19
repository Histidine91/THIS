function widget:GetInfo()
	return {
		name = "Perk Selector",
		desc = "Lets you select perks",
		author = "KDR_11k (David Becker)",
		date = "2008-03-04",
		license = "Public Domain",
		layer = 1,
		enabled = true
	}
end

local bottom = 100
local height = 0
local right = 200
local width = 0
local rows = 2
local columns = 1

local visible = true

local buttonHeight=64
local buttonWidth=64

local perkList = include("perks/perks.lua")

local posToIndex = {}

local perksleft
local function PerkState(p)
	perksleft = p
end

function widget:Initialize()
	vsx, vsy = widgetHandler:GetViewSizes()
	columns = math.ceil(#perkList * .5)
	height = rows * buttonHeight
	width = columns * buttonWidth
	local n = 0
	for i,_ in pairs(perkList) do
		posToIndex[n]=i
		n=n+1
	end
	widgetHandler:RegisterGlobal("PerkState", PerkState)
end

function widget:ViewResize(x, y)
	vsx, vsy = widgetHandler:GetViewSizes()
	height = rows * buttonHeight
	width = columns * buttonWidth
end

function widget:DrawScreen()
	local isGrey = false
	if perksleft then
		if perksleft > 0 then
			gl.Text("Points left: "..perksleft, vsx - right - 200, bottom + 30 + 2* buttonHeight, 16, "c")
		else
			widgetHandler:RemoveWidget()
		end
	end
	for n,p in pairs(posToIndex) do
		local hpos = vsx - right - math.floor(n * .5) * buttonWidth
		local vpos = bottom + n % 2 * buttonHeight
		if Spring.GetTeamRulesParam(Spring.GetLocalTeamID(), "hasperk_"..p) == 1 then
			gl.Color(0.2,0.2,0.2,1)
			isGrey = true
		elseif isGrey then
			isGrey = false
			gl.Color(1,1,1,1)
		end
		gl.Texture(perkList[p][3])
		gl.TexRect(hpos - buttonWidth, vpos + buttonHeight, hpos, vpos, false, true)
	end
	gl.Texture(false)
	gl.Color(1,1,1,1)
end

function widget:IsAbove(x,y)
	if visible and x > vsx - right - width and x < vsx - right and y > bottom and y < bottom + height then
		return true
	end
	return false
end

function widget:GetTooltip(x,y)
	local pos = math.floor((vsx - right - x)/buttonWidth) * 2 + math.floor((y - bottom)/buttonHeight) % 2
	local index = posToIndex[pos]
	if index then
		return 'Choose Perk "'..perkList[index][1]..'"\n'..perkList[index][2]
	end
	return pos
end

function widget:MousePress(x,y,button)
	local team = Spring.GetLocalTeamID()
	if visible and x > vsx - right - width and x < vsx - right and y > bottom and y < bottom + height then
		local pos = math.floor((vsx - right - x)/buttonWidth) * 2 + math.floor((y - bottom)/buttonHeight) % 2
		local index = posToIndex[pos]
		if button == 1 then
			Spring.SendLuaRulesMsg("pickperk:" .. index)
		end
		return true
	end
	return false
end
