include "smokeunit.lua"

local barrel, base, flare, sleeve, turret = piece('barrel', 'base', 'flare', 'sleeve', 'turret')
local smokePieces = {piece "base", piece "sleeve"}
local SIG_AIM = 1

function script.Create()
	Hide(flare)
	StartThread(SmokeUnit, {base, sleeve})
end

function script.AimWeapon1(heading, pitch)
	Signal(SIG_AIM)
	SetSignalMask(SIG_AIM)
	Turn(turret, y_axis, heading, 0.09)
	Turn(sleeve, x_axis, -pitch, 0.09)
	WaitForTurn(turret, y_axis)
	WaitForTurn(sleeve, x_axis)
	return true
end

function script.FireWeapon1()
  Move(barrel, z_axis, -50, 400)
  Sleep(200)
  Move(barrel, z_axis, 0, 20)
end

function script.AimFromWeapon1()
	return sleeve
end

function script.QueryWeapon1()
	return flare
end

function script.Killed(recentDamage, maxHealth)
	local severity = recentDamage / maxHealth

	if severity < 0.25 then
		Explode(barrel, SFX.NONE)
		Explode(base, SFX.NONE)
		Explode(turret, SFX.NONE)
		Explode(sleeve, SFX.NONE)
		return 1                -- leave a wreck

	elseif severity < 0.50 then
		Explode(barrel, SFX.FALL)
		Explode(base, SFX.SHATTER)
		Explode(turret, SFX.SHATTER)
		Explode(sleeve, SFX.FIRE + SFX.SMOKE + SFX.EXPLODE)
		return 2                -- leave a heap

	else
		Explode(barrel, SFX.SHATTER)
		Explode(base, SFX.SHATTER)
		Explode(turret, SFX.SHATTER)
		Explode(sleeve, SFX.FIRE + SFX.SMOKE + SFX.EXPLODE)
		return 3                -- leave nothing
	end
end
