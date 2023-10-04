TollskisHardcoreHelper_MessageManager = {
  AddonMessagePrefix = "TsHardcoreHelper",
  SentMessageTimestamps = {},
}

local MM = TollskisHardcoreHelper_MessageManager

function MM:OnChatMessageAddonEvent(prefix, text, channel, sender, target, zoneChannelID, localID, name, instanceID)
  if (prefix ~= self.AddonMessagePrefix) then return end
  --print("OnChatMessageAddonEvent. " .. tostring(prefix) ..  ", " .. tostring(text) ..  ", " .. tostring(channel) ..  ", " .. tostring(sender) ..  ", " .. tostring(target) ..  ", " .. tostring(zoneChannelID) ..  ", " .. tostring(localID) ..  ", " .. tostring(name) ..  ", " .. tostring(instanceID) ..  ".")
  --print(string.format("%d - ReceivedMessage: %s, %s", time(), text,  sender))
  table.insert(TollskisHardcoreHelper_EventManager.DebugLogs, string.format("%d - ReceivedMessage: %s, %s", time(), text,  sender))

  if (channel ~= "WHISPER" and channel ~= "PARTY" and channel ~= "RAID") then return end

  local senderPlayer, senderRealm = strsplit("-", sender, 2)
  local senderUnitId, senderGuid = UnitHelperFunctions.FindUnitIdAndGuidByUnitName(senderPlayer)

  if (not senderUnitId or not senderGuid) then
    table.insert(TollskisHardcoreHelper_EventManager.DebugLogs, string.format("%d - Failed to find UnitId or Guid for message sender: %s", time(), senderPlayer))
    return
  end

  local shouldUpdateRaidFrames = false
  if (not TollskisHardcoreHelper_PlayerStates[senderGuid]) then
    local connectionInfo = ConnectionInfo.New(true, GetTime())
    TollskisHardcoreHelper_PlayerStates[senderGuid] = PlayerState.New(connectionInfo, nil)
    shouldUpdateRaidFrames = true
  elseif (not TollskisHardcoreHelper_PlayerStates[senderGuid].ConnectionInfo) then
    TollskisHardcoreHelper_PlayerStates[senderGuid].ConnectionInfo = ConnectionInfo.New(true, GetTime())
    shouldUpdateRaidFrames = true
  else
    if (not TollskisHardcoreHelper_PlayerStates[senderGuid].ConnectionInfo.IsConnected) then
      TollskisHardcoreHelper_NotificationManager:ShowNotificationToPlayer(UnitName("player"), ThhEnum.NotificationType.PlayerReconnected, senderGuid)
      shouldUpdateRaidFrames = true

      if (senderUnitId == "player") then -- If the player was disconnected, act like all other players in the group had been connected the whole time.
        for k,v in pairs(TollskisHardcoreHelper_PlayerStates) do
          if (v.ConnectionInfo) then
            v.ConnectionInfo.LastMessageTimestamp = GetTime()
          end
        end
      end
    end

    TollskisHardcoreHelper_PlayerStates[senderGuid].ConnectionInfo.IsConnected = true
    TollskisHardcoreHelper_PlayerStates[senderGuid].ConnectionInfo.LastMessageTimestamp = GetTime()
  end

  local addonMessageType, arg1 = strsplit("!", text, 2)
  addonMessageType = tonumber(addonMessageType)

  if (addonMessageType == ThhEnum.AddonMessageType.Heartbeat) then
    local isInCombat = TollskisHardcoreHelper_HelperFunctions.NumberToBool(tonumber(arg1))
    shouldUpdateRaidFrames = shouldUpdateRaidFrames or TollskisHardcoreHelper_PlayerStates[senderGuid].IsInCombat ~= isInCombat
    TollskisHardcoreHelper_PlayerStates[senderGuid].IsInCombat = isInCombat
  elseif (addonMessageType == ThhEnum.AddonMessageType.EnteredCombat) then
    shouldUpdateRaidFrames = shouldUpdateRaidFrames or TollskisHardcoreHelper_PlayerStates[senderGuid].IsInCombat ~= true
    TollskisHardcoreHelper_PlayerStates[senderGuid].IsInCombat = true
  elseif (addonMessageType == ThhEnum.AddonMessageType.ExitedCombat) then
    shouldUpdateRaidFrames = shouldUpdateRaidFrames or TollskisHardcoreHelper_PlayerStates[senderGuid].IsInCombat ~= false
    TollskisHardcoreHelper_PlayerStates[senderGuid].IsInCombat = false
  elseif (addonMessageType == ThhEnum.AddonMessageType.PlayerConnectionCheck) then
    if (arg1 == UnitGUID("player")) then
      self:SendHeartbeatMessage()
    end

    C_Timer.After(1, function()
      TollskisHardcoreHelper_IntervalManager:CheckPlayerConnectionAndMarkIfDisconnected(arg1)
    end)
  end

  if (shouldUpdateRaidFrames) then
    TollskisHardcoreHelper_RaidFramesManager:UpdateRaidFrames()
  end
  
  if(senderUnitId == "player" or UnitInRaid("player")) then return end

  local notificationType = TollskisHardcoreHelper_NotificationManager:ConvertAddonMessageTypeToNotificationType(addonMessageType)
  if (notificationType) then
    TollskisHardcoreHelper_NotificationManager:ShowNotificationToPlayer(senderPlayer, notificationType, arg1)
  end
end

function MM:SendMessageToGroup(addonMessageType, arg1)
  local addonMessage = tostring(addonMessageType)
  if (arg1 ~= nil) then
    addonMessage = string.format("%s!%s", addonMessageType, arg1)
  end

  local nowTimestamp = GetTime()
  if (self.SentMessageTimestamps[addonMessage] and nowTimestamp - self.SentMessageTimestamps[addonMessage] < 1) then return end
  self.SentMessageTimestamps[addonMessage] = nowTimestamp

  local addonMessageChatType = "WHISPER"
  if (UnitInParty("player") or UnitInRaid("player")) then
    if (TollskisHardcoreHelper_Settings.Options.EnableChatMessages) then
      local chatMessage = self:ConvertAddonMessageToChatMessage(addonMessageType, arg1)
      if (chatMessage) then SendChatMessage("[THH] " .. chatMessage, "PARTY") end
    end

    addonMessageChatType = "RAID"
  end

  local target = nil
  if (addonMessageChatType == "WHISPER") then target = UnitName("player") end

  --print(string.format("%d - SendMessage: %s", time(), addonMessage))
  table.insert(TollskisHardcoreHelper_EventManager.DebugLogs, string.format("%d - SendMessage: %s", time(), addonMessage))

  -- Note: I tried using ChatThrottleLib but messages were more likely to not be sent. I tested C_ChatInfo.SendAddonMessage with many messages and have found that 
  -- if messages are sent too quickly then they won't be sent, but the player won't be disconnected.
  C_ChatInfo.SendAddonMessage(MM.AddonMessagePrefix, addonMessage, addonMessageChatType, target)
end

--

function MM:ConvertAddonMessageToChatMessage(addonMessageType, arg1)
  if (addonMessageType == ThhEnum.AddonMessageType.LoggingOut and TollskisHardcoreHelper_Settings.Options.EnableChatMessagesLogout) then
    return "I am logging out."
  end
  if (addonMessageType == ThhEnum.AddonMessageType.LogoutCancelled and TollskisHardcoreHelper_Settings.Options.EnableChatMessagesLogout) then
    return "I have stopped logging out."
  end
  if (addonMessageType == ThhEnum.AddonMessageType.HealthCriticallyLow and TollskisHardcoreHelper_Settings.Options.EnableChatMessagesLowHealth) then
    return string.format("Help, my health is at %d%%!", arg1)
  end
  if (addonMessageType == ThhEnum.AddonMessageType.SpellCastStarted and TollskisHardcoreHelper_Settings.Options.EnableChatMessagesSpellCasts) then
    return string.format("I am casting %s.", arg1)
  end
  if (addonMessageType == ThhEnum.AddonMessageType.SpellCastInterrupted and TollskisHardcoreHelper_Settings.Options.EnableChatMessagesSpellCasts) then
    return string.format("My %s cast has been stopped.", arg1)
  end

  return nil
end

function MM:SendHeartbeatMessage()
  self:SendMessageToGroup(ThhEnum.AddonMessageType.Heartbeat, TollskisHardcoreHelper_HelperFunctions.BoolToNumber(UnitAffectingCombat("player")))
end