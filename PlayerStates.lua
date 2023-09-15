TollskisHardcoreHelper_PlayerStates = {} --<guid, PlayerState>

PlayerState = {}
function PlayerState.New()
  return {
    IsInCombat = nil,
    ConnectionInfo = nil,
  }
end

ConnectionInfo = {}
function ConnectionInfo.New(isDisconnected, lastMessageTimestamp)
  return {
    IsDisconnected = isDisconnected,
    LastMessageTimestamp = lastMessageTimestamp,
  }
end