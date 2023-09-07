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

-- function EM.EventHandlers.PLAYER_LEAVING_WORLD(self)
--   print("PLAYER_LEAVING_WORLD")
-- end

-- function EM.EventHandlers.PLAYER_LOGOUT(self)
--   print("PLAYER_LOGOUT")
-- end

-- function EM.EventHandlers.PLAYER_QUITING(self)
--   print("PLAYER_QUITING")
-- end

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
      if (UnitInParty("player")) then SendChatMessage(string.format("[THH] Help, my health is at %d%%!", healthPercentage * 100), "PARTY") end
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

local SpellsToNotifyOnCastStart = {
  [8690] = true, -- Hearthstone
}

local SpellsToNotifyOnCastSucceeded = {
  [498] = true, -- Divine Protection 1
  [642] = true, -- Divine Shield 1
  [1020] = true, -- Divine Shield 2
  [1022] = true, -- Blessing of Protection 1
  [5573] = true, -- Divine Protection 2
  [5599] = true, -- Blessing of Protection 2
  [10278] = true, -- Blessing of Protection 3
  [19752] = true, -- Divine Intervention
}

function EM.EventHandlers.UNIT_SPELLCAST_CHANNEL_START(self, unitId, castId, spellId)
  if (unitId ~= "player") then return end
  print("UNIT_SPELLCAST_CHANNEL_START. " .. tostring(unitId) .. ", " .. tostring(castId) .. ", " .. tostring(spellId))

  if (SpellsToNotifyOnCastStart[spellId]) then
    local spellName, spellRank, spellIcon, spellCastTime, spellMinRange, spellMaxRange = GetSpellInfo(spellId)
    if (UnitInParty("player")) then SendChatMessage("[THH] I am casting " .. spellName .. ".", "PARTY") end
  end
end

function EM.EventHandlers.UNIT_SPELLCAST_CHANNEL_STOP(self, unitId, castId, spellId)
  if (unitId ~= "player") then return end
  print("UNIT_SPELLCAST_CHANNEL_STOP. " .. tostring(unitId) .. ", " .. tostring(castId) .. ", " .. tostring(spellId))
  
  if (SpellsToNotifyOnCastStart[spellId]) then
    local spellName, spellRank, spellIcon, spellCastTime, spellMinRange, spellMaxRange = GetSpellInfo(spellId)
    if (UnitInParty("player")) then SendChatMessage("[THH] I have stopped casting " .. spellName .. ".", "PARTY") end
  end
end

-- function EM.EventHandlers.UNIT_SPELLCAST_FAILED(self, unitId, arg2, arg3, arg4, arg5)
--   if (unitId ~= "player") then return end
--   --print("UNIT_SPELLCAST_FAILED. " .. unitId .. ", " .. tostring(arg2) .. ", " .. tostring(arg3) .. ", " .. tostring(arg4) .. ", " .. tostring(arg5))
-- end

-- function EM.EventHandlers.UNIT_SPELLCAST_FAILED_QUIET(self, unitId, arg2, arg3, arg4, arg5)
--   if (unitId ~= "player") then return end
--   --print("UNIT_SPELLCAST_FAILED_QUIET. " .. unitId .. ", " .. tostring(arg2) .. ", " .. tostring(arg3) .. ", " .. tostring(arg4) .. ", " .. tostring(arg5))
-- end

-- function EM.EventHandlers.UNIT_SPELLCAST_INTERRUPTED(self, unitId, arg2, arg3, arg4, arg5)
--   if (unitId ~= "player") then return end
--   --print("UNIT_SPELLCAST_INTERRUPTED. " .. unitId .. ", " .. tostring(arg2) .. ", " .. tostring(arg3) .. ", " .. tostring(arg4) .. ", " .. tostring(arg5))
-- end

function EM.EventHandlers.UNIT_SPELLCAST_START(self, unitId, castId, spellId)
  if (unitId ~= "player") then return end
  --print("UNIT_SPELLCAST_START. " .. tostring(unitId) .. ", " .. tostring(castId) .. ", " .. tostring(spellId))

  if (SpellsToNotifyOnCastStart[spellId]) then
    local spellName, spellRank, spellIcon, spellCastTime, spellMinRange, spellMaxRange = GetSpellInfo(spellId)
    if (UnitInParty("player")) then SendChatMessage("[THH] I am casting " .. spellName .. ".", "PARTY") end
  end
end

function EM.EventHandlers.UNIT_SPELLCAST_STOP(self, unitId, castId, spellId)
  if (unitId ~= "player") then return end
  --print("UNIT_SPELLCAST_STOP. " .. tostring(unitId) .. ", " .. tostring(castId) .. ", " .. tostring(spellId))
  
  if (SpellsToNotifyOnCastStart[spellId]) then
    local spellName, spellRank, spellIcon, spellCastTime, spellMinRange, spellMaxRange = GetSpellInfo(spellId)
    if (UnitInParty("player")) then SendChatMessage("[THH] I have stopped casting " .. spellName .. ".", "PARTY") end
  end
end

function EM.EventHandlers.UNIT_SPELLCAST_SUCCEEDED(self, unitId, castId, spellId)
  if (unitId ~= "player") then return end
  --print("UNIT_SPELLCAST_SUCCEEDED. " .. tostring(unitId) .. ", " .. tostring(castId) .. ", " .. tostring(spellId))

  if (SpellsToNotifyOnCastSucceeded[spellId]) then
    local spellName, spellRank, spellIcon, spellCastTime, spellMinRange, spellMaxRange = GetSpellInfo(spellId)
    if (UnitInParty("player")) then SendChatMessage("[THH] I have cast " .. spellName .. ".", "PARTY") end
  end
end

function EM.EventHandlers.UNIT_TARGET(self, unitId)
  --print("UNIT_TARGET: " .. unitId)
end

hooksecurefunc("CancelLogout", function()
	--print("CancelLogout")

  if (UnitInParty("player")) then SendChatMessage("[THH] I have cancelled logging out.", "PARTY") end
end)

hooksecurefunc("Logout", function()
	--print("Logout")
  if (UnitAffectingCombat("player")) then return end

  if (UnitInParty("player")) then SendChatMessage("[THH] I am logging out.", "PARTY") end
end)

hooksecurefunc("Quit", function()
	--print("Quit")
  if (UnitAffectingCombat("player")) then return end

  if (UnitInParty("player")) then SendChatMessage("[THH] I am logging out.", "PARTY") end
end)

GameTooltip:HookScript("OnTooltipSetUnit", function(self)
	
end)

-- Register each event for which we have an event handler.
EM.Frame = CreateFrame("Frame")
for eventName,_ in pairs(EM.EventHandlers) do
	  EM.Frame:RegisterEvent(eventName)
end
EM.Frame:SetScript("OnEvent", function(_, event, ...) EM:OnEvent(_, event, ...) end)


-- Helper Functions

function EM:GetPlayerRelationship(unitId)
  if (unitId == "player") then
    return ThhEnum.PlayerRelationshipType.Player
  end

  if (unitId:match("party")) then
    return ThhEnum.PlayerRelationshipType.Party
  end

  return ThhEnum.PlayerRelationshipType.None
end

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
