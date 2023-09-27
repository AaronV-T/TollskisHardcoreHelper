TollskisHardcoreHelper_Settings = nil

TollskisHardcoreHelper_EventManager = {
  EventHandlers = {},
}

local EM = TollskisHardcoreHelper_EventManager

local AceComm = LibStub("AceComm-3.0")
local IntervalManager = TollskisHardcoreHelper_IntervalManager
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

  if (type(_G["TOLLSKISHARDCOREHELPER_SETTINGS"]) ~= "table") then
		_G["TOLLSKISHARDCOREHELPER_SETTINGS"] = {
      Options = {
        EnableLowHealthAlerts = true,
        EnableLowHealthAlertChatMessages = true,
        EnableLowHealthAlertScreenFlashing = true,
        EnableLowHealthAlertSounds = true,
        EnableLowHealthAlertTextNotifications = true,
        ShowIconsOnRaidFrames = true,
      },
    }
	end
  
  TollskisHardcoreHelper_Settings = _G["TOLLSKISHARDCOREHELPER_SETTINGS"]

  TollskisHardcoreHelper_OptionWindow:Initialize()

  AceComm:RegisterComm(TollskisHardcoreHelper_MessageManager.AddonMessagePrefix, function(prefix, text, channel, sender, target, zoneChannelID, localID, name, instanceID)
    MessageManager:OnChatMessageAddonEvent(prefix, text, channel, sender, target, zoneChannelID, localID, name, instanceID)
  end)

  C_Timer.After(1, function()
    IntervalManager:CheckCombatInterval()
    IntervalManager:CheckGroupConnectionsInterval()
    IntervalManager:SendHeartbeatInterval()
  end)
end

local AurasToNotify = { -- Key is aura name, value is if we should notify the player if they themselves are affected (if false, only notify when other players are affected by the aura)
  ["Blessing of Protection"] = true,
  ["Divine Intervention"] = true,
  ["Divine Protection"] = false,
  ["Divine Shield"] = false,
  ["Feign Death"] = false, -- unconfirmed
  ["Ice Block"] = false, -- unconfirmed
  ["Light of Elune"] = false, -- unconfirmed
  ["Vanish"] = false, -- unconfirmed
}

local SpellsToNotifyOnCastStart = {
  ["Hearthstone"] = true,
}

function EM.EventHandlers.COMBAT_LOG_EVENT_UNFILTERED(self)
  local timestamp, event, hideCaster, sourceGuid, sourceName, sourceFlags, sourceRaidFlags, destGuid, destName, destFlags, destRaidflags = CombatLogGetCurrentEventInfo()
  --print("COMBAT_LOG_EVENT_UNFILTERED. " .. tostring(event))

  if (event == "SPELL_AURA_APPLIED") then
    local amount, auraType = select(12, CombatLogGetCurrentEventInfo())
    if (AurasToNotify[auraType] == true or (AurasToNotify[auraType] == false and destGuid ~= UnitGUID("player"))) then
      TollskisHardcoreHelper_NotificationManager:ShowNotificationToPlayer(destName, ThhEnum.NotificationType.AuraApplied, auraType)
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
        TollskisHardcoreHelper_NotificationManager:ShowNotificationToPlayer(sourceName, ThhEnum.NotificationType.SpellCastStarted, spellName)
      end
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

  if (not TollskisHardcoreHelper_Settings.Options.EnableLowHealthAlerts) then return end

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

  if (newHealthStatus == 1 and healthPercentage > 0.00001) then
    if (TollskisHardcoreHelper_Settings.Options.EnableLowHealthAlertTextNotifications) then
      TollskisHardcoreHelper_NotificationManager:ShowNotificationToPlayer(UnitName(unitId), ThhEnum.NotificationType.HealthCriticallyLow, math.floor(healthPercentage * 100))
    end

    if (updateIsForPlayer) then
      if (TollskisHardcoreHelper_Settings.Options.EnableLowHealthAlertSounds) then
        self:PlaySound("alert2")
      end
      if (TollskisHardcoreHelper_Settings.Options.EnableLowHealthAlertChatMessages) then
        MessageManager:SendMessageToGroup(ThhEnum.AddonMessageType.HealthCriticallyLow, math.floor(healthPercentage * 100))
      end
      if (TollskisHardcoreHelper_Settings.Options.EnableLowHealthAlertScreenFlashing) then
        TollskisHardcoreHelper_FlashFrame:PlayAnimation(9999, 1.5, 1.0)
      end
    end
  elseif (newHealthStatus == 2) then
    if (oldHealthStatus == nil or oldHealthStatus > newHealthStatus) then
      if (TollskisHardcoreHelper_Settings.Options.EnableLowHealthAlertTextNotifications) then
        TollskisHardcoreHelper_NotificationManager:ShowNotificationToPlayer(UnitName(unitId), ThhEnum.NotificationType.HealthLow, math.floor(healthPercentage * 100))
      end
      
      if (updateIsForPlayer) then
        if (TollskisHardcoreHelper_Settings.Options.EnableLowHealthAlertSounds) then
          self:PlaySound("alert3")
        end
        if (TollskisHardcoreHelper_Settings.Options.EnableLowHealthAlertChatMessages) then
          MessageManager:SendMessageToGroup(ThhEnum.AddonMessageType.HealthLow, math.floor(healthPercentage * 100))
        end
      end
    end

    if (updateIsForPlayer and TollskisHardcoreHelper_Settings.Options.EnableLowHealthAlertScreenFlashing) then
      TollskisHardcoreHelper_FlashFrame:PlayAnimation(9999, 2.0, 0.75)
    end
  elseif (updateIsForPlayer) then
    TollskisHardcoreHelper_FlashFrame:StopAnimation()
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

  print(TollskisHardcoreHelper_Settings.Options.EnableLowHealthAlerts)
end
