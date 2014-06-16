include "smokeunit.lua"

local arms, base = piece('arms', 'base')
local smokePieces = {piece "base"}
local extractionspeed = 1

function script.Create()
  StartThread(SmokeUnit, {base})
end

function script.ExtractionRateChanged(income)
  extractionspeed = income
  Spin(arms, y_axis, income, 0.02)
end

function script.Activate()
  Spin(arms, y_axis, extractionspeed, 0.02)
end

function script.Deactivate()
  StopSpin(arms, y_axis, 0.02)
end

function script.Killed(recentDamage, maxHealth)
	local severity = recentDamage / maxHealth

	if severity < 0.25 then
		Explode(arms, SFX.NONE + SFX.NO_HEATCLOUD)
		Explode(base, SFX.NONE + SFX.NO_HEATCLOUD)
		return 1                -- leave a wreck

	elseif severity < 0.50 then
		Explode(arms, SFX.FIRE + SFX.SMOKE + SFX.EXPLODE + SFX.NO_HEATCLOUD)
		Explode(base, SFX.SHATTER + SFX.NO_HEATCLOUD)
		return 2                -- leave a heap

	else
		Explode(arms, SFX.FIRE + SFX.SMOKE + SFX.EXPLODE + SFX.NO_HEATCLOUD)
		Explode(base, SFX.SHATTER + SFX.NO_HEATCLOUD)
		return 3                -- leave nothing
	end
end
