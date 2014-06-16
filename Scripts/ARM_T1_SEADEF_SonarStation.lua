include "smokeunit.lua"

local base, bouy, light = piece('base', 'bouy', 'light')
local smokePieces = {piece "bouy"}
local SIG_HITBYWEAPON = 1

function script.Create()
  Move(light, y_axis, -3.4)
  StartThread(SmokeUnit, {bouy})
end

function script.Activate()
  Move(light, y_axis, 0, 2)
  Spin(base, y_axis, 1, 0.02)
  Spin(bouy, y_axis, -1, 0.02)
end

function script.Deactivate()
  Move(light, y_axis, -3.4, 2)
  StopSpin(base, y_axis, 0.02)
  StopSpin(bouy, y_axis, 0.02)
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
		Explode(bouy, SFX.NONE + SFX.NO_HEATCLOUD)
		Explode(light, SFX.NONE + SFX.NO_HEATCLOUD)
		return 1                -- leave a wreck

	elseif severity < 0.50 then
		Explode(base, SFX.SHATTER + SFX.NO_HEATCLOUD)
		Explode(bouy, SFX.FIRE + SFX.SMOKE + SFX.EXPLODE + SFX.NO_HEATCLOUD)
		Explode(light, SFX.NONE + SFX.NO_HEATCLOUD)
		return 2                -- leave a heap

	else
		Explode(base, SFX.SHATTER + SFX.NO_HEATCLOUD)
		Explode(bouy, SFX.FIRE + SFX.SMOKE + SFX.EXPLODE + SFX.NO_HEATCLOUD)
		Explode(light, SFX.NONE + SFX.NO_HEATCLOUD)
		return 3                -- leave nothing
	end
end
