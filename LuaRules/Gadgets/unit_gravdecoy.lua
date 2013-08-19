function gadget:GetInfo()
  return {
    name      = "Grav Decoy",
    desc      = "Handles Iris grav decoy",
    author    = "KingRaptor (L.J. Lim)",
    date      = "February 17, 2010",
    license   = "Public Domain",
    layer     = 0,
    enabled   = true
  }
end

-- SYNCED
if gadgetHandler:IsSyncedCode() then

--speedup
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

local decoys = {}
local probeDef = UnitDefNames.probe.id
local decoyDef = UnitDefNames.gravdecoy.id
local CMD_GRAVDECOY = 35127

local desc = {
	id = CMD_GRAVDECOY,
	name = "Decoy On",
	tooltip = 'Toggle grav decoy (spoofs gravidar)',
	type = CMDTYPE.ICON_MODE,
	action = "toggle",
	--texture = "&.1x.1&bitmaps/icons/frame_slate_128x96.png",
	--onlyTexture = true,
	params={"0","Decoy Off","Decoy On"}
}

function gadget:UnitCreated(unitID,unitDefID,team)
	--Spring.Echo("Unit created: ID "..unitID)
	if unitDefID == probeDef then 
		decoys[unitID] = nil
		--Spring.Echo(probes[unitID])
		spInsertUnitCmdDesc(unitID, desc)
	elseif unitDefID == decoyDef then spSetUnitNoDraw(unitID, true) end
end

local function CreateDecoy(probeID)
	if decoys[probeID] then DestroyDecoy(probeID) end
	--Spring.Echo("Creating decoy for probe ID "..probeID)
	x, y, z = spGetUnitPosition(probeID)
	local team = spGetUnitTeam(probeID)
	local decoyID = spCreateUnit(decoyDef, x, y, z, 0, team)
	decoys[probeID] = decoyID
	--Spring.Echo("Decoy ID:" .. decoys[probeID])
	spSetUnitNoSelect(decoyID, true)
	spSetUnitCloak(decoyID, 4)
	spMCEnable(decoyID)
end

local function DestroyDecoy(probeID)
	if decoys[probeID] then
		--Spring.Echo("Destroying decoy " .. decoys[probeID] .. " for probe ID "..probeID)
		spDestroyUnit(decoys[probeID], false, true)
		decoys[probeID] = nil
	end
end

function gadget:AllowCommand(unitID, unitDefID, team, cmd, param, opt)
	if cmd == CMD_GRAVDECOY then
		--Spring.Echo("Toggle input received by unit ID "..unitID)
		local f = spFindUnitCmdDesc(unitID,cmd)
		spEditUnitCmdDesc(unitID,f,{ params={param[1],"Decoy Off","Decoy On"} })
		if param[1] == 1 then CreateDecoy(unitID)
		else DestroyDecoy(unitID) end
		return false
	end
	return true
end

function gadget:UnitDestroyed(unitID,unitDefID,team)
	if decoys[unitID] then DestroyDecoy(unitID) end
end

function gadget:GameFrame(n)
	if (n % 15) < 0.1 then
		for probeID, decoyID in pairs(decoys) do
			--Spring.Echo("Probe ID "..probeID.." sounding off")
			if decoyID then
				x, y, z = spGetUnitPosition(probeID)
				spMCSetPos(decoyID, x, y, z)
			end
		end
	end
end
	
else
-- UNSYNCED

end

