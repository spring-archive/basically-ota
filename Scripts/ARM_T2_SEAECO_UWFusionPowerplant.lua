local base, emit1 = piece('base', 'emit1')

function script.Create()
end

function script.Killed(recentDamage, maxHealth)
	local severity = recentDamage / maxHealth

	if severity < 0.25 then
		Explode(base, SFX.NONE)
		return 1                -- leave a wreck

	elseif severity < 0.50 then
		Explode(base, SFX.SHATTER)
		return 2                -- leave a heap

	else
		Explode(base, SFX.SHATTER)
		return 3                -- leave nothing
	end
end
