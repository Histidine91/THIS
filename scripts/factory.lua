--pieces
local base = piece "base"

function script.QueryNanoPiece()
	return base
end

function script.Activate()
	SetUnitValue(COB.INBUILDSTANCE, 1)
end

function script.Deactivate()
	SetUnitValue(COB.INBUILDSTANCE, 0)
end

function script.Create()
	Hide(base)
	--SetUnitValue(COB.BUGGER_OFF, 0)
end

function script.QueryBuildInfo( ) 
	return base
end

--death and wrecks
function script.Killed(recentDamage, maxHealth)
end