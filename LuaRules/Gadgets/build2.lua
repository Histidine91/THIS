--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function gadget:GetInfo()
	return {
		name = "Build 2",
		desc = "Build System",
		author = "KingRaptor (L.J. Lim)",
		date = "2008-03-03",
		license = "Public Domain",
		layer = 5,
		enabled = false
	}
end

if (gadgetHandler:IsSyncedCode()) then
--------------------------------------------------------------------------------
-- SYNCED
--------------------------------------------------------------------------------
local spCreateUnit			= Spring.CreateUnit
local spSetUnitNoSelect     = Spring.SetUnitNoSelect
local spSetUnitCloak		= Spring.SetUnitCloak
local spDestroyUnit         = Spring.DestroyUnit
local spGetUnitPosition     = Spring.GetUnitPosition
local spGetUnitTeam			= Spring.GetUnitTeam
local spMCEnable			= Spring.MoveCtrl.Enable
local spMCSetPos			= Spring.MoveCtrl.SetPosition
local spInsertUnitCmdDesc	= Spring.InsertUnitCmdDesc
local spEditUnitCmdDesc		= Spring.EditUnitCmdDesc
local spFindUnitCmdDesc		= Spring.FindUnitCmdDesc
local spSetUnitNoDraw 		= Spring.SetUnitNoDraw
local spSetUnitBlocking		= Spring.SetUnitBlocking

include("LuaRules/Configs/build_defs.lua")

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local CMD_SELECTFAC = 31337
local cmdDesc = {
	id = CMD_SELECTFAC,
	name = "Select factory",
	tooltip = "Selects the carrier's factory.",
	type = CMDTYPE.ICON,
	--action = "dgun",
	onlyTexture = false,
	disabled = false,
}

local carriers = {}	-- value = ID of attached fac
local attachedFacs = {}	-- value = ID of parent carrier
local spawnList = {} -- ordered array of scheduled fac spawns
local destroyList = {}

function gadget:UnitCreated(unitID, unitDefID, team, builderID)
	if carrierDefs[unitDefID] then
		local facName = carrierDefs[unitDefID]
		if UnitDefNames[facName] then
			spawnList[#spawnList+1] = {carrier = unitID, carrierDefID = unitDefID, team = team, facname = facName}
		end
	end
	spSetUnitNoDraw(unitID, true)	--makes buildee invisible while under construction
end

function gadget:UnitFinished(unitID, unitDefID, team)
	spSetUnitNoDraw(unitID, false)
end

function gadget:UnitDestroyed(unitID)
	if carriers[unitID] then
		destroyList[#destroyList + 1] = carriers[unitID]
	end
	carriers[unitID] = nil
	attachedFacs[unitID] = nil
end

function gadget:GameFrame(n)
	for i=1, #spawnList do
		local info = spawnList[i]
		local x,y,z = Spring.GetUnitPosition(info.carrier)
		local facID = Spring.CreateUnit(info.facname, x, y, z, 0, info.team)
		carriers[info.carrier] = facID
		attachedFacs[facID] = info.carrier
		spMCEnable(facID)
		spSetUnitNoDraw(facID, true)
		spSetUnitBlocking(facID, false, false)
		--spSetUnitNoSelect(facID, true)
		Spring.InsertUnitCmdDesc(info.carrier, CMD_SELECTFAC, cmdDesc)
	end
	spawnList = {}
	for i=1, #destroyList do
		spDestroyUnit(destroyList[i], false, true)
	end
	destroyList = {}
	
	if (n % 1) < 0.1 then
		for carrierID, facID in pairs(carriers) do
			x, y, z = spGetUnitPosition(carrierID)
			spMCSetPos(facID, x, y, z)
		end
	end
end

function gadget:Shutdown()
	for i,v in pairs(carriers) do
		Spring.DestroyUnit(v)
	end
end

function gadget:AllowCommand(unitID, unitDefID, team, cmd, param, opts)
	if cmd == CMD_SELECTFAC and carriers[unitID] then
		Spring.SelectUnitArray({carriers[unitID]})
		return false
	end
	return true	-- command was not used
end

function gadget:Initialize()
	-- luarules reload compatibility
	local units = Spring.GetAllUnits()
	for i=1,#units do
		local ud = Spring.GetUnitDefID(units[i])
		local team = Spring.GetUnitTeam(units[i])
		gadget:UnitCreated(units[i], ud, team)
	end
end
	
else
--------------------------------------------------------------------------------
-- UNSYNCED
--------------------------------------------------------------------------------

end
