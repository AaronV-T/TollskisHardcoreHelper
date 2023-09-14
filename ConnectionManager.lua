TollskisHardcoreHelper_ConnectionManager = {
  PlayerConnectionInfo = {}, --<guid, { IsDisconnected: boolen, LastMessageTimestamp: int }>
}

local CM = TollskisHardcoreHelper_ConnectionManager

local groupUnitIds = { "player" }
for i = 1, 40 do
  if i <= 4 then
    groupUnitIds[#groupUnitIds + 1] = "party" .. i
  end
  groupUnitIds[#groupUnitIds + 1] = "raid" .. i
end

function CM:CheckGroupConnectionsInterval()
  for i = 1, #groupUnitIds do
    local guid = UnitGUID(groupUnitIds[i])
    if (guid and
        UnitIsConnected(groupUnitIds[i]) and
        self.PlayerConnectionInfo[guid] and
        GetTime() - self.PlayerConnectionInfo[guid].LastMessageTimestamp > 10 and
        not self.PlayerConnectionInfo[guid].IsDisconnected) then
      TollskisHardcoreHelper_MessageManager:SendMessageToGroup(ThhEnum.AddonMessageType.PlayerDisconnected, guid)
      TollskisHardcoreHelper_NotificationManager:ShowNotificationToPlayer(UnitName("player"), ThhEnum.NotificationType.PlayerDisconnected, guid)
    end
  end

  C_Timer.After(5, function()
    CM:CheckGroupConnectionsInterval()
  end)
end

function CM:SendHeartbeatInterval()
  local guid = UnitGUID("player")
  if (not self.PlayerConnectionInfo[guid] or GetTime() - self.PlayerConnectionInfo[guid].LastMessageTimestamp >= 2) then
    TollskisHardcoreHelper_MessageManager:SendMessageToGroup(ThhEnum.AddonMessageType.Heartbeat)
  end
  
  C_Timer.After(7, function()
    CM:SendHeartbeatInterval()
  end)
end