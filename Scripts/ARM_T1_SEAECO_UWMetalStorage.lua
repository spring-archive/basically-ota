local base, canisters, topdoodads = piece('base', 'canisters', 'topdoodads')

function script.Create()
end

function script.Killed(recentDamage, maxHealth)
	local severity = recentDamage / maxHealth

	if severity < 0.25 then
		Explode(base, SFX.NONE)
		Explode(canisters, SFX.NONE)
		Explode(topdoodads, SFX.NONE)
		return 1                -- leave a wreck

	elseif severity < 0.50 then
		Explode(base, SFX.SHATTER)
		Explode(canisters, SFX.SHATTER)
		Explode(topdoodads, SFX.SHATTER)
		return 2                -- leave a heap

	else
		Explode(base, SFX.SHATTER)
		Explode(canisters, SFX.SHATTER)
		Explode(topdoodads, SFX.SHATTER)
		return 3                -- leave nothing
	end
end
