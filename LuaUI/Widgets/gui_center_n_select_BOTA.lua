function widget:GetInfo()
  return {
    name      = "Select n Center! - BOTA",
    desc      = "Selects and centers the Commander at the start of the game.",
    author    = "quantum", --modified by Deadnight Warrior for mission script compatibility
    date      = "22/06/2007",
    license   = "GNU GPL, v2 or later",
    layer     = 5,
    enabled   = true  --  loaded by default?
  }
end
local center = true
local select = true
local unitList = {}
local ZOOMHEIGHT = 1600

function widget:Update()
	local t = Spring.GetGameSeconds()
	if t > 2 then
		widgetHandler:RemoveWidget()
		return
	end
	if center and t > 0 then
		--Spring.Echo("center")
		unitList = Spring.GetTeamUnits(Spring.GetMyTeamID())		
		local x, y, z = Spring.GetUnitPosition(unitList[1])
		local camState = Spring.GetCameraState()
		local currentHeight = camState["height"]
		camState["px"] = x
		camState["py"] = y
		camState["pz"] = z
		camState["height"] = ZOOMHEIGHT
		if currentHeight > ZOOMHEIGHT then
			Spring.SetCameraState(camState,0.5)
		end
		
		center = false
	end
	if select and t > 0 then
		--Spring.Echo("select")
		Spring.SelectUnitArray({unitList[1]})
		select = false
	end
end

function widget:Initialize()
	if Spring.GetSpectatingState() or Spring.IsReplay() then
		widgetHandler:RemoveWidget()
	end
end