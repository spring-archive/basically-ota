include "smokeunit.lua"

local base, dish1, dish2, dish3, dish4, hinge1, hinge2, hinge3, hinge4, light, wheel = piece('base', 'dish1', 'dish2', 'dish3', 'dish4', 'hinge1', 'hinge2', 'hinge3', 'hinge4', 'light', 'wheel')
local smokePieces = {piece "base"}
local SIG_HITBYWEAPON = 1

function script.Create()
  Move(base, y_axis, -10)
	StartThread(SmokeUnit, {base})
end

function script.Activate()
  Move(base, y_axis, 0, 5)
  Spin(wheel, y_axis, 1, 0.02)
  Turn(hinge1, x_axis, 2.1, 1)
  Turn(hinge2, x_axis, -2.1, 1)
  Turn(hinge3, z_axis, -2.1, 1)
  Turn(hinge4, z_axis, 2.1, 1)
  Turn(dish1, y_axis, -3.14159265, 1.5)
  Turn(dish2, y_axis, -3.14159265, 1.5)
  Turn(dish3, y_axis, -3.14159265, 1.5)
  Turn(dish4, y_axis, -3.14159265, 1.5)
end

function script.Deactivate()
  Move(base, y_axis, -10, 5)
  StopSpin(wheel, y_axis, 0.02)
  Turn(hinge1, x_axis, 0, 1)
  Turn(hinge2, x_axis, 0, 1)
  Turn(hinge3, z_axis, 0, 1)
  Turn(hinge4, z_axis, 0, 1)
  Turn(dish1, y_axis, 0, 1.5)
  Turn(dish2, y_axis, 0, 1.5)
  Turn(dish3, y_axis, 0, 1.5)
  Turn(dish4, y_axis, 0, 1.5)
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
		Explode(base, SFX.NONE)
		Explode(dish1, SFX.NONE + SFX.NO_HEATCLOUD)
		Explode(dish2, SFX.NONE + SFX.NO_HEATCLOUD)
		Explode(dish3, SFX.NONE + SFX.NO_HEATCLOUD)
		Explode(dish4, SFX.NONE + SFX.NO_HEATCLOUD)
		Explode(light, SFX.FIRE + SFX.SMOKE)
		return 1                -- leave a wreck

	elseif severity < 0.50 then
		Explode(base, SFX.SHATTER + SFX.NO_HEATCLOUD)
		Explode(dish1, SFX.SHATTER + SFX.NO_HEATCLOUD)
		Explode(dish2, SFX.SHATTER + SFX.NO_HEATCLOUD)
		Explode(dish3, SFX.SHATTER + SFX.NO_HEATCLOUD)
		Explode(dish4, SFX.SHATTER + SFX.NO_HEATCLOUD)
		Explode(light, SFX.FIRE + SFX.SMOKE)
		return 2                -- leave a heap

	else
		Explode(base, SFX.SHATTER + SFX.NO_HEATCLOUD)
		Explode(dish1, SFX.SHATTER + SFX.NO_HEATCLOUD)
		Explode(dish2, SFX.SHATTER + SFX.NO_HEATCLOUD)
		Explode(dish3, SFX.SHATTER + SFX.NO_HEATCLOUD)
		Explode(dish4, SFX.SHATTER + SFX.NO_HEATCLOUD)
		Explode(light, SFX.FIRE + SFX.SMOKE)
		return 3                -- leave nothing
	end
end
