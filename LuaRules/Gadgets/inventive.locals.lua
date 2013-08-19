--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- Automatically generated local definitions

local spGetGameFrame     = Spring.GetGameFrame
local spGetUnitHealth    = Spring.GetUnitHealth
local spSetUnitHealth    = Spring.SetUnitHealth
local spSetUnitMaxHealth = Spring.SetUnitMaxHealth
local spEcho		 = Spring.Echo

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
	return {
		name = "Inventive",
		desc = "the Inventive perk",
		author = "KDR_11k (David Becker)",
		date = "2008-03-13",
		license = "Public Domain",
		layer = 1,
		enabled = true
	}
end

local boostFactor=.03

if (gadgetHandler:IsSyncedCode()) then

--SYNCED

function gadget:UnitCreated(u, ud, team)
	if GG.perks[team].have[9] then  --Inventive
		local _, maxHP = spGetUnitHealth(u)
		maxHP = math.floor(maxHP * (1 + boostFactor * spGetGameFrame() / 1800))
		spSetUnitMaxHealth(u, maxHP)
		spSetUnitHealth(u, {health = maxHP})
		--spEcho(UnitDefs[ud]["humanName"].." created with "..maxHP.." max HP")
	end
end

else

--UNSYNCED

return false

end
