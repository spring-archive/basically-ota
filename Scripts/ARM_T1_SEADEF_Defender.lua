include "smokeunit.lua"

local barrel, base, flare, gun, turret = piece('barrel', 'base', 'flare', 'gun', 'turret')
local smokePieces = {piece "base", piece "gun"}
local SIG_AIM = 1
local monkey = 1

function script.Create()
	Hide(flare)
	StartThread(SmokeUnit, {base, gun})
end

function script.AimWeapon1(heading, pitch)
	Signal(SIG_AIM)
	SetSignalMask(SIG_AIM)
	Turn(turret, y_axis, heading, 5)
	Turn(gun, x_axis, -pitch, 5)
  if monkey == 1 then
    Turn(barrel, z_axis, 0, 4)
  end
  if monkey == 2 then
    Turn(barrel, z_axis, 2.0943951, 4)
  end
  if monkey == 3 then
    Turn(barrel, z_axis, 4.1887902, 4)
  end
	WaitForTurn(barrel, z_axis)
	WaitForTurn(turret, y_axis)
	WaitForTurn(gun, x_axis)
	return true
end

function script.FireWeapon1()
  monkey = monkey + 1
  if monkey == 4 then
    monkey = 1
  end
end

function script.RockUnit(x, z)
  Turn(base, x_axis, 0.1*x, 0.5)
  Turn(base, z_axis, 0.1*z, 0.5)
	WaitForTurn(base, x_axis)
	WaitForTurn(base, z_axis)

	Turn(base, x_axis, 0, 0.2)
	Turn(base, z_axis, 0, 0.2)
	WaitForTurn(base, x_axis)
	WaitForTurn(base, z_axis)
end

function script.AimFromWeapon1()
	return barrel
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
		Explode(gun, SFX.NONE)
		return 1                -- leave a wreck

	elseif severity < 0.50 then
		Explode(barrel, SFX.FALL)
		Explode(base, SFX.SHATTER)
		Explode(turret, SFX.SHATTER)
		Explode(gun, SFX.FIRE + SFX.SMOKE + SFX.EXPLODE)
		return 2                -- leave a heap

	else
		Explode(barrel, SFX.SHATTER)
		Explode(base, SFX.SHATTER)
		Explode(turret, SFX.SHATTER)
		Explode(gun, SFX.FIRE + SFX.SMOKE + SFX.EXPLODE)
		return 3                -- leave nothing
	end
end
