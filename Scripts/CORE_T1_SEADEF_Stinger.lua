include "smokeunit.lua"

local base, barrel1, barrel2, barrel3, flare1, flare2, flare3, turret = piece('base', 'barrel1', 'barrel2', 'barrel3', 'flare1', 'flare2', 'flare3', 'turret')
local smokePieces = {piece "base", piece "turret"}
local SIG_AIM = 1
local monkey = 1

function script.Create()
	StartThread(SmokeUnit, {base, turret})
end

function script.AimWeapon1(heading, pitch)
	Signal(SIG_AIM)
	SetSignalMask(SIG_AIM)
	Turn(turret, y_axis, heading, 5)
	Turn(turret, x_axis, -pitch, 5)
	WaitForTurn(turret, y_axis)
	WaitForTurn(turret, x_axis)
	return true
end

function script.FireWeapon1()
  if monkey == 1 then
    Move(barrel1, z_axis, -3)
    Sleep(100)
    Move(barrel1, z_axis, 0, 2)
  end
  if monkey == 2 then
    Move(barrel2, z_axis, -3)
    Sleep(100)
    Move(barrel2, z_axis, 0, 2)
  end
  if monkey == 3 then
    Move(barrel3, z_axis, -3)
    Sleep(100)
    Move(barrel3, z_axis, 0, 2)
  end

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
	if monkey == 1 then
    return barrel1
	end
	if monkey == 2 then
    return barrel2
	end
	if monkey == 3 then
    return barrel3
	end
end

function script.QueryWeapon1()
	if monkey == 1 then
    return flare1
	end
	if monkey == 2 then
    return flare2
	end
	if monkey == 3 then
    return flare3
	end
end

function script.Killed(recentDamage, maxHealth)
	local severity = recentDamage / maxHealth

	if severity < 0.25 then
		Explode(base, SFX.NONE)
		Explode(turret, SFX.NONE)
		return 1                -- leave a wreck

	elseif severity < 0.50 then
		Explode(base, SFX.SHATTER)
		Explode(turret, SFX.FIRE + SFX.SMOKE + SFX.EXPLODE)
		return 2                -- leave a heap

	else
		Explode(base, SFX.SHATTER)
		Explode(turret, SFX.FIRE + SFX.SMOKE + SFX.EXPLODE)
		return 3                -- leave nothing
	end
end
