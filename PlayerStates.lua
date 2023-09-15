TollskisHardcoreHelper_PlayerStates = {} --<guid, PlayerState>

PlayerState = {}
function PlayerState.New(connectionInfo, isInCombat)
  return {
    ConnectionInfo = connectionInfo,
    IsInCombat = isInCombat,
  }
end

ConnectionInfo = {}
function ConnectionInfo.New(isDisconnected, lastMessageTimestamp)
  return {
    IsDisconnected = isDisconnected,
    LastMessageTimestamp = lastMessageTimestamp,
  }
end