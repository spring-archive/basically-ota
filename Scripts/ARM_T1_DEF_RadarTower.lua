include "smokeunit.lua"

local base, dish, ear1, ear2 = piece('base', 'dish', 'ear1', 'ear2')
local smokePieces = {piece "base"}
local SIG_HITBYWEAPON = 1

function script.Create()
  Move(dish, y_axis, -7)
  StartThread(SmokeUnit, {base})
end

function script.Activate()
  Move(dish, y_axis, 0, 3.5)
  Spin(dish, y_axis, 0.8, 0.02)
  Spin(ear1, x_axis, 1.2, 0.02)
  Spin(ear2, x_axis, -1.2, 0.02)
end

function script.Deactivate()
  Move(dish, y_axis, -7, 3.5)
  StopSpin(dish, y_axis, 0.02)
  StopSpin(ear1, x_axis, 0.02)
  StopSpin(ear2, x_axis, 0.02)
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
		Explode(dish, SFX.NONE + SFX.NO_HEATCLOUD)
		Explode(ear1, SFX.NONE + SFX.NO_HEATCLOUD)
		Explode(ear2, SFX.NONE + SFX.NO_HEATCLOUD)
		return 1                -- leave a wreck

	elseif severity < 0.50 then
		Explode(base, SFX.SHATTER + SFX.NO_HEATCLOUD)
		Explode(dish, SFX.NONE + SFX.NO_HEATCLOUD)
		Explode(ear1, SFX.FIRE + SFX.SMOKE + SFX.EXPLODE + SFX.NO_HEATCLOUD)
		Explode(ear2, SFX.FIRE + SFX.SMOKE + SFX.EXPLODE + SFX.NO_HEATCLOUD)
		return 2                -- leave a heap

	else
		Explode(base, SFX.SHATTER + SFX.NO_HEATCLOUD)
		Explode(dish, SFX.NONE + SFX.NO_HEATCLOUD)
		Explode(ear1, SFX.FIRE + SFX.SMOKE + SFX.EXPLODE + SFX.NO_HEATCLOUD)
		Explode(ear2, SFX.FIRE + SFX.SMOKE + SFX.EXPLODE + SFX.NO_HEATCLOUD)
		return 3                -- leave nothing
	end
end
