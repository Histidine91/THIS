--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

include "THIS.lua"


--local MY_ID = GetUnitValue(71)
--local unitDef = Spring.GetUnitDefID(unitID)
local unitTeam = Spring.GetUnitTeam(unitID)

--------------------------------------------------------------------------------
-- default values
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- pieces
--------------------------------------------------------------------------------

local body = piece "body"
local flare = piece "flare"

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function script.Create()
	Sleep(1)
end

function script.QueryWeapon1()
	return flare
end

function script.AimWeapon1(heading, pitch)
	Turn(body, x_axis, heading, math.rad(240))
	Turn(body, y_axis, -pitch, math.rad(120))
	WaitForTurn(body, x_axis)
	WaitForTurn(body, y_axis)
	return true
end

function script.FireWeapon1()
	EmitSfx(body, 4097)
	Spring.DestroyUnit(unitID, false, true)
end

function script.AimFromWeapon1()
	return flare
end

function script.Killed(recentDamage, maxHealth)
end
