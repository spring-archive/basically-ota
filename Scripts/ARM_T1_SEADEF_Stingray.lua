include "smokeunit.lua"

local barrel1, barrel2, base, flare1, flare2, gun, turret = piece('barrel1', 'barrel2', 'base', 'flare1', 'flare2', 'gun', 'turret')
local smokePieces = {piece "gun"}
local SIG_AIM = 1
local monkey = 1

function script.Create()
	Hide(flare1)
	Hide(flare2)
	StartThread(SmokeUnit, {gun})
end

function script.AimWeapon1(heading, pitch)
	Signal(SIG_AIM)
	SetSignalMask(SIG_AIM)
  Turn(gun, x_axis, -pitch, 3)
	Turn(turret, y_axis, heading, 3)
  WaitForTurn(gun, x_axis)
	WaitForTurn(turret, y_axis)
	return true
end

function script.FireWeapon1()
  monkey = monkey + 1
  if monkey == 3 then
    monkey = 1
  end
end

function script.AimFromWeapon1()
  if monkey == 1 then
    return barrel1
  else
    return barrel2
	end
end

function script.QueryWeapon1()
  if monkey == 1 then
    return flare1
  else
    return flare2
	end
end

function script.Killed(recentDamage, maxHealth)
	local severity = recentDamage / maxHealth

	if severity < 0.25 then
		Explode(barrel1, SFX.NONE)
		Explode(barrel2, SFX.NONE)
		Explode(base, SFX.NONE)
		Explode(gun, SFX.NONE)
		Explode(turret, SFX.NONE)
		return 1                -- leave a wreck

	elseif severity < 0.50 then
		Explode(barrel1, SFX.SHATTER)
		Explode(barrel2, SFX.SHATTER)
		Explode(base, SFX.SHATTER)
		Explode(gun, SFX.FIRE + SFX.SMOKE + SFX.EXPLODE)
		Explode(turret, SFX.SHATTER)
		return 2                -- leave a heap

	else
		Explode(barrel1, SFX.FIRE + SFX.SMOKE + SFX.EXPLODE)
		Explode(barrel2, SFX.FIRE + SFX.SMOKE + SFX.EXPLODE)
		Explode(base, SFX.SHATTER)
		Explode(gun, SFX.FIRE + SFX.SMOKE + SFX.EXPLODE)
		Explode(turret, SFX.SHATTER)
		return 3                -- leave nothing
	end
end
