--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- Automatically generated local definitions

local spGetGameFrame         = Spring.GetGameFrame
local spGetSelectedUnits     = Spring.GetSelectedUnits
local spGetUnitDefID         = Spring.GetUnitDefID
local spGetUnitHealth        = Spring.GetUnitHealth
local spGetUnitPosition      = Spring.GetUnitPosition
local spGetUnitTeam          = Spring.GetUnitTeam
local spGetUnitsInCylinder   = Spring.GetUnitsInCylinder
local spSetUnitHealth        = Spring.SetUnitHealth

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
	return {
		name = "Repair",
		desc = "handles repairs",
		author = "KDR_11k (David Becker)",
		date = "2008-03-08",
		license = "Public Domain",
		layer = 20,
		enabled = true
	}
end

local delayAfterHit=150
local selfRepairPerSecond=100
local smallRepairPerSecond=60
local repairRadius=500

if (gadgetHandler:IsSyncedCode()) then

--SYNCED

local builder = {}
local builders = {}
local repairStun={}
local large = {}
local selfRepairing={}


function gadget:Initialize()
	for id,d in pairs(UnitDefs) do
		local c = d.customParams
		if c.type=="large" or c.type=="turret" then
			large[id] = true
		end
		if c.builds then
			builder[id] = tonumber(c.builds)
		end
	end
end

function gadget:UnitCreated(u, ud, team)
	if builder[ud] then
		builders[u] = true
	end
	if large[ud] then
		selfRepairing[u]=true
	end
end

function gadget:UnitDestroyed(u, ud, team)
	builders[u]=nil
	selfRepairing[u]=nil
	repairStun[u]=nil
end

function gadget:UnitDamaged(u, ud, team)
	repairStun[u] = spGetGameFrame() + delayAfterHit
end

local GetUnitHealth = spGetUnitHealth
local SetUnitHealth = spSetUnitHealth
local min = math.min
local GetUnitPosition = spGetUnitPosition
local GetUnitTeam = spGetUnitTeam
local GetUnitsInCylinder = spGetUnitsInCylinder

function gadget:GameFrame(f)
	if (f + 12) % 30 < .1 then
		for u,_ in pairs(selfRepairing) do
			if not repairStun[u] or repairStun[u] < f then
				local hp, max = GetUnitHealth(u)
				SetUnitHealth(u, {health = min(hp + selfRepairPerSecond, max)})
			end
		end
	end
	if (f + 18) % 30 < .1 then
		for u,_ in pairs(builders) do
			local x,y,z = GetUnitPosition(u)
			local team = GetUnitTeam(u)
			for _,tu in ipairs(GetUnitsInCylinder(x,z,repairRadius,team)) do
				if not repairStun[tu] or repairStun[tu] < f then
					local hp, max = GetUnitHealth(tu)
					SetUnitHealth(tu, {health = min(hp + smallRepairPerSecond, max)})
				end
			end
		end
	end
end

else

--UNSYNCED

local GL_LINE_LOOP           = GL.LINE_LOOP
local GL_ONE_MINUS_SRC_ALPHA = GL.ONE_MINUS_SRC_ALPHA
local GL_SRC_ALPHA           = GL.SRC_ALPHA
local GL_TRIANGLE_STRIP      = GL.TRIANGLE_STRIP
local glBeginEnd             = gl.BeginEnd
local glBlending             = gl.Blending
local glCallList             = gl.CallList
local glColor                = gl.Color
local glCreateList           = gl.CreateList
local glDeleteList           = gl.DeleteList
local glLineWidth            = gl.LineWidth
local glPopMatrix            = gl.PopMatrix
local glPushMatrix           = gl.PushMatrix
local glTexCoord             = gl.TexCoord
local glTexture              = gl.Texture
local glTranslate            = gl.Translate
local glVertex               = gl.Vertex

local builder={}

local repairShape

local function Circle()
	for i=0,39 do
		glVertex(math.cos(i*.05*3.1415)*repairRadius,0,math.sin(i*.05*3.1415)*repairRadius)
	end
end

local size=250

local function Square()
	glTexCoord(0,0)
	glVertex(-size,0,-size)
	glTexCoord(1,0)
	glVertex(size,0,-size)
	glTexCoord(0,1)
	glVertex(-size,0,size)
	glTexCoord(1,1)
	glVertex(size,0,size)
end

local function Shape()
	glTexture(false)
	glBeginEnd(GL_LINE_LOOP,Circle)
	glTexture(true)
	glBeginEnd(GL_TRIANGLE_STRIP,Square)
end

function gadget:DrawWorldPreUnit()
	glTexture("bitmaps/repair.tga")
	--glBlending(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA)
	glLineWidth(2)
	glColor(.6,.6,.2,1)
	for _,u in ipairs(spGetSelectedUnits()) do
		if builder[spGetUnitDefID(u)] then
			local x,y,z=spGetUnitPosition(u)
			glPushMatrix()
			glTranslate(x,0,z)
			glCallList(repairShape)
			--Shape()
			glPopMatrix()
		end
	end
	glLineWidth(1)
	glColor(1,1,1,1)
	glTexture(false)
	--glBlending(false)
end

function gadget:Initialize()
	for id,d in pairs(UnitDefs) do
		local c = d.customParams
		if c.builds then
			builder[id] = tonumber(c.builds)
		end
	end
	repairShape=glCreateList(Shape)
end

function gadget:Shutdown()
	glDeleteList(repairShape)
end

end
