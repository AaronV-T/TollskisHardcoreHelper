Safeguard_Settings = nil

Safeguard_EventManager = {
  DebugLogs = {},
  EventHandlers = {},
}

local EM = Safeguard_EventManager

local IntervalManager = Safeguard_IntervalManager
local MessageManager = Safeguard_MessageManager

-- Slash Commands

SLASH_SAFEGUARD1, SLASH_SAFEGUARD2 = "/safeguard", "/sg"
function SlashCmdList.SAFEGUARD()
  EM:Test()
end

SLASH_SAFEGUARDDEBUG1, SLASH_SAFEGUARDDEBUG2 = "/sasfeguarddebug", "/sgdebug"
function SlashCmdList.SAFEGUARDDEBUG()
  EM:Debug()
end

-- *** Locals ***

-- *** Event Handlers ***

function EM:OnEvent(_, event, ...)
  if self.EventHandlers[event] then
		self.EventHandlers[event](self, ...)
	end
end

function EM.EventHandlers.ADDON_LOADED(self, addonName, ...)
  if (addonName ~= "Safeguard") then return end

  if (type(_G["SAFEGUARD_SETTINGS"]) ~= "table") then
		_G["SAFEGUARD_SETTINGS"] = {
      Options = {
        EnableChatMessages = true,
        EnableChatMessagesLogout = true,
        EnableChatMessagesLowHealth = true,
        EnableChatMessagesSpellCasts = true,
        EnableLowHealthAlerts = true,
        EnableLowHealthAlertScreenFlashing = true,
        EnableLowHealthAlertSounds = true,
        EnableTextNotifications = true,
        EnableTextNotificationsAurasSelf = true,
        EnableTextNotificationsAurasGroup = true,
        EnableTextNotificationsCombatSelf = true,
        EnableTextNotificationsCombatGroup = true,
        EnableTextNotificationsConnectionSelf = true,
        EnableTextNotificationsConnectionGroup = true,
        EnableTextNotificationsLogout = true,
        EnableTextNotificationsLowHealthSelf = true,
        EnableTextNotificationsLowHealthGroup = true,
        EnableTextNotificationsSpellcasts = true,
        ShowIconsOnRaidFrames = true,
      },
    }
	end
  
  Safeguard_Settings = _G["SAFEGUARD_SETTINGS"]

  Safeguard_OptionWindow:Initialize()
end

function EM.EventHandlers.CHAT_MSG_ADDON(self, prefix, text, channel, sender, target, zoneChannelID, localID, name, instanceID)
  MessageManager:OnChatMessageAddonEvent(prefix, text, channel, sender, target, zoneChannelID, localID, name, instanceID)
end

local AurasToNotify = {
  ["Blessing of Protection"] = true,
  ["Divine Intervention"] = true,
  ["Divine Protection"] = true,
  ["Divine Shield"] = true,
  ["Feign Death"] = true, -- unconfirmed
  ["Ice Block"] = true, -- unconfirmed
  ["Invulnerability"] = true, -- unconfirmed Limited Invulnerability Potion
  ["Light of Elune"] = true, -- unconfirmed
  ["Petrification"] = true, --unconfirmed Flask of Petrification
  ["Vanish"] = true, -- unconfirmed
}

local SpellsToNotifyOnCastStart = {
  ["Hearthstone"] = true,
}

function EM.EventHandlers.COMBAT_LOG_EVENT_UNFILTERED(self)
  local timestamp, event, hideCaster, sourceGuid, sourceName, sourceFlags, sourceRaidFlags, destGuid, destName, destFlags, destRaidflags = CombatLogGetCurrentEventInfo()
  --print("COMBAT_LOG_EVENT_UNFILTERED. " .. tostring(event))

  if (event == "SPELL_AURA_APPLIED") then
    local amount, auraType = select(12, CombatLogGetCurrentEventInfo())
    if (AurasToNotify[auraType]) then
      Safeguard_NotificationManager:ShowNotificationToPlayer(destName, ThhEnum.NotificationType.AuraApplied, auraType)
    end
  elseif (event == "SPELL_CAST_FAILED") then
    -- Note: SPELL_CAST_FAILED events are not triggered for other players' failed spell casts.
    local _, spellName = select(12, CombatLogGetCurrentEventInfo())
    if (SpellsToNotifyOnCastStart[spellName]) then
      if (sourceGuid == UnitGUID("player") and UnitInParty("player")) then
        MessageManager:SendMessageToGroup(ThhEnum.AddonMessageType.SpellCastInterrupted, spellName)
      end
    end
  elseif (event == "SPELL_CAST_START") then
    local _, spellName = select(12, CombatLogGetCurrentEventInfo())
    if (SpellsToNotifyOnCastStart[spellName]) then
      if (sourceGuid == UnitGUID("player") and UnitInParty("player")) then
        MessageManager:SendMessageToGroup(ThhEnum.AddonMessageType.SpellCastStarted, spellName)
      end
      
      if (sourceGuid ~= UnitGUID("player") and UnitHelperFunctions.IsUnitGuidInOurPartyOrRaid(sourceGuid)) then
        Safeguard_NotificationManager:ShowNotificationToPlayer(sourceName, ThhEnum.NotificationType.SpellCastStarted, spellName)
      end
    end
  end
end

local playerWasInParty = false
function EM.EventHandlers.GROUP_ROSTER_UPDATE(self)
  --print("GROUP_ROSTER_UPDATE.")
  self:UpdateGroupMemberInfo()

  local playerIsInParty = UnitInParty("player")
  if (playerIsInParty and playerIsInParty ~= playerWasInParty) then
    MessageManager:SendMessageToGroup(ThhEnum.AddonMessageType.AddonInfo, GetAddOnMetadata("Safeguard", "Version"))
  end

  playerWasInParty = playerIsInParty
end

function EM.EventHandlers.PLAYER_ENTERING_WORLD(self, isLogin, isReload)
  --print("PLAYER_ENTERING_WORLD. " .. tostring(isLogin) ..  ", " .. tostring(isReload))

  self:UpdateGroupMemberInfo()
  
  if (isLogin or isReload) then
    C_ChatInfo.RegisterAddonMessagePrefix(MessageManager.AddonMessagePrefix)
  
    IntervalManager:CheckCombatInterval()
    IntervalManager:CheckGroupConnectionsInterval()
    IntervalManager:SendHeartbeatInterval()
  else
    Safeguard_PlayerStates = {}
    MessageManager:SendHeartbeatMessage()
  end
end

function EM.EventHandlers.PLAYER_LEAVING_WORLD(self)
  --print("PLAYER_LEAVING_WORLD.")

  --This message only seems to actually get sent when reloading, not when going through instance portals.
  MessageManager:SendHeartbeatMessage()
end

function EM.EventHandlers.PLAYER_REGEN_DISABLED(self)
  --print("PLAYER_REGEN_DISABLED")

  MessageManager:SendMessageToGroup(ThhEnum.AddonMessageType.EnteredCombat)
  Safeguard_NotificationManager:ShowNotificationToPlayer(UnitName("player"), ThhEnum.NotificationType.EnteredCombat)
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

  if (not Safeguard_Settings.Options.EnableLowHealthAlerts) then return end

  local updateIsForPlayer = unitId == "player"
  local updateIsForParty = unitId:match("party")
  if (not updateIsForPlayer and not updateIsForParty) then return end

  local health = UnitHealth(unitId)
  local maxHealth = UnitHealthMax(unitId)
  
  if (maxHealth == 0) then return end

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

  if (newHealthStatus == 1 and health > 0) then
    if (Safeguard_Settings.Options.EnableLowHealthAlertTextNotifications) then
      Safeguard_NotificationManager:ShowNotificationToPlayer(UnitName(unitId), ThhEnum.NotificationType.HealthCriticallyLow, math.floor(healthPercentage * 100))
    end

    if (updateIsForPlayer) then
      if (Safeguard_Settings.Options.EnableLowHealthAlertSounds) then
        self:PlaySound("alert2")
      end

      MessageManager:SendMessageToGroup(ThhEnum.AddonMessageType.HealthCriticallyLow, math.floor(healthPercentage * 100))

      if (Safeguard_Settings.Options.EnableLowHealthAlertScreenFlashing) then
        Safeguard_FlashFrame:PlayAnimation(9999, 1.5, 1.0)
      end
    end
  elseif (newHealthStatus == 2) then
    if (oldHealthStatus == nil or oldHealthStatus > newHealthStatus) then
      if (Safeguard_Settings.Options.EnableLowHealthAlertTextNotifications) then
        Safeguard_NotificationManager:ShowNotificationToPlayer(UnitName(unitId), ThhEnum.NotificationType.HealthLow, math.floor(healthPercentage * 100))
      end
      
      if (updateIsForPlayer) then
        if (Safeguard_Settings.Options.EnableLowHealthAlertSounds) then
          self:PlaySound("alert3")
        end

        MessageManager:SendMessageToGroup(ThhEnum.AddonMessageType.HealthLow, math.floor(healthPercentage * 100))
      end
    end

    if (updateIsForPlayer and Safeguard_Settings.Options.EnableLowHealthAlertScreenFlashing) then
      Safeguard_FlashFrame:PlayAnimation(9999, 2.0, 0.75)
    end
  elseif (updateIsForPlayer) then
    Safeguard_FlashFrame:StopAnimation()
  end

  healthStatus[unitId] = newHealthStatus
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

  PlaySoundFile("Interface\\AddOns\\Safeguard\\resources\\" .. soundFile .. ".mp3", "Dialog")

  C_Timer.After(1, function()
    SetCVar("Sound_EnableDialog", normalEnableDialog)
    SetCVar("Sound_DialogVolume", normalDialogVolume)
  end)
end

function EM:UpdateGroupMemberInfo()
  -- Populate list of unit GUIDs in player's party/raid.
  local playerGuid = UnitGUID("player")
  local unitGuidsInGroup = { }

  unitGuidsInGroup[playerGuid] = "player"
  for i = 1, 4 do
    local unitId = "party" .. i
    local guid = UnitGUID(unitId)
    if (guid and guid ~= playerGuid) then
      unitGuidsInGroup[guid] = unitId
    end
  end
  for i = 1, 40 do
    local unitId = "raid" .. i
    local guid = UnitGUID(unitId)
    if (guid and guid ~= playerGuid) then
      unitGuidsInGroup[guid] = unitId
    end
  end
  
  -- Perform actions for units who are in the group.
  for k,v in pairs(unitGuidsInGroup) do
  end
  
  -- Perform actions for units who left the group.
  for k,v in pairs(Safeguard_PlayerStates) do
    if (not unitGuidsInGroup[k]) then
      Safeguard_PlayerStates[k] = nil
    end
  end
end

local testNum = 1
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

  local r = C_ChatInfo.SendAddonMessage(MessageManager.AddonMessagePrefix, "TEST" .. testNum, "RAID", nil)
  print("Send TEST" .. testNum .. ", " .. tostring(r))
  testNum = testNum + 1
end

function EM:Debug()
  local startIndex = #self.DebugLogs - 50
  if (startIndex < 1) then startIndex = 1 end
  for i = startIndex, #self.DebugLogs do
    print(i .. " - " .. self.DebugLogs[i])
  end
end
