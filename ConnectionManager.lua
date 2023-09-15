TollskisHardcoreHelper_ConnectionManager = {}

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
        TollskisHardcoreHelper_PlayerStates[guid] and
        GetTime() - TollskisHardcoreHelper_PlayerStates[guid].ConnectionInfo.LastMessageTimestamp > 10 and
        TollskisHardcoreHelper_PlayerStates[guid].ConnectionInfo.IsDisconnected == false) then
      TollskisHardcoreHelper_PlayerStates[guid].ConnectionInfo.IsDisconnected = true
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
  if (not TollskisHardcoreHelper_PlayerStates[guid] or GetTime() - TollskisHardcoreHelper_PlayerStates[guid].ConnectionInfo.LastMessageTimestamp >= 2) then
    TollskisHardcoreHelper_MessageManager:SendMessageToGroup(ThhEnum.AddonMessageType.Heartbeat, TollskisHardcoreHelper_HelperFunctions.BoolToNumber(UnitAffectingCombat("player")))
  end
  
  C_Timer.After(7, function()
    CM:SendHeartbeatInterval()
  end)
end