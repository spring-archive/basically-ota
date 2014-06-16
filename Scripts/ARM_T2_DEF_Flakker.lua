include "smokeunit.lua"

local barrel1, barrel2, base, flare1, flare2, xturret, yturret = piece('barrel1', 'barrel2', 'base', 'flare1', 'flare2', 'xturret', 'yturret')
local smokePieces = {piece "base", piece "yturret"}
local SIG_AIM = 1
local monkey = 1

function script.Create()
  Hide(flare1)
  Hide(flare2)
	StartThread(SmokeUnit, {base, yturret})
end

function script.AimWeapon1(heading, pitch)
	Signal(SIG_AIM)
	SetSignalMask(SIG_AIM)
	Turn(yturret, x_axis, -pitch, 5)
	Turn(xturret, y_axis, heading, 5)
	WaitForTurn(yturret, x_axis)
	WaitForTurn(xturret, y_axis)
	return true
end

function script.FireWeapon1()
  if monkey == 1 then
    Move(barrel1, z_axis, -6)
    Sleep(100)
    Move(barrel1, z_axis, 0, 5)
  end
  if monkey == 2 then
    Move(barrel2, z_axis, -6)
    Sleep(100)
    Move(barrel2, z_axis, 0, 5)
  end

  monkey = monkey + 1
  if monkey == 3 then
    monkey = 1
  end
end

function script.AimFromWeapon1()
	if monkey == 1 then
    return barrel1
	end
	if monkey == 2 then
    return barrel2
	end
end

function script.QueryWeapon1()
	if monkey == 1 then
    return flare1
	end
	if monkey == 2 then
    return flare2
	end
end

function script.Killed(recentDamage, maxHealth)
	local severity = recentDamage / maxHealth

	if severity < 0.25 then
		Explode(base, SFX.NONE)
		Explode(yturret, SFX.NONE)
		return 1                -- leave a wreck

	elseif severity < 0.50 then
		Explode(base, SFX.SHATTER)
		Explode(yturret, SFX.FIRE + SFX.SMOKE + SFX.EXPLODE)
		return 2                -- leave a heap

	else
		Explode(base, SFX.SHATTER)
		Explode(yturret, SFX.FIRE + SFX.SMOKE + SFX.EXPLODE)
		return 3                -- leave nothing
	end
end
