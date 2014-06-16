--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    game_spawn.lua
--  brief:   spawns start unit and sets storage levels
--  author:  Tobi Vollebregt
--
--  Copyright (C) 2010.
--  Licensed under the terms of the GNU GPL, v2 or later.
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
	return {
		name      = "Spawn",
		desc      = "spawns start unit and sets storage levels",
		author    = "Tobi Vollebregt",
		date      = "January, 2010",
		license   = "GNU GPL, v2 or later",
		layer     = 0,
		enabled   = true  --  loaded by default?
	}
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- synced only
if (not gadgetHandler:IsSyncedCode()) then
	return false
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local modOptions = Spring.GetModOptions()


local function GetStartUnit(teamID)
	-- get the team startup info
	local side = select(5, Spring.GetTeamInfo(teamID))
	local startUnit
	if (side == "") then
		-- startscript didn't specify a side for this team
		local sidedata = Spring.GetSideData()
		if (sidedata and #sidedata > 0) then
			startUnit = sidedata[1 + teamID % #sidedata].startUnit
		end
	else
		startUnit = Spring.GetSideData(side)
	end
	return startUnit
end

local function SpawnStartUnit(teamID)
	local startUnit = GetStartUnit(teamID)
	if (startUnit and startUnit ~= "") then
		-- spawn the specified start unit
		local x,y,z = Spring.GetTeamStartPosition(teamID)
		-- snap to 16x16 grid
		x, z = 16*math.floor((x+8)/16), 16*math.floor((z+8)/16)
		y = Spring.GetGroundHeight(x, z)
		-- facing toward map center
		local facing=math.abs(Game.mapSizeX/2 - x) > math.abs(Game.mapSizeZ/2 - z)
			and ((x>Game.mapSizeX/2) and "west" or "east")
			or ((z>Game.mapSizeZ/2) and "north" or "south")
		local unitID = Spring.CreateUnit(startUnit, x, y, z, facing, teamID)
		-- set the *team's* lineage root
		-- Spring.SetUnitLineage(unitID, teamID, true)
	end

	-- set start resources, either from mod options or custom team keys
	local teamOptions = select(7, Spring.GetTeamInfo(teamID))
	local m = teamOptions.startmetal  or modOptions.startmetal  or 1000
	local e = teamOptions.startenergy or modOptions.startenergy or 1000

	-- using SetTeamResource to get rid of any existing resource without affecting stats
	-- using AddTeamResource to add starting resource and counting it as income
	if (m and tonumber(m) ~= 0) then
		-- remove the pre-existing storage
		--   must be done after the start unit is spawned,
		--   otherwise the starting resources are lost!
		Spring.SetTeamResource(teamID, "ms", tonumber(m))
		Spring.SetTeamResource(teamID, "m", 0)
		Spring.AddTeamResource(teamID, "m", tonumber(m))
	end
	if (e and tonumber(e) ~= 0) then
		-- remove the pre-existing storage
		--   must be done after the start unit is spawned,
		--   otherwise the starting resources are lost!
		Spring.SetTeamResource(teamID, "es", tonumber(e))
		Spring.SetTeamResource(teamID, "e", 0)
		Spring.AddTeamResource(teamID, "e", tonumber(e))
	end
end


function gadget:GameStart()
	-- only activate if engine didn't already spawn units (compatibility)
	if (#Spring.GetAllUnits() > 0) then
		return
	end

	-- spawn start units
	local gaiaTeamID = Spring.GetGaiaTeamID()
	local teams = Spring.GetTeamList()
	for i = 1,#teams do
		local teamID = teams[i]
		-- don't spawn a start unit for the Gaia team
		if (teamID ~= gaiaTeamID) then
			SpawnStartUnit(teamID)
		end
	end
end

-------------------------------------------------------------------------
-- communicate player ready states (in addition to statebroadcast gadget)
-------------------------------------------------------------------------
function gadget:AllowStartPosition(x,y,z,playerID,readyState)
	-- communicate readyState to all
	-- 0: unready, 1: ready, 2: game forcestarted & player not ready, 3: game forcestarted & player absent
	-- for some reason 2 is sometimes used in place of 1 and is always used for the last player to become ready
	-- we also add (only used in Initialize) the following
	-- -1: players will not be allowed to place startpoints; automatically readied once ingame
	--  4: player has placed a startpoint but is not yet ready == xta marked state (sent from statebroadcast gadget)
	
	if Game.startPosType == 2 then -- choose in game mode
		Spring.SetGameRulesParam("player_" .. playerID .. "_readyState" , readyState)
	end
	
	local _,_,_,teamID,allyTeamID,_,_,_,_,_ = Spring.GetPlayerInfo(playerID)
	if not teamID or not allyTeamID then return false end --fail
	
	return true
end

function gadget:RecvLuaMsg(msg, playerID)
	local STATEMSG = "181072"
	local COMMMSG = "\177"
	
	if msg:sub(1,#STATEMSG) == STATEMSG then
		local sms = string.sub(msg, string.len(STATEMSG)+1) 
		local state = tonumber(string.sub(sms,1,1))			
		local playerIDMsg = tonumber(string.sub(sms,2))
		
		if playerIDMsg then -- player id is included in message and needs to be used if this was sent from gadget
			if state == 0 then
				Spring.SetGameRulesParam("player_" .. playerIDMsg .. "_readyState" , 0)
			elseif state == 1 then
				-- set state to marked if previous state = unready
				local prevState = Spring.GetGameRulesParam("player_" .. playerIDMsg .. "_readyState")
				if prevState == 0 then
					Spring.SetGameRulesParam("player_" .. playerIDMsg .. "_readyState" , 4)
				end
			end
		end
	end
end
