include "smokeunit.lua"

local barrel1, barrel2, base, flare1, flare2, sleeves, turret = piece('barrel1', 'barrel2', 'base', 'flare1', 'flare2', 'sleeves', 'turret')
local smokePieces = {piece "base", piece "turret"}
local SIG_AIM = 1
local monkey = 1

function script.Create()
	Hide(flare1)
	Hide(flare2)
	StartThread(SmokeUnit, {base, turret})
end

function script.AimWeapon1(heading, pitch)
	Signal(SIG_AIM)
	SetSignalMask(SIG_AIM)
	Turn(turret, y_axis, heading, 0.35)
	Turn(sleeves, x_axis, -pitch, 0.35)
	WaitForTurn(turret, y_axis)
	WaitForTurn(sleeves, x_axis)
	return true
end

function script.FireWeapon1()
 if monkey == 1 then
    Move(barrel1, z_axis, -6, 200)
    Sleep(100)
    Move(barrel1, z_axis, 0, 2)
  end
  if monkey == 2 then
    Move(barrel2, z_axis, -6, 200)
    Sleep(100)
    Move(barrel2, z_axis, 0, 2)
  end

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
		Explode(sleeves, SFX.NONE)
		Explode(turret, SFX.NONE)
		return 1                -- leave a wreck

	elseif severity < 0.50 then
		Explode(barrel1, SFX.FALL)
		Explode(barrel2, SFX.FALL)
		Explode(base, SFX.SHATTER)
		Explode(sleeves, SFX.FIRE + SFX.SMOKE + SFX.EXPLODE)
		Explode(turret, SFX.SHATTER)
		return 2                -- leave a heap

	else
		Explode(barrel1, SFX.FALL)
		Explode(barrel2, SFX.FALL)
		Explode(base, SFX.SHATTER)
		Explode(sleeves, SFX.FIRE + SFX.SMOKE + SFX.EXPLODE)
		Explode(turret, SFX.SHATTER)
		return 3                -- leave nothing
	end
end
