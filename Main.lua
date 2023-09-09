TollskisHardcoreHelper_Settings = nil

TollskisHardcoreHelper_EventManager = {
  EventHandlers = {},
}

local EM = TollskisHardcoreHelper_EventManager
-- local Controller = AutoBiographer_Controller

local addonMessagePrefix = "TsHardcoreHelper"

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

function EM.EventHandlers.CHAT_MSG_ADDON(self, prefix, text, channel, sender, target, zoneChannelID, localID, name, instanceID)
  if (prefix ~= addonMessagePrefix) then return end
  --print("CHAT_MSG_ADDON. " .. tostring(prefix) ..  ", " .. tostring(text) ..  ", " .. tostring(channel) ..  ", " .. tostring(sender) ..  ", " .. tostring(target) ..  ", " .. tostring(zoneChannelID) ..  ", " .. tostring(localID) ..  ", " .. tostring(name) ..  ", " .. tostring(instanceID) ..  ".")

  local senderPlayer, senderRealm = strsplit("-", sender, 2)
  local senderUnitId, senderGuid = UnitHelperFunctions.FindUnitIdAndGuidByUnitName(senderPlayer, senderRealm)
  --print("Sender: " .. tostring(senderUnitId) .. ", " .. tostring(senderGuid))

  if(senderUnitId == "player") then return end

  local addonMessageType, arg1 = strsplit("|", text, 2)
  addonMessageType = tonumber(addonMessageType)

  local notification = self:ConvertAddonMessageToNotification(senderPlayer, addonMessageType, arg1)
  if (notification) then
    local r = 1.000
    local g = 1.000
    local b = 1.000
    UIErrorsFrame:AddMessage(notification, r, g, b)
  end
end

function EM.EventHandlers.COMBAT_LOG_EVENT_UNFILTERED(self)
  local timestamp, event, hideCaster, sourceGuid, sourceName, sourceFlags, sourceRaidFlags, destGuid, destName, destFlags, destRaidflags = CombatLogGetCurrentEventInfo()
  --print("COMBAT_LOG_EVENT_UNFILTERED. " .. tostring(event))
end

function EM.EventHandlers.PLAYER_ENTERING_WORLD(self, isLogin, isReload)
  --print("PLAYER_ENTERING_WORLD. " .. tostring(isLogin) ..  ", " .. tostring(isReload))

  if (isLogin or isReload) then
    C_ChatInfo.RegisterAddonMessagePrefix(addonMessagePrefix)
  end
end

function EM.EventHandlers.PLAYER_REGEN_DISABLED(self)
  --print("PLAYER_REGEN_DISABLED")

  self:SendMessageToGroup(ThhEnum.AddonMessageType.EnteredCombat)
end

function EM.EventHandlers.PLAYER_REGEN_ENABLED(self)
  --print("PLAYER_REGEN_ENABLED")

  self:SendMessageToGroup(ThhEnum.AddonMessageType.ExitedCombat)
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
      self:SendMessageToGroup(ThhEnum.AddonMessageType.HealthCriticallyLow, healthPercentage)
    end
  elseif (newHealthStatus == 2 and (oldHealthStatus == nil or oldHealthStatus > newHealthStatus)) then
    if (r == nil or g == nil or b == nill) then
      r = 1.000
      g = 0.404
      b = 0.000
    end

    UIErrorsFrame:AddMessage(prefix .. "low health!", r, g, b)
    if (updateIsForPlayer) then
      self:PlaySound("alert3")
      self:SendMessageToGroup(ThhEnum.AddonMessageType.HealthLow, healthPercentage)
    end
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
  --print("UNIT_SPELLCAST_CHANNEL_START. " .. tostring(unitId) .. ", " .. tostring(castId) .. ", " .. tostring(spellId))

  if (SpellsToNotifyOnCastStart[spellId]) then
    self:SendMessageToGroup(ThhEnum.AddonMessageType.SpellCastStarted, spellId)
  end
end

function EM.EventHandlers.UNIT_SPELLCAST_CHANNEL_STOP(self, unitId, castId, spellId)
  if (unitId ~= "player") then return end
  --print("UNIT_SPELLCAST_CHANNEL_STOP. " .. tostring(unitId) .. ", " .. tostring(castId) .. ", " .. tostring(spellId))
  
  if (SpellsToNotifyOnCastStart[spellId]) then
    self:SendMessageToGroup(ThhEnum.AddonMessageType.SpellCastInterrupted, spellId)
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

function EM.EventHandlers.UNIT_SPELLCAST_INTERRUPTED(self, unitId, arg2, arg3, arg4, arg5)
  if (unitId ~= "player") then return end
  --print("UNIT_SPELLCAST_INTERRUPTED. " .. unitId .. ", " .. tostring(arg2) .. ", " .. tostring(arg3) .. ", " .. tostring(arg4) .. ", " .. tostring(arg5))

  if (SpellsToNotifyOnCastStart[spellId]) then
    self:SendMessageToGroup(ThhEnum.AddonMessageType.SpellCastInterrupted, spellId)
  end
end

function EM.EventHandlers.UNIT_SPELLCAST_START(self, unitId, castId, spellId)
  if (unitId ~= "player") then return end
  --print("UNIT_SPELLCAST_START. " .. tostring(unitId) .. ", " .. tostring(castId) .. ", " .. tostring(spellId))

  if (SpellsToNotifyOnCastStart[spellId]) then
    self:SendMessageToGroup(ThhEnum.AddonMessageType.SpellCastStarted, spellId)
  end
end

-- function EM.EventHandlers.UNIT_SPELLCAST_STOP(self, unitId, castId, spellId)
--   if (unitId ~= "player") then return end
--   --print("UNIT_SPELLCAST_STOP. " .. tostring(unitId) .. ", " .. tostring(castId) .. ", " .. tostring(spellId))
-- end

function EM.EventHandlers.UNIT_SPELLCAST_SUCCEEDED(self, unitId, castId, spellId)
  if (unitId ~= "player") then return end
  --print("UNIT_SPELLCAST_SUCCEEDED. " .. tostring(unitId) .. ", " .. tostring(castId) .. ", " .. tostring(spellId))

  if (SpellsToNotifyOnCastSucceeded[spellId]) then
    self:SendMessageToGroup(ThhEnum.AddonMessageType.SpellCastSucceeded, spellId)
  end
end

function EM.EventHandlers.UNIT_TARGET(self, unitId)
  --print("UNIT_TARGET: " .. unitId)
end

hooksecurefunc("CancelLogout", function()
	--print("CancelLogout")

  EM:SendMessageToGroup(ThhEnum.AddonMessageType.LogoutCancelled)
end)

hooksecurefunc("Logout", function()
	--print("Logout")
  if (UnitAffectingCombat("player")) then return end

  EM:SendMessageToGroup(ThhEnum.AddonMessageType.LoggingOut)
end)

hooksecurefunc("Quit", function()
	--print("Quit")
  if (UnitAffectingCombat("player")) then return end

  EM:SendMessageToGroup(ThhEnum.AddonMessageType.LoggingOut)
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

-- function EM:GetPlayerRelationship(unitId)
--   if (unitId == "player") then
--     return ThhEnum.PlayerRelationshipType.Player
--   end

--   if (unitId:match("party")) then
--     return ThhEnum.PlayerRelationshipType.Party
--   end

--   return ThhEnum.PlayerRelationshipType.None
-- end

function EM:ConvertAddonMessageToChatMessage(addonMessageType, arg1)
  if (addonMessageType == ThhEnum.AddonMessageType.LoggingOut) then
    return "I am logging out."
  end
  if (addonMessageType == ThhEnum.AddonMessageType.LogoutCancelled) then
    return "I have stopped logging out."
  end
  if (addonMessageType == ThhEnum.AddonMessageType.HealthCriticallyLow) then
    return string.format("Help, my health is at %d%%!", arg1 * 100)
  end
  if (addonMessageType == ThhEnum.AddonMessageType.SpellCastStarted) then
    local spellName, spellRank, spellIcon, spellCastTime, spellMinRange, spellMaxRange = GetSpellInfo(arg1)
    return string.format("I am casting %s.", spellName)
  end
  if (addonMessageType == ThhEnum.AddonMessageType.SpellCastInterrupted) then
    local spellName, spellRank, spellIcon, spellCastTime, spellMinRange, spellMaxRange = GetSpellInfo(arg1)
    return string.format("My %s cast has been stopped.", spellName)
  end
  if (addonMessageType == ThhEnum.AddonMessageType.SpellCastSucceeded) then
    local spellName, spellRank, spellIcon, spellCastTime, spellMinRange, spellMaxRange = GetSpellInfo(arg1)
    return string.format("I cast %s.", spellName)
  end

  return nil
end

function EM:ConvertAddonMessageToNotification(playerName, addonMessageType, arg1)
  if (addonMessageType == ThhEnum.AddonMessageType.EnteredCombat) then
    return string.format("%s entered combat.", playerName)
  end
  if (addonMessageType == ThhEnum.AddonMessageType.LoggingOut) then
    return string.format("%s is logging out.", playerName)
  end
  if (addonMessageType == ThhEnum.AddonMessageType.LogoutCancelled) then
    return string.format("%s has stopped logging out.", playerName)
  end
  if (addonMessageType == ThhEnum.AddonMessageType.HealthCriticallyLow) then
    return string.format("%s's health is critically low.", playerName)
  end
  if (addonMessageType == ThhEnum.AddonMessageType.SpellCastStarted) then
    local spellName, spellRank, spellIcon, spellCastTime, spellMinRange, spellMaxRange = GetSpellInfo(arg1)
    return string.format("%s is casting %s.", playerName, spellName)
  end
  if (addonMessageType == ThhEnum.AddonMessageType.SpellCastInterrupted) then
    local spellName, spellRank, spellIcon, spellCastTime, spellMinRange, spellMaxRange = GetSpellInfo(arg1)
    return string.format("%s's %s cast has been stopped.", playerName, spellName)
  end
  if (addonMessageType == ThhEnum.AddonMessageType.SpellCastSucceeded) then
    local spellName, spellRank, spellIcon, spellCastTime, spellMinRange, spellMaxRange = GetSpellInfo(arg1)
    return string.format("%s cast %s.", playerName, spellName)
  end

  return nil
end

local sentMessageTimestamps = {}

function EM:SendMessageToGroup(addonMessageType, arg1)
  local addonMessage = addonMessageType
  if (arg1 ~= nil) then addonMessage = addonMessage .. "|" .. arg1 end

  local nowTimestamp = GetTime()
  if (sentMessageTimestamps[addonMessage] and nowTimestamp - sentMessageTimestamps[addonMessage] < 1) then return end
  sentMessageTimestamps[addonMessage] = nowTimestamp

  local addonMessageChatType = nil
  if (UnitInParty("player")) then
    local chatMessage = self:ConvertAddonMessageToChatMessage(addonMessageType, arg1)
    if (chatMessage) then SendChatMessage("[THH] " .. chatMessage, "PARTY") end
    addonMessageChatType = "PARTY"
  end
  if (UnitInRaid("player")) then
    addonMessageChatType = "RAID"
  end

  if (not addonMessageChatType) then return end

  C_ChatInfo.SendAddonMessage(addonMessagePrefix, addonMessage, addonMessageChatType)
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
  -- local text = UIParent:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  -- text:SetPoint("CENTER")
  -- text:SetText("Hello World")

  C_ChatInfo.SendAddonMessage(addonMessagePrefix, "Test message!", "PARTY")
end
