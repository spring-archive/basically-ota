include "smokeunit.lua"

local base, gun1, gun2, gun3, rocket1, rocket2, rocket3, turret = piece('base', 'gun1', 'gun2', 'gun3', 'rocket1', 'rocket2', 'rocket3', 'turret')
local smokePieces = {piece "base", piece "turret"}
local SIG_AIM = 1
local monkey = 1

function script.Create()
	StartThread(SmokeUnit, {base, turret})
end

function script.AimWeapon1(heading, pitch)
	Signal(SIG_AIM)
	SetSignalMask(SIG_AIM)
	Turn(turret, x_axis, -pitch, 5)
	Turn(turret, y_axis, heading, 5)
	WaitForTurn(turret, x_axis)
	WaitForTurn(turret, y_axis)
	return true
end

function script.FireWeapon1()
  if monkey == 1 then
    Move(gun1, z_axis, -3)
    Sleep(100)
    Move(gun1, z_axis, 0, 2)
  end
  if monkey == 2 then
    Move(gun2, z_axis, -3)
    Sleep(100)
    Move(gun2, z_axis, 0, 2)
  end
  if monkey == 3 then
    Move(gun3, z_axis, -3)
    Sleep(100)
    Move(gun3, z_axis, 0, 2)
  end

  monkey = monkey + 1
  if monkey == 4 then
    monkey = 1
  end
end

function script.AimFromWeapon1()
	if monkey == 1 then
    return gun1
	end
	if monkey == 2 then
    return gun2
	end
	if monkey == 3 then
    return gun3
	end
end

function script.QueryWeapon1()
	if monkey == 1 then
    return gun1
	end
	if monkey == 2 then
    return gun2
	end
	if monkey == 3 then
    return gun3
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
