include "smokeunit.lua"

local base, flare, gun, stand = piece('base', 'flare', 'gun', 'stand')
local smokePieces = {piece "base", piece "gun"}
local SIG_AIM = 1

function script.Create()
	Hide(flare)
	StartThread(SmokeUnit, {base, gun})
end

function script.AimWeapon1(heading, pitch)
	Signal(SIG_AIM)
	SetSignalMask(SIG_AIM)
	Turn(gun, x_axis, -pitch, 5)
	Turn(stand, y_axis, heading, 5)
	WaitForTurn(gun, x_axis)
	WaitForTurn(stand, y_axis)
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
		Explode(base, SFX.NONE)
		Explode(gun, SFX.NONE)
		Explode(stand, SFX.NONE)
		return 1                -- leave a wreck

	elseif severity < 0.50 then
		Explode(base, SFX.SHATTER)
		Explode(gun, SFX.FIRE + SFX.SMOKE + SFX.EXPLODE)
		Explode(stand, SFX.SHATTER)
		return 2                -- leave a heap

	else
		Explode(base, SFX.SHATTER)
		Explode(gun, SFX.FIRE + SFX.SMOKE + SFX.EXPLODE)
		Explode(stand, SFX.SHATTER)
		return 3                -- leave nothing
	end
end
