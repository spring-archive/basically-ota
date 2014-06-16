include "smokeunit.lua"

local base, cloakdoodads2, pieces = piece('base', 'cloakdoodads2', 'pieces')
local smokePieces = {piece "base"}

function script.Create()
	StartThread(SmokeUnit, {base})
end

function script.Killed(recentDamage, maxHealth)
	local severity = recentDamage / maxHealth

	if severity < 0.25 then
		Explode(base, SFX.NONE)
		Explode(cloakdoodads2, SFX.NONE)
		Explode(pieces, SFX.NONE)
		return 1                -- leave a wreck

	elseif severity < 0.50 then
		Explode(base, SFX.SHATTER)
		Explode(cloakdoodads2, SFX.SHATTER)
		Explode(pieces, SFX.SHATTER)
		return 2                -- leave a heap

	else
		Explode(base, SFX.SHATTER)
		Explode(cloakdoodads2, SFX.SHATTER)
		Explode(pieces, SFX.SHATTER)
		return 3                -- leave nothing
	end
end
