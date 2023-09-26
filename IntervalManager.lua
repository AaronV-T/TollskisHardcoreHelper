TollskisHardcoreHelper_IntervalManager = {}

local IM = TollskisHardcoreHelper_IntervalManager

local groupUnitIds = { "player" }
for i = 1, 40 do
  if i <= 4 then
    groupUnitIds[#groupUnitIds + 1] = "party" .. i
  end
  groupUnitIds[#groupUnitIds + 1] = "raid" .. i
end

function IM:CheckCombatInterval()
  local shouldUpdateRaidFrames = false
  for i = 1, #groupUnitIds do
    local guid = UnitGUID(groupUnitIds[i])
    if (guid and
        (not TollskisHardcoreHelper_PlayerStates[guid] or
        not TollskisHardcoreHelper_PlayerStates[guid].ConnectionInfo or
        not TollskisHardcoreHelper_PlayerStates[guid].ConnectionInfo.IsConnected)) then
      local isInCombat = UnitAffectingCombat(groupUnitIds[i])
      if (not TollskisHardcoreHelper_PlayerStates[guid]) then
        TollskisHardcoreHelper_PlayerStates[guid] = PlayerState.New(nil, isInCombat)
      else
        if (isInCombat ~= TollskisHardcoreHelper_PlayerStates[guid].IsInCombat) then
          shouldUpdateRaidFrames = true

          if (isInCombat) then
            TollskisHardcoreHelper_NotificationManager:ShowNotificationToPlayer(UnitName(groupUnitIds[i]), ThhEnum.NotificationType.EnteredCombat)
          end
        end

        TollskisHardcoreHelper_PlayerStates[guid].IsInCombat = isInCombat
      end
    end
	end

  if (shouldUpdateRaidFrames) then
    TollskisHardcoreHelper_RaidFramesManager:UpdateRaidFrames()
  end
  
  C_Timer.After(5, function()
    IM:CheckCombatInterval()
  end)
end

function IM:CheckGroupConnectionsInterval()
  for i = 1, #groupUnitIds do
    local guid = UnitGUID(groupUnitIds[i])
    if (guid and
        UnitIsConnected(groupUnitIds[i]) and
        TollskisHardcoreHelper_PlayerStates[guid] and
        TollskisHardcoreHelper_PlayerStates[guid].ConnectionInfo and
        GetTime() - TollskisHardcoreHelper_PlayerStates[guid].ConnectionInfo.LastMessageTimestamp > 10 and
        TollskisHardcoreHelper_PlayerStates[guid].ConnectionInfo.IsConnected == true) then
      TollskisHardcoreHelper_PlayerStates[guid].ConnectionInfo.IsConnected = false
      TollskisHardcoreHelper_MessageManager:SendMessageToGroup(ThhEnum.AddonMessageType.PlayerDisconnected, guid)
      TollskisHardcoreHelper_NotificationManager:ShowNotificationToPlayer(UnitName("player"), ThhEnum.NotificationType.PlayerDisconnected, guid)
    end
  end

  C_Timer.After(5, function()
    IM:CheckGroupConnectionsInterval()
  end)
end

function IM:SendHeartbeatInterval()
  local guid = UnitGUID("player")
  if (not TollskisHardcoreHelper_PlayerStates[guid] or
      not TollskisHardcoreHelper_PlayerStates[guid].ConnectionInfo or
      GetTime() - TollskisHardcoreHelper_PlayerStates[guid].ConnectionInfo.LastMessageTimestamp >= 2) then
    TollskisHardcoreHelper_MessageManager:SendMessageToGroup(ThhEnum.AddonMessageType.Heartbeat, TollskisHardcoreHelper_HelperFunctions.BoolToNumber(UnitAffectingCombat("player")))
  end
  
  C_Timer.After(7, function()
    IM:SendHeartbeatInterval()
  end)
end