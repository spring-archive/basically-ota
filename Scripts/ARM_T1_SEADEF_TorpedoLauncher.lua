include "smokeunit.lua"

local base, flare, gun = piece('base', 'flare', 'gun')
local smokePieces = {piece "base"}
local SIG_AIM = 1

function script.Create()
	Hide(flare)
	StartThread(SmokeUnit, {base})
end

function script.AimWeapon1(heading, pitch)
	Signal(SIG_AIM)
	SetSignalMask(SIG_AIM)
	Turn(gun, y_axis, heading, 5)
	Turn(gun, x_axis, -pitch, 5)
	WaitForTurn(gun, y_axis)
	WaitForTurn(gun, x_axis)
	return true
end

function script.FireWeapon1()
end

function script.AimFromWeapon1()
	return gun
end

function script.QueryWeapon1()
	return flare
end

function script.Killed(recentDamage, maxHealth)
	local severity = recentDamage / maxHealth

	if severity < 0.25 then
		Explode(base, SFX.NONE + SFX.NO_HEATCLOUD)
		Explode(gun, SFX.NONE + SFX.NO_HEATCLOUD)
		return 1                -- leave a wreck

	elseif severity < 0.50 then
		Explode(base, SFX.FIRE + SFX.SMOKE + SFX.EXPLODE + SFX.NO_HEATCLOUD)
		Explode(gun, SFX.NONE + SFX.NO_HEATCLOUD)
		return 2                -- leave a heap

	else
		Explode(base, SFX.FIRE + SFX.SMOKE + SFX.EXPLODE + SFX.NO_HEATCLOUD)
		Explode(gun, SFX.NONE + SFX.NO_HEATCLOUD)
		return 3                -- leave nothing
	end
end
