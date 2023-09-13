TollskisHardcoreHelper_ConnectionChecker = {
  PlayerConnectionInfo = {}, --<guid, { IsDisconnected: boolen, LastMessageTimestamp: int }>
}

local CC = TollskisHardcoreHelper_ConnectionChecker

local groupUnitIds = { "player" }
for i = 1, 40 do
  if i <= 4 then
    groupUnitIds[#groupUnitIds + 1] = "party" .. i
  end
  groupUnitIds[#groupUnitIds + 1] = "raid" .. i
end

function CC:CheckGroupConnectionsInterval()
  for i = 1, #groupUnitIds do
    local guid = UnitGUID(groupUnitIds[i])
    if (guid and
        UnitIsConnected(groupUnitIds[i]) and
        self.PlayerConnectionInfo[guid] and
        GetTime() - self.PlayerConnectionInfo[guid].LastMessageTimestamp > 10 and
        not self.PlayerConnectionInfo[guid].IsDisconnected) then
      TollskisHardcoreHelper_EventManager:SendMessageToGroup(ThhEnum.AddonMessageType.PlayerDisconnected, guid)
      local msg = TollskisHardcoreHelper_EventManager:ConvertAddonMessageToNotification("ABCADSFASD", ThhEnum.AddonMessageType.PlayerDisconnected, guid)
      UIErrorsFrame:AddMessage(msg, 1.000, 1.000, 1.000)
      self.PlayerConnectionInfo[guid].IsDisconnected = true
    end
  end

  C_Timer.After(5, function()
    CC:CheckGroupConnectionsInterval()
  end)
end

function CC:SendHeartbeatInterval()
  local guid = UnitGUID("player")
  if (not self.PlayerConnectionInfo[guid] or GetTime() - self.PlayerConnectionInfo[guid].LastMessageTimestamp >= 2) then
    TollskisHardcoreHelper_EventManager:SendMessageToGroup(ThhEnum.AddonMessageType.Heartbeat)
  end
  
  C_Timer.After(7, function()
    CC:SendHeartbeatInterval()
  end)
end