local arms, base, emit1, emit2, emit3 = piece('arms', 'base', 'emit1', 'emit2', 'emit3')
local extractionspeed = 1

local function MakeBubbles()
  while extractionspeed > 0 do
    EmitSfx(emit1, 259)
    EmitSfx(emit2, 259)
    EmitSfx(emit3, 259)
    Sleep(300)
  end
end

function script.Create()
  StartThread(MakeBubbles)
end

function script.ExtractionRateChanged(income)
  extractionspeed = income
  Spin(arms, y_axis, extractionspeed, 0.02)
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
