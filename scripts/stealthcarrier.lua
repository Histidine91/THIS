--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--include "damage.lua"
include "THIS.lua"

--local MY_ID = GetUnitValue(71)
--local unitDef = Spring.GetUnitDefID(unitID)
local unitTeam = Spring.GetUnitTeam(unitID)

local spGetUnitTeam = Spring.GetUnitTeam
local spGetUnitHealth = Spring.GetUnitHealth
local spGetUnitCommands = Spring.GetUnitCommands
local spSetUnitStealth = Spring.SetUnitStealth

local LaunchDroneAsWeapon = GG.LaunchDroneAsWeapon

--------------------------------------------------------------------------------
-- pieces
--------------------------------------------------------------------------------
local hull, podL, podR, finL, finR = piece("hull", "podl", "podr", "finl", "finr")
local bay0, bay1, emitHullFore, emitHullAft = piece("bay0", "bay1", "emit_hullf", "emit_hullr")

local gunPieces = {}
local gunIndex = {1,1,1,1}
local gunNames = {"pflak", "pd_l", "pd_r", "pd_m"}
for i=1,4 do
	gunPieces[i] = {}
	local array = gunPieces[i]
	array.turret = piece(gunNames[i].."_turret")
	array.sleeve = piece(gunNames[i].."_sleeve")
	if i==1 then
		array.flare = {piece(gunNames[i].."_flare1", gunNames[i].."_flare2")}
	else
		array.flare = {piece(gunNames[i].."_flare")}
	end
end



--------------------------------------------------------------------------------
-- default values
--------------------------------------------------------------------------------
local deathMed = 1024
local deathLarge = 1025
local deathMultiMed = 1026

local dead = false

local fireStealthTime = 3000

--------------------------------------------------------------------------------
--perks
--------------------------------------------------------------------------------
local function HideExtraGuns()
	local toHide = {piece("pd_m_turret", "pd_m_sleeve", "pd_m_barrel")}
	for name,piece in pairs(toHide) do
		Hide(piece)
	end	
end

local function ShowExtraGuns()
	local toShow = {piece("pd_m_turret", "pd_m_sleeve", "pd_m_barrel")}
	for name,piece in pairs(toShow) do
		Show(piece)
	end
end

function NewPerk(perk)
	if (perk == perkMoreGuns) then
		ShowExtraGuns()
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--[[
local function GetDroneTarget()
	local commands = spGetUnitCommands(unitID)
	local target
	if commands == 0 then
		target = commands[0][params] or -1
	else target = -1 end
	return target
end

local function DroneSpawnLoop()
	local minHealth = turretMinHealth[22] or 0
	local health, maxHealth
	Sleep(1000)
	while true do
		--pause drone launching if damage threshold exceeded
		health, maxHealth = spGetUnitHealth(unitID)
		while (health/maxHealth <= minHealth) do
			Sleep(500)
			EmitSfx(droneLeft, 1031)
			EmitSfx(droneRight, 1031)
			health, maxHealth = spGetUnitHealth(unitID)
		end	
		if dead then return end
		--local target = GetDroneTarget()
		local target = GetUnitValue(COB.TARGET_ID, 18)	-- drones go after torpedo target
		LaunchDroneAsWeapon(unitID, nil, spGetUnitTeam(unitID), target, DRONE_K, droneLeft, -90, 0)
		LaunchDroneAsWeapon(unitID, nil, spGetUnitTeam(unitID), target, DRONE_K, droneRight, 90, 0)
		Sleep(10000)
	end
end
]]--

function script.Create()
	if (not GG.perks[unitTeam].have[perkMoreGuns]) then
		HideExtraGuns()
	end

	EmitSfx(hull, 1027)
	EmitSfx(emitHullFore, 1027)
	EmitSfx(emitHullAft, 1027)
end

local function RestoreStealth()
	Signal(SIG_RestoreStealth)
	SetSignalMask(SIG_RestoreStealth)
	Sleep(fireStealthTime)
	if not isMoving then spSetUnitStealth(unitID, true) end
end

function script.StartMoving()
	spSetUnitStealth(unitID, false)
	isMoving = true
end

function script.StopMoving()
	StartThread(RestoreStealth)
	isMoving = false
end

--------------------------------------------------------------------------------
--aiming code
--------------------------------------------------------------------------------
function script.AimFromWeapon(num)
	return gunPieces[num].turret
end

function script.QueryWeapon(num)
	return gunPieces[num].flare[gunIndex[num]]
end

function script.AimWeapon(num, heading, pitch)
	if num == 4 and not GG.perks[unitTeam].have[perkMoreGuns] then
		return false
	end
	local SIG_AIM = 2^(num - 1)
	Signal(SIG_AIM)
	SetSignalMask(SIG_AIM)
	Turn(gunPieces[num].turret, y_axis, heading, math.rad(360))
	Turn(gunPieces[num].sleeve, x_axis, pitch, math.rad(180))
	WaitForTurn(gunPieces[num].turret, y_axis)
	WaitForTurn(gunPieces[num].sleeve, x_axis)
	return true
end

function script.Shot(num)
	gunIndex[num] = gunIndex[num] + 1
	if gunIndex[num] > #gunPieces[num].flare then
		gunIndex[num] = 1
	end
end

--------------------------------------------------------------------------------
--death
--------------------------------------------------------------------------------
local function HidePodL()
	Hide(podL)
	Hide(finL)
	local toHide = {piece("pd_l_turret", "pd_l_sleeve", "pd_l_barrel")}
	for name,piece in pairs(toHide) do
		Hide(piece)
	end	
end

local function HidePodR()
	Hide(podR)
	Hide(finR)
	local toHide = {piece("pd_r_turret", "pd_r_sleeve", "pd_r_barrel")}
	for name,piece in pairs(toHide) do
		Hide(piece)
	end	
end

function script.Killed(recentDamage, maxHealth)
	dead = true
	EmitSfx(podL, 1024)
	Move(podL, x_axis, 50, 8)
	Sleep(1200)
	
	Spin(podL, x_axis, math.rad(math.random(-35,35)))
	Spin(podL, z_axis, math.rad(math.random(-20,20)))
	EmitSfx(podR, 1026)
	Move(podR, x_axis, -50, 6)
	Sleep(600)
	
	EmitSfx(hull, 1024)
	Spin(podR, x_axis, math.rad(math.random(-20,20)))
	Spin(podR, z_axis, math.rad(math.random(-35,35)))
	Sleep(1000)
	
	EmitSfx(bay0, 1024)
	EmitSfx(podL, 1026)
	Sleep(200)
	HidePodL()
	Sleep(1200)
	
	EmitSfx(podR, 1025)
	Sleep(200)
	HidePodR()
	EmitSfx(hull, 1026)
	Sleep(1200)
	
	EmitSfx(hull, 1025)
	EmitSfx(emitHullFore, 1025)
	EmitSfx(emitHullAft, 1026)
	Sleep(500)
end
