function widget:GetInfo()
	return {
		name = "Dispatch Large",
		desc = "Allows placement of finished large ships",
		author = "KDR_11k (David Becker)",
		date = "2008-03-04",
		license = "Public Domain",
		layer = 2,
		enabled = true
	}
end

local builder={}

local jumpDist=600

local vsx, vsy =600

local bottom = 100
local left = 280

local CMD_BUILD = 31000
local CMD_PLACE = 32333

local buttonHeight=60
local buttonWidth=80

local ready
local active = false

local phase = 0

function widget:ViewResize(x, y)
	vsx, vsy = widgetHandler:GetViewSizes()
end

function widget:DrawScreen()
	if ready then
		gl.Texture("#"..ready)
		gl.TexRect(left, bottom + buttonHeight, left + buttonWidth, bottom, false, true)
		gl.Texture(false)
		local v = .15 * math.sin(phase) + .2
		phase = phase + .06
		gl.Color(1,1,.7,v)
		gl.Rect(left, bottom, left + buttonWidth, bottom + buttonHeight)
	end
	if active then
		gl.Text("Click to place the ship on the map", vsx*.5, vsy*.2, 20, "oc")
	end
	gl.Color(1,1,1,1)
end

function widget:DrawWorld()
	local team = Spring.GetLocalTeamID()
	if active then
		gl.Color(.2,.2,1,1)
		for b,_ in pairs(builder) do
			for _,u in ipairs(Spring.GetTeamUnitsByDefs(team,b)) do
				local x,y,z = Spring.GetUnitPosition(u)
				gl.DrawGroundCircle(x,y,z,jumpDist,30)
			end
		end
		gl.Color(1,1,1,1)
	end
end

function widget:IsAbove(x,y)
	if ready and x > left and x < left + buttonWidth and y > bottom and y < bottom + buttonHeight then
		return true
	end
	return false
end

function widget:GetTooltip(x,y)
	if ready then
		return "Dispatch "..UnitDefs[ready].humanName.."\n"..
		       "Select a jump location for the prepared unit"
	end
end

function widget:MousePress(x,y,button)
	if active and button==3 then
		active = false
		return true
	end

	local team = Spring.GetLocalTeamID()
	if ready and x > left and x < left + buttonWidth and y > bottom and y < bottom + buttonHeight then
		if button==1 then
			active = true
		end
		return true
	else
		if active and button==1 then
			local s,c = Spring.TraceScreenRay(x,y,true)
			--TODO: Check if this is right!
			for _,u in ipairs(Spring.GetTeamUnits(team)) do
				Spring.GiveOrderToUnit(u, CMD_PLACE, c, {})
				break
			end
			active = false
			return true
		end
	end
end

local function ReadyIs(type)
	ready = type
end

function widget:Initialize()
	for id,d in pairs(UnitDefs) do
		local c = d.customParams
		if c.builds then
			builder[id] = tonumber(c.builds)
		end
	end
	vsx, vsy = widgetHandler:GetViewSizes()
	widgetHandler:RegisterGlobal("ReadyIs", ReadyIs)
end


