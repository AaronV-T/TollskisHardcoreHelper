TollskisHardcoreHelper_Settings = nil

TollskisHardcoreHelper_EventManager = {
  EventHandlers = {},
}

local EM = TollskisHardcoreHelper_EventManager
-- local Controller = AutoBiographer_Controller

-- Slash Commands

SLASH_TOLLSKISHARDCOREHELPER1, SLASH_TOLLSKISHARDCOREHELPER2 = "/tollskishardcorehelper", "/thh"
function SlashCmdList.TOLLSKISHARDCOREHELPER()
  EM:Test()
end

-- *** Locals ***

-- *** Event Handlers ***

function EM:OnEvent(_, event, ...)
  if self.EventHandlers[event] then
		self.EventHandlers[event](self, ...)
	end
end

function EM.EventHandlers.ADDON_LOADED(self, addonName, ...)
  if (addonName ~= "TollskisHardcoreHelper") then return end
end

function EM.EventHandlers.COMBAT_LOG_EVENT_UNFILTERED(self)

end

function EM.EventHandlers.UNIT_COMBAT(self, unitId, action, ind, dmg, dmgType)
  --print("UNIT_COMBAT: " .. unitId .. ". " .. action .. ". " .. ind .. ". " .. dmg .. ". " .. dmgType)
end

local healthStatus = {}

function EM.EventHandlers.UNIT_HEALTH(self, unitId)
  --print("UNIT_HEALTH: " .. unitId)

  local updateIsForPlayer = unitId == "player"
  local updateIsForParty = unitId:match("party")
  if (not updateIsForPlayer and not updateIsForParty) then return end

  local health = UnitHealth(unitId)
  local maxHealth = UnitHealthMax(unitId)

  local healthPercentage = health / maxHealth

  local newHealthStatus = nil
  if (healthPercentage <= 0.30) then
    newHealthStatus = 1 -- red
  elseif (healthPercentage <= 0.50) then
    newHealthStatus = 2 -- orange
  elseif (healthPercentage <= 0.70) then
    newHealthStatus = 3 -- yellow
  else
    newHealthStatus = 4 -- green
  end

  local oldHealthStatus = healthStatus[unitId]
  if (newHealthStatus == oldHealthStatus) then return end

  local r = nil
  local g = nil
  local b = nil
  if (updateIsForParty) then
    r = 0.667
    g = 0.671
    b = 0.996
  end

  local prefix = "You have "
  if (updateIsForParty) then
    local unitName = UnitName(unitId)
    prefix = unitName .. " has "
  end

  if (newHealthStatus == 1) then
    if (r == nil or g == nil or b == nill) then
      r = 1.000
      g = 0.059
      b = 0.059
    end

    UIErrorsFrame:AddMessage(prefix .. "critically low health!", r, g, b)
    if (updateIsForPlayer) then
      self:PlaySound("alert2")
      if (UnitInParty("player")) then SendChatMessage(string.format("Help, my health is at %d%%!", healthPercentage * 100), "PARTY") end
    end
  elseif (newHealthStatus == 2 and (oldHealthStatus == nil or oldHealthStatus > newHealthStatus)) then
    if (r == nil or g == nil or b == nill) then
      r = 1.000
      g = 0.404
      b = 0.000
    end

    UIErrorsFrame:AddMessage(prefix .. "low health!", r, g, b)
    if (updateIsForPlayer) then self:PlaySound("alert3") end
  end

  healthStatus[unitId] = newHealthStatus
end

function EM.EventHandlers.UNIT_TARGET(self, unitId)
  --print("UNIT_TARGET: " .. unitId)
end

GameTooltip:HookScript("OnTooltipSetUnit", function(self)
	
end)

-- Register each event for which we have an event handler.
EM.Frame = CreateFrame("Frame")
for eventName,_ in pairs(EM.EventHandlers) do
	  EM.Frame:RegisterEvent(eventName)
end
EM.Frame:SetScript("OnEvent", function(_, event, ...) EM:OnEvent(_, event, ...) end)

function EM:PlaySound(soundFile)
  local normalEnableDialog = GetCVar("Sound_EnableDialog")
  local normalDialogVolume = GetCVar("Sound_DialogVolume")
  SetCVar("Sound_EnableDialog", 1)
  SetCVar("Sound_DialogVolume", 1)

  PlaySoundFile("Interface\\AddOns\\TollskisHardcoreHelper\\resources\\" .. soundFile .. ".mp3", "Dialog")

  C_Timer.After(1, function()
    SetCVar("Sound_EnableDialog", normalEnableDialog)
    SetCVar("Sound_DialogVolume", normalDialogVolume)
  end)
end

function EM:Test()
  print("[THH] Test")
  local text = UIParent:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  text:SetPoint("CENTER")
  text:SetText("Hello World")
end