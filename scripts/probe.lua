--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

include "THIS.lua"

--local unitDef = Spring.GetUnitDefID(unitID)
local unitTeam = Spring.GetUnitTeam(unitID)

local spSetUnitCloak = Spring.SetUnitCloak
--------------------------------------------------------------------------------
-- default values
--------------------------------------------------------------------------------
local spinSpeed = math.rad(90)
local spinAccel = math.rad(30)
--------------------------------------------------------------------------------
-- pieces
--------------------------------------------------------------------------------

local body = piece "body"
local head = piece "head"
local tail = piece "tail"

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function script.Create()
	--Deactivate()
	Sleep(1)
	spSetUnitCloak(unitID, 2)
	if math.random() > 0.5 then	Spin(head, z_axis, spinSpeed, spinAccel)
	else Spin(head, z_axis, -spinSpeed, spinAccel) end
end

function script.MoveRate(rate)
	if rate > 0 then spSetUnitCloak(unitID, false)
	else spSetUnitCloak(unitID, 2) end
end

function script.Killed(recentDamage, maxHealth)
end

--[[
local spCreateUnit			= Spring.CreateUnit
local spSetUnitNoSelect     = Spring.SetUnitNoSelect
local spDestroyUnit         = Spring.DestroyUnit
local spGetUnitPosition     = Spring.GetUnitPosition
local spMCEnable			= Spring.MoveCtrl.Enable
local spMCSetPos			= Spring.MoveCtrl.SetPosition

local decoyActive = false
local decoyDef = UnitDefNames.gravdecoy.id
local SIG_Decoy = 1
local decoyID

local function GravDecoy()
	local x, y, z
	Signal(SIG_Decoy)
	SetSignalMask(SIG_Decoy)
	
	if math.random() > 0.5 then	Spin(head, z_axis, spinSpeed, spinAccel)
	else Spin(head, z_axis, -spinSpeed, spinAccel)
	if not decoyID then
		x, y, z = spGetUnitPosition(unitID)
		decoyID = spCreateUnit(decoyDef, x, y, z)
		spSetUnitNoSelect(decoyID)
		spMCEnable(decoyID)
	end
	while true do
		if not decoyActive then return end
		x, y, z = spGetUnitPosition(unitID)
		spMCSetPos(decoyID, x, y, z)
		Sleep(100)
	end
end

function script.Activate()
	decoyActive = true
	StartThread(GravDecoy)
end

function script.Deactivate()
	decoyActive = false
	if decoyID then spDestroyUnit(decoyID, false, true) end
	decoyID = nil
	StopSpin(head, z_axis)
	Turn(head, z_axis, 0)
end
]]