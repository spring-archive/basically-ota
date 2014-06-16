include "smokeunit.lua"

local base, flash1, flash2, guns, turret = piece('base', 'flash1', 'flash2', 'guns', 'turret')
local smokePieces = {piece "base", piece "guns"}
local SIG_AIM = 1
local monkey = 1

function script.Create()
	Hide(flash1)
	Hide(flash2)
	StartThread(SmokeUnit, {base, guns})
end

function script.AimWeapon1(heading, pitch)
	Signal(SIG_AIM)
	SetSignalMask(SIG_AIM)
  Turn(guns, x_axis, -pitch, 5)
	Turn(turret, y_axis, heading, 5)
  WaitForTurn(guns, x_axis)
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
    return flash1
  else
    return flash2
	end
end

function script.QueryWeapon1()
  if monkey == 1 then
    return flash1
  else
    return flash2
	end
end

function script.Killed(recentDamage, maxHealth)
	local severity = recentDamage / maxHealth

	if severity < 0.25 then
		Explode(base, SFX.NONE)
		Explode(guns, SFX.NONE)
		Explode(turret, SFX.NONE)
		return 1                -- leave a wreck

	elseif severity < 0.50 then
		Explode(base, SFX.SHATTER)
		Explode(guns, SFX.FIRE + SFX.SMOKE + SFX.EXPLODE)
		Explode(turret, SFX.SHATTER)
		return 2                -- leave a heap

	else
		Explode(base, SFX.SHATTER)
		Explode(guns, SFX.FIRE + SFX.SMOKE + SFX.EXPLODE)
		Explode(turret, SFX.SHATTER)
		return 3                -- leave nothing
	end
end
