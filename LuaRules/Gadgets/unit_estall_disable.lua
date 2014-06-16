--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    unit_estall_disable.lua
--  brief:   disables units during energy stall
--  author:  
--
--  Copyright (C) 2007.
--  Licensed under the terms of the GNU GPL, v2 or later.
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
  return {
    name      = "UnitEStallDisable",
    desc      = "Deactivates units during energy stall",
    author    = "Licho",
    date      = "23.7.2007",
    license   = "GNU GPL, v2 or later",
    layer     = 0,
    enabled   = true  --  loaded by default?
  }
end

--------------------------------------------------------------------------------
if (gadgetHandler:IsSyncedCode()) then
--------------------------------------------------------------------------------
--  SYNCED
--------------------------------------------------------------------------------

--Speed-ups

local insert            = table.insert
local GiveOrderToUnit		= Spring.GiveOrderToUnit
local GetUnitStates			= Spring.GetUnitStates
local GetUnitTeam				= Spring.GetUnitTeam
local GetUnitResources	= Spring.GetUnitResources
local GetGameSeconds    = Spring.GetGameSeconds

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local units = {}
local disabledUnits = {}
local changeStateDelay = 3 -- delay in seconds before state of unit can be changed. Do not set it below 2 seconds, because it takes 2 seconds before enabled unit reaches full energy use
local radarDefs = {
  [ UnitDefNames['arm_t1_def_radartower'].id ] = true,
  [ UnitDefNames['arm_t1_eco_metalextractor'].id ] = true,
	[ UnitDefNames['arm_t1_seadef_sonarstation'].id ] = true,
	[ UnitDefNames['arm_t1_seaeco_uwmetalextractor'].id ] = true,
  [ UnitDefNames['arm_t2_air_eagle'].id ] = true,
  [ UnitDefNames['arm_t2_air_seahawk'].id ] = true,
  [ UnitDefNames['arm_t2_bot_decoycommander'].id ] = true,
  [ UnitDefNames['arm_t2_bot_eraser'].id ] = true,
  [ UnitDefNames['arm_t2_bot_marky'].id ] = true,
  [ UnitDefNames['arm_t2_def_advancedradar'].id ] = true,
  [ UnitDefNames['arm_t2_eco_mohomine'].id ] = true,
  [ UnitDefNames['arm_t2_sea_escort'].id ] = true,
  [ UnitDefNames['arm_t2_sea_fibber'].id ] = true,
  [ UnitDefNames['arm_t2_seadef_advancedsonar'].id ] = true,
  [ UnitDefNames['arm_t2_veh_jammer'].id ] = true,
  [ UnitDefNames['arm_t2_veh_seer'].id ] = true,
  [ UnitDefNames['core_t1_def_radartower'].id ] = true,
  [ UnitDefNames['core_t1_eco_metalextractor'].id ] = true,
  [ UnitDefNames['core_t1_seadef_sonarstation'].id ] = true,
  [ UnitDefNames['core_t1_seaeco_uwmetalextractor'].id ] = true,
  [ UnitDefNames['core_t2_air_hunter'].id ] = true,
  [ UnitDefNames['core_t2_air_vulture'].id ] = true,
  [ UnitDefNames['core_t2_bot_decoycommander'].id ] = true,
  [ UnitDefNames['core_t2_bot_spectre'].id ] = true,
  [ UnitDefNames['core_t2_bot_voyeur'].id ] = true,
  [ UnitDefNames['core_t2_def_advancedradar'].id ] = true,
  [ UnitDefNames['core_t2_eco_mohomine'].id ] = true,
  [ UnitDefNames['core_t2_sea_phantom'].id ] = true,
  [ UnitDefNames['core_t2_seadef_advancedsonar'].id ] = true,
  [ UnitDefNames['core_t2_veh_deleter'].id ] = true,
  [ UnitDefNames['core_t2_veh_informer'].id ] = true,
}


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:Initialize()
  for _,unitID in ipairs(Spring.GetAllUnits()) do
    local unitDefID = Spring.GetUnitDefID(unitID)
		AddUnit(unitID, unitDefID)
	end
end


function AddUnit(unitID, unitDefID) 
  if (radarDefs[unitDefID]) then
		units[unitID] = { defID = unitDefID, changeStateTime = GetGameSeconds() } 
  end
end

function RemoveUnit(unitID) 
  units[unitID] = nil
  disabledUnits[unitID] = nil
end


--[[ Using UnitFinished instead of UnitCreated so that the changeStateDelay
counts from the point in time when the unit is finish built.
This prevents units from being switched off, when they take longer than
changeStateDelay to be built. ]]
function gadget:UnitFinished(unitID, unitDefID, teamID)
	AddUnit(unitID, unitDefID)
end

function gadget:UnitTaken(unitID, unitDefID)
	AddUnit(unitID, unitDefID)
end

function gadget:UnitGiven(unitID, unitDefID, newTeamID)
  if (newTeamID==nil) then RemoveUnit(unitID) end
end


function gadget:UnitDestroyed(unitID)
  RemoveUnit(unitID)
end



function gadget:GameFrame(n)
  if (((n+8) % 64) < 0.1) then
		local teamEnergy = {}
		local gameSeconds = GetGameSeconds()
    local temp = Spring.GetTeamList() 
		for _,teamID in ipairs(temp) do 
			local eCur, eMax, ePull, eInc, _, _, _, eRec = Spring.GetTeamResources(teamID, "energy")
			teamEnergy[teamID] = eCur - ePull + eInc
		end 
		


		for unitID,data in pairs(units) do
      if (gameSeconds - data.changeStateTime > changeStateDelay) then
        local disabledUnitEnergyUse = disabledUnits[unitID] 
        if (disabledUnitEnergyUse~=nil) then -- we have disabled unit
          local unitTeamID = GetUnitTeam(unitID)
          if (disabledUnitEnergyUse < teamEnergy[unitTeamID]) then  -- we still have enough energy to reenable unit
            disabledUnits[unitID]=nil
            GiveOrderToUnit(unitID, CMD.ONOFF, { 1 }, { })
            data.changeStateTime = gameSeconds
            teamEnergy[unitTeamID] = teamEnergy[unitTeamID] - disabledUnitEnergyUse
          end
        else -- we have non-disabled unit
          local _, _, _, energyUse =	GetUnitResources(unitID)
          local energyUpkeep = UnitDefs[data.defID].energyUpkeep
          if (energyUse == nil or energyUpkeep == nil) then -- unit probably doesnt exists, get rid of it
            RemoveUnit(unitID)
          elseif (energyUse < energyUpkeep) then -- there is not enough energy to keep unit running (its energy use auto dropped to 0), we will disable it 
            if (GetUnitStates(unitID).active) then  -- only disable "active" unit
              GiveOrderToUnit(unitID, CMD.ONOFF, { 0 }, { })
              data.changeStateTime = gameSeconds
              disabledUnits[unitID] = energyUpkeep
            end				
          end
        end
      end
		end
	end
end


function gadget:AllowCommand(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions)
	if (cmdID == CMD.ONOFF and disabledUnits[unitID]~=nil) then
    return false
  else 
		return true
	end
end
 
  
--------------------------------------------------------------------------------
--  END SYNCED
--------------------------------------------------------------------------------
end
