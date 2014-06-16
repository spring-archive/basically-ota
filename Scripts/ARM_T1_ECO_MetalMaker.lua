include "smokeunit.lua"

local base, sphere = piece('base', 'sphere')
local smokePieces = {piece "sphere"}
local SIG_HITBYWEAPON = 1

function script.Create()
  Move(sphere, y_axis, -7)
  StartThread(SmokeUnit, {sphere})
end

function script.Activate()
  Move(sphere, y_axis, 0, 3)
end

function script.Deactivate()
  Move(sphere, y_axis, -7, 3)
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
		Explode(sphere, SFX.NONE + SFX.NO_HEATCLOUD)
		return 1                -- leave a wreck

	elseif severity < 0.50 then
		Explode(base, SFX.SHATTER + SFX.NO_HEATCLOUD)
		Explode(sphere, SFX.FIRE + SFX.SMOKE + SFX.EXPLODE + SFX.NO_HEATCLOUD)
		return 2                -- leave a heap

	else
		Explode(base, SFX.SHATTER + SFX.NO_HEATCLOUD)
		Explode(sphere, SFX.FIRE + SFX.SMOKE + SFX.EXPLODE + SFX.NO_HEATCLOUD)
		return 3                -- leave nothing
	end
end
