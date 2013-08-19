local spCallCOBScript       = Spring.CallCOBScript
local spFindUnitCmdDesc		= Spring.FindUnitCmdDesc
local spEditUnitCmdDesc		= Spring.EditUnitCmdDesc
local spCreateUnit			= Spring.CreateUnit
local spSetUnitNoSelect     = Spring.SetUnitNoSelect
local spDestroyUnit         = Spring.DestroyUnit
local spGetUnitPosition     = Spring.GetUnitPosition

function gadget:GetInfo()
	return {
		name = "Meteor EMP",
		desc = "Handles Meteor EMP bomb",
		author = "KDR_11k (David Becker), KingRaptor (L.J. Lim)",
		date = "2007-08-26",
		license = "Public domain",
		layer = 1,
		enabled = true
	}
end

if (gadgetHandler:IsSyncedCode()) then

local reloadTime = 30
local CMD_EMPBOMB = 35126
local meteor = UnitDefNames.meteor.id
local bombID = UnitDefNames.empbomb.id

local desc = {
	id = CMD_EMPBOMB,
	name = "EMP Bomb",
	tooltip = 'Detonates an EMP bomb on the spot.',
	type = CMDTYPE.ICON,
	action = "dgun",
	--texture = "&.1x.1&bitmaps/icons/frame_slate_128x96.png",
	onlyTexture = false,
	disabled = false,
}
local rechargeList = {}
local rechargeFrame = 0

function gadget:Initialize()
	GG.rechargeList = rechargeList
end

function gadget:GameFrame(time)
	rechargeFrame = time + reloadTime*32
	if (time % 16 < 0.0001) then
		for u,t in pairs(rechargeList) do
			if t <= time then
				rechargeList[u]=nil
				d = spFindUnitCmdDesc(u, CMD_EMPBOMB)
				spEditUnitCmdDesc(u, d, desc )
			else
				d = spFindUnitCmdDesc(u, CMD_EMPBOMB)
				text = math.ceil((t - time) / 32) .. "s"
				spEditUnitCmdDesc(u, d, {name = text} )
			end
		end
	end
end

function gadget:UnitCreated(unit, ud, team, builder)
	if (ud == meteor) then
		Spring.InsertUnitCmdDesc(unit, desc)
		--d = spFindUnitCmdDesc(unit, CMD_EMPBOMB)
		--spEditUnitCmdDesc(unit, d, {disabled = true, name = reloadTime .. "s", onlyTexture = false} )
		rechargeList[unit] = rechargeFrame - (32*reloadTime)
	end
end

function gadget:UnitDestroyed(unitID, unitDefID, unitTeam, attackerID, attackerDefID, attackerTeam)
	rechargeList[unitID] = nil
end

local function EMPBomb(unitID, unitTeam)
	local x, y, z = spGetUnitPosition(unitID)
	local bomb = spCreateUnit(bombID, x, y, z, 0, unitTeam)
	spSetUnitNoSelect(bomb, true)
	spDestroyUnit(bomb, true, false)
	--Spring.CallCOBScript(unitID,"EMPBomb",0)
end

function gadget:CommandFallback(unitID, unitDefID, unitTeam, cmdID, cmdParams, cmdOptions)
	if cmdID == CMD_EMPBOMB and unitDefID==meteor then
		if rechargeList[unitID] then
			return true, true
		else
			--spCallCOBScript(unitID, "EMPBomb", 0)
			EMPBomb(unitID, unitTeam)
			d = spFindUnitCmdDesc(unitID, CMD_EMPBOMB)
			spEditUnitCmdDesc(unitID, d, {disabled = true, name = "60s", onlyTexture = false} )
			rechargeList[unitID] = rechargeFrame
			return true, true
		end
	end
	return false, false
end

function gadget:AllowCommand(unitID, unitDefID, unitTeam, cmdID, cmdParams, cmdOptions)
	if rechargeList[unitID] and cmdID == CMD_EMPBOMB then
		return false --forbid this command if the unit is still recharging its airstrike
	end
	return true
end

end
