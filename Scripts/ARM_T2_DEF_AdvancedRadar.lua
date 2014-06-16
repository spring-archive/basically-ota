include "smokeunit.lua"

local arm1, arm2, base, dish1, dish2, post, turret = piece('arm1', 'arm2', 'base', 'dish1', 'dish2', 'post', 'turret')
local smokePieces = {piece "post"}
local SIG_HITBYWEAPON = 1
local SIG_ANIMATION = 2
local animationwanted = nil

function script.Create()
  StartThread(SmokeUnit, {post})
end

local function DoAnimation(animationwanted)
	Signal(SIG_ANIMATION)
	SetSignalMask(SIG_ANIMATION)
  if animationwanted == 1 then
    Turn(dish1, z_axis, -1.46, 0.7)
    Turn(dish2, z_axis, 1.46, 0.7)
    Move(post, y_axis, 25, 10)
    --WaitForMove(post, y_axis)
    Spin(turret, y_axis, 0.8, 0.02)
    Spin(arm1, x_axis, -1.6, 0.02)
    Spin(arm2, x_axis, 1.6, 0.02)
  end
  if animationwanted == 2 then
    StopSpin(turret, y_axis)
    StopSpin(arm1, x_axis)
    StopSpin(arm2, x_axis)
    Turn(turret, y_axis, 0, 0.8)
    Turn(arm1, x_axis, 0, 1.6)
    Turn(arm2, x_axis, 0, 1.6)
    --WaitForTurn(turret, y_axis)
    Turn(dish1, z_axis, 0, 0.7)
    Turn(dish2, z_axis, 0, 0.7)
    Move(post, y_axis, 0, 10)
  end
end

function script.Activate()
  StartThread(DoAnimation, 1)
end

function script.Deactivate()
  StartThread(DoAnimation, 2)
end

local function HitByWeapon()
	Signal(SIG_HITBYWEAPON)
	SetSignalMask(SIG_HITBYWEAPON)
  Spring.GiveOrderToUnit(unitID, CMD.ONOFF, {0}, {})
  Sleep(8000)
  Spring.GiveOrderToUnit(unitID, CMD.ONOFF, {1}, {})
end

function script.HitByWeapon()
  StartThread(HitByWeapon)
end

function script.Killed(recentDamage, maxHealth)
	local severity = recentDamage / maxHealth

	if severity < 0.25 then
		Explode(arm1, SFX.NONE + SFX.NO_HEATCLOUD)
		Explode(arm2, SFX.NONE + SFX.NO_HEATCLOUD)
		Explode(base, SFX.NONE + SFX.NO_HEATCLOUD)
		Explode(dish1, SFX.NONE + SFX.NO_HEATCLOUD)
		Explode(dish2, SFX.NONE + SFX.NO_HEATCLOUD)
		Explode(post, SFX.NONE + SFX.NO_HEATCLOUD)
		Explode(turret, SFX.NONE + SFX.NO_HEATCLOUD)
		return 1                -- leave a wreck

	elseif severity < 0.50 then
		Explode(arm1, SFX.NONE + SFX.NO_HEATCLOUD)
		Explode(arm2, SFX.NONE + SFX.NO_HEATCLOUD)
		Explode(base, SFX.SHATTER + SFX.NO_HEATCLOUD)
		Explode(dish1, SFX.FIRE + SFX.SMOKE + SFX.EXPLODE + SFX.NO_HEATCLOUD)
		Explode(dish2, SFX.FIRE + SFX.SMOKE + SFX.EXPLODE + SFX.NO_HEATCLOUD)
		Explode(post, SFX.NONE + SFX.NO_HEATCLOUD)
		Explode(turret, SFX.NONE + SFX.NO_HEATCLOUD)
		return 2                -- leave a heap

	else
		Explode(arm1, SFX.NONE + SFX.NO_HEATCLOUD)
		Explode(arm2, SFX.NONE + SFX.NO_HEATCLOUD)
		Explode(base, SFX.SHATTER + SFX.NO_HEATCLOUD)
		Explode(dish1, SFX.FIRE + SFX.SMOKE + SFX.EXPLODE + SFX.NO_HEATCLOUD)
		Explode(dish2, SFX.FIRE + SFX.SMOKE + SFX.EXPLODE + SFX.NO_HEATCLOUD)
		Explode(post, SFX.NONE + SFX.NO_HEATCLOUD)
		Explode(turret, SFX.NONE + SFX.NO_HEATCLOUD)
		return 3                -- leave nothing
	end
end
