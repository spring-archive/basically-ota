include "smokeunit.lua"

local base, flare, launcher, turret = piece('base', 'flare', 'launcher', 'turret')
local smokePieces = {piece "base"}
local SIG_AIM = 1

function script.Create()
	Hide(flare)
	StartThread(SmokeUnit, {base})
end

function script.AimWeapon1(heading, pitch)
	Signal(SIG_AIM)
	SetSignalMask(SIG_AIM)
	Turn(turret, y_axis, heading, 5)
	WaitForTurn(turret, y_axis)
	return true
end

function script.FireWeapon1()
  Move(launcher, z_axis, -10, 100)
  Sleep(100)
  Move(launcher, z_axis, 0, 5)
end

function script.AimFromWeapon1()
	return launcher
end

function script.QueryWeapon1()
	return flare
end

function script.Killed(recentDamage, maxHealth)
	local severity = recentDamage / maxHealth

	if severity < 0.25 then
		Explode(base, SFX.NONE + SFX.NO_HEATCLOUD)
		Explode(launcher, SFX.NONE + SFX.NO_HEATCLOUD)
		Explode(turret, SFX.NONE + SFX.NO_HEATCLOUD)
		return 1                -- leave a wreck

	elseif severity < 0.50 then
		Explode(base, SFX.FIRE + SFX.SMOKE + SFX.EXPLODE + SFX.NO_HEATCLOUD)
		Explode(launcher, SFX.NONE + SFX.NO_HEATCLOUD)
		Explode(turret, SFX.NONE + SFX.NO_HEATCLOUD)
		return 2                -- leave a heap

	else
		Explode(base, SFX.FIRE + SFX.SMOKE + SFX.EXPLODE + SFX.NO_HEATCLOUD)
		Explode(launcher, SFX.NONE + SFX.NO_HEATCLOUD)
		Explode(turret, SFX.NONE + SFX.NO_HEATCLOUD)
		return 3                -- leave nothing
	end
end
