include "smokeunit.lua"

local base, blades, post = piece('base', 'blades', 'post')
local smokePieces = {piece "base"}

function script.Create()
  Spring.SetUnitCOBValue(unitID, COB.ACTIVATION, 1)
  StartThread(SmokeUnit, {base})
end

function script.WindChanged(heading, strength)
  Turn(post, y_axis, heading, 0.5)
  Spin(blades, z_axis, strength/7, 0.02)
end

function script.Killed(recentDamage, maxHealth)
	local severity = recentDamage / maxHealth

	if severity < 0.25 then
		Explode(base, SFX.NONE + SFX.NO_HEATCLOUD)
		Explode(blades, SFX.NONE + SFX.NO_HEATCLOUD)
		Explode(post, SFX.NONE + SFX.NO_HEATCLOUD)
		return 1                -- leave a wreck

	elseif severity < 0.50 then
		Explode(base, SFX.SHATTER + SFX.NO_HEATCLOUD)
		Explode(blades, SFX.FIRE + SFX.SMOKE + SFX.EXPLODE + SFX.NO_HEATCLOUD)
		Explode(post, SFX.SHATTER + SFX.NO_HEATCLOUD)
		return 2                -- leave a heap

	else
		Explode(base, SFX.SHATTER + SFX.NO_HEATCLOUD)
		Explode(blades, SFX.FIRE + SFX.SMOKE + SFX.EXPLODE + SFX.NO_HEATCLOUD)
		Explode(post, SFX.SHATTER + SFX.NO_HEATCLOUD)
		return 3                -- leave nothing
	end
end
