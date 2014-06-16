include "smokeunit.lua"

local base, dish1, dish2, dish3, dish4= piece('base', 'dish1', 'dish2', 'dish3', 'dish4')
local smokePieces = {piece "base"}
local SIG_HITBYWEAPON = 1

function script.Create()
  StartThread(SmokeUnit, {base})
end

local function Activate()
  Spring.SetUnitArmored(unitID, 0)
  Turn(dish1, x_axis, -1.7, 1)
  Turn(dish2, x_axis, 1.7, 1)
  Turn(dish3, z_axis, 1.7, 1)  
  Turn(dish4, z_axis, -1.7, 1)
  WaitForTurn(dish1, x_axis)
  WaitForTurn(dish2, x_axis)
  WaitForTurn(dish3, z_axis)
  WaitForTurn(dish4, z_axis)
end

function script.Activate()
  StartThread(Activate)
end

local function Deactivate()
  Turn(dish1, x_axis, 0, 1)
  Turn(dish2, x_axis, 0, 1)
  Turn(dish3, z_axis, 0, 1)  
  Turn(dish4, z_axis, 0, 1)
  WaitForTurn(dish1, x_axis)
  WaitForTurn(dish2, x_axis)
  WaitForTurn(dish3, z_axis)
  WaitForTurn(dish4, z_axis)
  Spring.SetUnitArmored(unitID, 1)
end

function script.Deactivate()
  StartThread(Deactivate)
end

local function HitByWeapon()
	Signal(SIG_HITBYWEAPON)
	SetSignalMask(SIG_HITBYWEAPON)
  Spring.GiveOrderToUnit(unitID, CMD.ONOFF, {0}, {})
  Sleep(8000)
  Spring.GiveOrderToUnit(unitID, CMD.ONOFF, {1}, {})
end

function script.HitByWeapon()
  StartThread(HitByWeapon)
end

function script.Killed(recentDamage, maxHealth)
	local severity = recentDamage / maxHealth

	if severity < 0.25 then
		Explode(base, SFX.NONE + SFX.NO_HEATCLOUD)
		Explode(dish1, SFX.NONE + SFX.NO_HEATCLOUD)
		Explode(dish2, SFX.NONE + SFX.NO_HEATCLOUD)
		Explode(dish3, SFX.NONE + SFX.NO_HEATCLOUD)
		Explode(dish4, SFX.NONE + SFX.NO_HEATCLOUD)
		return 1                -- leave a wreck

	elseif severity < 0.50 then
		Explode(base, SFX.SHATTER + SFX.NO_HEATCLOUD)
		Explode(dish1, SFX.FIRE + SFX.SMOKE + SFX.EXPLODE + SFX.NO_HEATCLOUD)
		Explode(dish2, SFX.FIRE + SFX.SMOKE + SFX.EXPLODE + SFX.NO_HEATCLOUD)
		Explode(dish3, SFX.FIRE + SFX.SMOKE + SFX.EXPLODE + SFX.NO_HEATCLOUD)
		Explode(dish4, SFX.FIRE + SFX.SMOKE + SFX.EXPLODE + SFX.NO_HEATCLOUD)
		return 2                -- leave a heap

	else
		Explode(base, SFX.SHATTER + SFX.NO_HEATCLOUD)
		Explode(dish1, SFX.FIRE + SFX.SMOKE + SFX.EXPLODE + SFX.NO_HEATCLOUD)
		Explode(dish2, SFX.FIRE + SFX.SMOKE + SFX.EXPLODE + SFX.NO_HEATCLOUD)
		Explode(dish3, SFX.FIRE + SFX.SMOKE + SFX.EXPLODE + SFX.NO_HEATCLOUD)
		Explode(dish4, SFX.FIRE + SFX.SMOKE + SFX.EXPLODE + SFX.NO_HEATCLOUD)
		return 3                -- leave nothing
	end
end
