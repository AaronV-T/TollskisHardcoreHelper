TollskisHardcoreHelper_MessageManager = {
  AddonMessagePrefix = "TsHardcoreHelper",
  SentMessageTimestamps = {},
}

local MM = TollskisHardcoreHelper_MessageManager

function MM:OnChatMessageAddonEvent(prefix, text, channel, sender, target, zoneChannelID, localID, name, instanceID)
  if (prefix ~= self.AddonMessagePrefix) then return end
  --print("CHAT_MSG_ADDON. " .. tostring(prefix) ..  ", " .. tostring(text) ..  ", " .. tostring(channel) ..  ", " .. tostring(sender) ..  ", " .. tostring(target) ..  ", " .. tostring(zoneChannelID) ..  ", " .. tostring(localID) ..  ", " .. tostring(name) ..  ", " .. tostring(instanceID) ..  ".")

  if (channel ~= "WHISPER" and channel ~= "PARTY" and channel ~= "RAID") then return end

  local senderPlayer, senderRealm = strsplit("-", sender, 2)
  local senderUnitId, senderGuid = UnitHelperFunctions.FindUnitIdAndGuidByUnitName(senderPlayer)
  --print("Sender: " .. tostring(senderUnitId) .. ", " .. tostring(senderGuid))

  if (not TollskisHardcoreHelper_PlayerStates[senderGuid]) then
    local connectionInfo = ConnectionInfo.New(false, GetTime())
    TollskisHardcoreHelper_PlayerStates[senderGuid] = PlayerState.New(connectionInfo, nil)
  else
    if (TollskisHardcoreHelper_PlayerStates[senderGuid].ConnectionInfo.IsDisconnected) then
      TollskisHardcoreHelper_NotificationManager:ShowNotificationToPlayer(UnitName("player"), ThhEnum.NotificationType.PlayerReconnected, senderGuid)
    end

    TollskisHardcoreHelper_PlayerStates[senderGuid].ConnectionInfo.IsDisconnected = false
    TollskisHardcoreHelper_PlayerStates[senderGuid].ConnectionInfo.LastMessageTimestamp = GetTime()
  end

  local addonMessageType, arg1 = strsplit("!", text, 2)
  addonMessageType = tonumber(addonMessageType)
  if (arg1 ~= nil) then arg1 = tonumber(arg1) end

  if (addonMessageType == ThhEnum.AddonMessageType.Heartbeat) then
    TollskisHardcoreHelper_PlayerStates[senderGuid].IsInCombat = TollskisHardcoreHelper_HelperFunctions.NumberToBool(arg1)
  elseif (addonMessageType == ThhEnum.AddonMessageType.EnteredCombat) then
    TollskisHardcoreHelper_PlayerStates[senderGuid].IsInCombat = true
  elseif (addonMessageType == ThhEnum.AddonMessageType.ExitedCombat) then
    TollskisHardcoreHelper_PlayerStates[senderGuid].IsInCombat = false
  elseif (addonMessageType == ThhEnum.AddonMessageType.PlayerDisconnected and TollskisHardcoreHelper_PlayerStates[arg1]) then
    TollskisHardcoreHelper_PlayerStates[arg1].ConnectionInfo.IsDisconnected = true
  end

  TollskisHardcoreHelper_RaidFramesManager:UpdateRaidFrames()
  
  if(senderUnitId == "player" or UnitInRaid("player")) then return end

  local notificationType = TollskisHardcoreHelper_NotificationManager:ConvertAddonMessageTypeToNotificationType(addonMessageType)
  if (notificationType) then
    TollskisHardcoreHelper_NotificationManager:ShowNotificationToPlayer(senderPlayer, notificationType, arg1)
  end
end

function MM:SendMessageToGroup(addonMessageType, arg1)
  local addonMessage = addonMessageType
  if (arg1 ~= nil) then
    addonMessage = string.format("%d!%d", addonMessageType, arg1)
  end

  local nowTimestamp = GetTime()
  if (self.SentMessageTimestamps[addonMessage] and nowTimestamp - self.SentMessageTimestamps[addonMessage] < 1) then return end
  self.SentMessageTimestamps[addonMessage] = nowTimestamp

  local addonMessageChatType = "WHISPER"
  if (UnitInParty("player") or UnitInRaid("player")) then
    local chatMessage = self:ConvertAddonMessageToChatMessage(addonMessageType, arg1)
    if (chatMessage) then SendChatMessage("[THH] " .. chatMessage, "PARTY") end
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
    return string.format("Help, my health is at %d%%!", arg1)
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