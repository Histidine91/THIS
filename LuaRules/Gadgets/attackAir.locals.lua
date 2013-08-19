--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- Automatically generated local definitions

local CMD_ATTACK        = CMD.ATTACK
local CMD_MANUALFIRE    = CMD.MANUALFIRE
local CMD_INSERT        = CMD.INSERT
local CMD_REMOVE        = CMD.REMOVE
local spGetUnitPosition = Spring.GetUnitPosition
local spGiveOrderToUnit = Spring.GiveOrderToUnit

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
	return {
		name = "Attack Air",
		desc = "makes units aim at midair positions instead of the ground when attacking",
		author = "KDR_11k (David Becker)",
		date = "2008-03-09",
		license = "Public Domain",
		layer = 1,
		enabled = true
	}
end

if (gadgetHandler:IsSyncedCode()) then

--SYNCED

-- this gadget is broken by engine changes
-- so may as well disable all ground attacks
function gadget:AllowCommand(u, ud, team, cmd, param, opt, _, synced)
	if cmd == CMD_ATTACK or cmd == CMD_MANUALFIRE then
		if #param > 1 then return false end
	end
	return true
end

--[[
local replaceList = {}

function gadget:AllowCommand(u, ud, team, cmd, param, opt, _, synced)
	if cmd == CMD_ATTACK or cmd == CMD_MANUALFIRE then
		local overwrite=not opt.shift
		local y = param[2]
		if y then
			if synced then
				return true
			else
				_,y,_ = spGetUnitPosition(u)
			end
		else
			return true
		end
		table.insert(replaceList, {
			cmd=cmd,
			u=u,
			overwrite=overwrite,
			x=param[1],
			y=y,
			z=param[3],
		})
		return false
	end
	return true
end

function gadget:GameFrame(f)
	for i,t in pairs(replaceList) do
		if not t.overwrite then
			spGiveOrderToUnit(t.u, CMD_INSERT, {-1, t.cmd, 0, t.x, t.y, t.z }, {"alt"})
		else
			spGiveOrderToUnit(t.u, t.cmd, {t.x, t.y, t.z }, {})
		end
		--spGiveOrderToUnit(t.u, CMD_REMOVE, {t.tag}, {})
		replaceList[i]=nil
	end
end
]]--

else

--UNSYNCED

return false

end
