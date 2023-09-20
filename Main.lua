TollskisHardcoreHelper_Settings = nil

TollskisHardcoreHelper_EventManager = {
  EventHandlers = {},
}

local EM = TollskisHardcoreHelper_EventManager

local ConnectionManager = TollskisHardcoreHelper_ConnectionManager
local MessageManager = TollskisHardcoreHelper_MessageManager

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

  ConnectionManager:CheckGroupConnectionsInterval()
  ConnectionManager:SendHeartbeatInterval()
end

function EM.EventHandlers.CHAT_MSG_ADDON(self, prefix, text, channel, sender, target, zoneChannelID, localID, name, instanceID)
  MessageManager:OnChatMessageAddonEvent(prefix, text, channel, sender, target, zoneChannelID, localID, name, instanceID)
end

local AurasToNotify = { -- Key is aura name, value is if we should notify the player if they themselves are affected (if false, only notify when other players are affected by the aura)
  ["Blessing of Protection"] = true,
  ["Divine Protection"] = false,
  ["Divine Shield"] = false,
}

function EM.EventHandlers.COMBAT_LOG_EVENT_UNFILTERED(self)
  local timestamp, event, hideCaster, sourceGuid, sourceName, sourceFlags, sourceRaidFlags, destGuid, destName, destFlags, destRaidflags = CombatLogGetCurrentEventInfo()
  --print("COMBAT_LOG_EVENT_UNFILTERED. " .. tostring(event))

  if (event == "SPELL_AURA_APPLIED") then
    local amount, auraType = select(12, CombatLogGetCurrentEventInfo())
    if (AurasToNotify[auraType] == true or (AurasToNotify[auraType] == false and sourceName ~= UnitName("player"))) then
      TollskisHardcoreHelper_NotificationManager:ShowNotificationToPlayer(sourceName, ThhEnum.NotificationType.AuraApplied, auraType)
    end
  end
end

function EM.EventHandlers.GROUP_ROSTER_UPDATE(self)
  self:UpdateGroupMemberInfo()
end

function EM.EventHandlers.PLAYER_ENTERING_WORLD(self, isLogin, isReload)
  --print("PLAYER_ENTERING_WORLD. " .. tostring(isLogin) ..  ", " .. tostring(isReload))

  self:UpdateGroupMemberInfo()
  
  if (isLogin or isReload) then
    C_ChatInfo.RegisterAddonMessagePrefix(MessageManager.AddonMessagePrefix)
  end
end

function EM.EventHandlers.PLAYER_REGEN_DISABLED(self)
  --print("PLAYER_REGEN_DISABLED")

  MessageManager:SendMessageToGroup(ThhEnum.AddonMessageType.EnteredCombat)
end

function EM.EventHandlers.PLAYER_REGEN_ENABLED(self)
  --print("PLAYER_REGEN_ENABLED")

  MessageManager:SendMessageToGroup(ThhEnum.AddonMessageType.ExitedCombat)
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

  if (newHealthStatus == 1) then
    TollskisHardcoreHelper_NotificationManager:ShowNotificationToPlayer(UnitName(unitId), ThhEnum.NotificationType.HealthCriticallyLow, math.floor(healthPercentage * 100))

    if (updateIsForPlayer) then
      self:PlaySound("alert2")
      MessageManager:SendMessageToGroup(ThhEnum.AddonMessageType.HealthCriticallyLow, math.floor(healthPercentage * 100))
      TollskisHardcoreHelper_FlashFrame:PlayAnimation(9999, 1.5, 1.0)
    end
  elseif (newHealthStatus == 2) then
    if (oldHealthStatus == nil or oldHealthStatus > newHealthStatus) then
      TollskisHardcoreHelper_NotificationManager:ShowNotificationToPlayer(UnitName(unitId), ThhEnum.NotificationType.HealthLow, math.floor(healthPercentage * 100))
      
      if (updateIsForPlayer) then
        self:PlaySound("alert3")
        MessageManager:SendMessageToGroup(ThhEnum.AddonMessageType.HealthLow, math.floor(healthPercentage * 100))
      end
    end

    if (updateIsForPlayer) then
      TollskisHardcoreHelper_FlashFrame:PlayAnimation(9999, 2.0, 0.75)
    end
  else
    TollskisHardcoreHelper_FlashFrame:StopAnimation()
  end

  healthStatus[unitId] = newHealthStatus
end

local SpellsToNotifyOnCastStart = {
  [8690] = true, -- Hearthstone
}

local SpellsToNotifyOnCastSucceeded = {
  [19752] = true, -- Divine Intervention
}

function EM.EventHandlers.UNIT_SPELLCAST_CHANNEL_START(self, unitId, castId, spellId)
  if (unitId ~= "player") then return end
  --print("UNIT_SPELLCAST_CHANNEL_START. " .. tostring(unitId) .. ", " .. tostring(castId) .. ", " .. tostring(spellId))

  if (SpellsToNotifyOnCastStart[spellId]) then
    MessageManager:SendMessageToGroup(ThhEnum.AddonMessageType.SpellCastStarted, spellId)
  end
end

function EM.EventHandlers.UNIT_SPELLCAST_CHANNEL_STOP(self, unitId, castId, spellId)
  if (unitId ~= "player") then return end
  --print("UNIT_SPELLCAST_CHANNEL_STOP. " .. tostring(unitId) .. ", " .. tostring(castId) .. ", " .. tostring(spellId))
  
  if (SpellsToNotifyOnCastStart[spellId]) then
    MessageManager:SendMessageToGroup(ThhEnum.AddonMessageType.SpellCastInterrupted, spellId)
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

function EM.EventHandlers.UNIT_SPELLCAST_INTERRUPTED(self, unitId, castId, spellId)
  if (unitId ~= "player") then return end
  --print("UNIT_SPELLCAST_INTERRUPTED. " .. tostring(unitId) .. ", " .. tostring(castId) .. ", " .. tostring(spellId))

  if (SpellsToNotifyOnCastStart[spellId]) then
    MessageManager:SendMessageToGroup(ThhEnum.AddonMessageType.SpellCastInterrupted, spellId)
  end
end

function EM.EventHandlers.UNIT_SPELLCAST_START(self, unitId, castId, spellId)
  if (unitId ~= "player") then return end
  --print("UNIT_SPELLCAST_START. " .. tostring(unitId) .. ", " .. tostring(castId) .. ", " .. tostring(spellId))

  if (SpellsToNotifyOnCastStart[spellId]) then
    MessageManager:SendMessageToGroup(ThhEnum.AddonMessageType.SpellCastStarted, spellId)
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
    MessageManager:SendMessageToGroup(ThhEnum.AddonMessageType.SpellCastSucceeded, spellId)
  end
end

function EM.EventHandlers.UNIT_TARGET(self, unitId)
  --print("UNIT_TARGET: " .. unitId)
end

hooksecurefunc("CancelLogout", function()
	--print("CancelLogout")

  MessageManager:SendMessageToGroup(ThhEnum.AddonMessageType.LogoutCancelled)
end)

hooksecurefunc("Logout", function()
	--print("Logout")
  if (UnitAffectingCombat("player")) then return end

  MessageManager:SendMessageToGroup(ThhEnum.AddonMessageType.LoggingOut)
end)

hooksecurefunc("Quit", function()
	--print("Quit")
  if (UnitAffectingCombat("player")) then return end

  MessageManager:SendMessageToGroup(ThhEnum.AddonMessageType.LoggingOut)
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

function EM:UpdateGroupMemberInfo()
  -- Populate list of unit GUIDs in player's party/raid.
  local playerGuid = UnitGUID("player")
  local unitGuidsInGroup = { }

  unitGuidsInGroup[playerGuid] = true
  for i = 1, 4 do
    local guid = UnitGUID("party" .. i)
    if (guid and guid ~= playerGuid) then
      unitGuidsInGroup[guid] = true
    end
  end
  for i = 1, 40 do
    local guid = UnitGUID("raid" .. i)
    if (guid and guid ~= playerGuid) then
      unitGuidsInGroup[guid] = true
    end
  end
  
  -- Perform actions for units who joined the group.
  for k,v in pairs(unitGuidsInGroup) do
    
  end
  
  -- Perform actions for units who left the group.
  for k,v in pairs(TollskisHardcoreHelper_PlayerStates) do
    if (not unitGuidsInGroup[k]) then
      TollskisHardcoreHelper_PlayerStates[k] = nil
    end
  end
end

function EM:Test()
  print("[THH] Test")

  -- print(UnitDetailedThreatSituation("player", "target"))
  -- local possibleEnemyUnitIds = UnitHelperFunctions.GetPossibleEnemyUnitIds()
  -- local unitsTargettingMe = {}
  -- for i = 1, #possibleEnemyUnitIds do
  --   local guid = UnitGUID(possibleEnemyUnitIds[i])
  --   if (guid and not unitsTargettingMe[guid]) then
  --     local isTanking, status, threatpct, rawthreatpct, threatvalue = UnitDetailedThreatSituation("player", possibleEnemyUnitIds[i])
  --     if (isTanking) then
  --       unitsTargettingMe[guid] = true
  --     end
  --   end
	-- end

  -- local unitsTargettingMeCount = 0
  -- for k,v in pairs(unitsTargettingMe) do
  --   unitsTargettingMeCount = unitsTargettingMeCount + 1
  -- end

  -- print(unitsTargettingMeCount)

  -- local nameplateMaxDistance = GetCVar("nameplateMaxDistance")
  -- print(nameplateMaxDistance)
  -- --SetCVar("nameplateMaxDistance", 40) -- max is 20 in vanilla

  C_ChatInfo.SendAddonMessage("TsHardcoreHelper", "Test message.", "RAID", target)

end
