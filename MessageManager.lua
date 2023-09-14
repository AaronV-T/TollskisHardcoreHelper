TollskisHardcoreHelper_MessageManager = {
  AddonMessagePrefix = "TsHardcoreHelper",
  SentMessageTimestamps = {},
}

local MM = TollskisHardcoreHelper_MessageManager

function MM:OnChatMessageAddonEvent(prefix, text, channel, sender, target, zoneChannelID, localID, name, instanceID)
  if (prefix ~= self.AddonMessagePrefix) then return end
  --print("CHAT_MSG_ADDON. " .. tostring(prefix) ..  ", " .. tostring(text) ..  ", " .. tostring(channel) ..  ", " .. tostring(sender) ..  ", " .. tostring(target) ..  ", " .. tostring(zoneChannelID) ..  ", " .. tostring(localID) ..  ", " .. tostring(name) ..  ", " .. tostring(instanceID) ..  ".")

  local senderPlayer, senderRealm = strsplit("-", sender, 2)
  local senderUnitId, senderGuid = UnitHelperFunctions.FindUnitIdAndGuidByUnitName(senderPlayer)
  --print("Sender: " .. tostring(senderUnitId) .. ", " .. tostring(senderGuid))

  if (not TollskisHardcoreHelper_ConnectionManager.PlayerConnectionInfo[senderGuid]) then
    TollskisHardcoreHelper_ConnectionManager.PlayerConnectionInfo[senderGuid] = {
      IsDisconnected = false,
      LastMessageTimestamp = GetTime(),
    }
  else
    if (TollskisHardcoreHelper_ConnectionManager.PlayerConnectionInfo[senderGuid].IsDisconnected) then
      local reconnectingPlayerUnitId = UnitHelperFunctions.FindUnitIdByUnitGuid(senderGuid)
      local reconnectingPlayerName = UnitName(reconnectingPlayerUnitId)
      UIErrorsFrame:AddMessage(string.format("%s has reconnected.", reconnectingPlayerName), 1.000, 1.000, 1.000)
    end

    TollskisHardcoreHelper_ConnectionManager.PlayerConnectionInfo[senderGuid].IsDisconnected = false
    TollskisHardcoreHelper_ConnectionManager.PlayerConnectionInfo[senderGuid].LastMessageTimestamp = GetTime()
  end
  
  if(senderUnitId == "player") then return end

  local addonMessageType, arg1 = strsplit("|", text, 2)
  addonMessageType = tonumber(addonMessageType)

  local notification = TollskisHardcoreHelper_EventManager:ConvertAddonMessageToNotification(senderPlayer, addonMessageType, arg1)
  if (notification) then
    local r = 1.000
    local g = 1.000
    local b = 1.000
    UIErrorsFrame:AddMessage(notification, r, g, b)
  end
end

function MM:SendMessageToGroup(addonMessageType, arg1)
  local addonMessage = addonMessageType
  if (arg1 ~= nil) then addonMessage = addonMessage .. "|" .. arg1 end

  local nowTimestamp = GetTime()
  if (self.SentMessageTimestamps[addonMessage] and nowTimestamp - self.SentMessageTimestamps[addonMessage] < 1) then return end
  self.SentMessageTimestamps[addonMessage] = nowTimestamp

  local addonMessageChatType = "WHISPER"
  if (UnitInParty("player")) then
    local chatMessage = self:ConvertAddonMessageToChatMessage(addonMessageType, arg1)
    if (chatMessage) then SendChatMessage("[THH] " .. chatMessage, "PARTY") end
    addonMessageChatType = "PARTY"
  end
  if (UnitInRaid("player")) then
    addonMessageChatType = "RAID"
  end

  if (not addonMessageChatType) then return end

  local target = nil
  if (addonMessageChatType == "WHISPER") then target = UnitName("player") end
  C_ChatInfo.SendAddonMessage(MM.AddonMessagePrefix, addonMessage, addonMessageChatType, target)
end

--

function MM:ConvertAddonMessageToChatMessage(addonMessageType, arg1)
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