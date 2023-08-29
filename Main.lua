TollskisHardcoreHelper_Settings = nil

TollskisHardcoreHelper_EventManager = {
  -- AuctionHouseIsOpen = nil,
  EventHandlers = {},
  -- LastPlayerDeadEventTimestamp = nil,
  -- LastPlayerMoney = nil,
  -- MailboxIsOpen = nil,
  -- MailboxMessages = nil,
  -- MailboxUpdatesRunning = 0,
  -- MailInboxUpdatedAfterOpen = nil,
  -- MerchantIsOpen = nil,
  -- NewLevelToAddToHistory = nil,
  -- PersistentPlayerInfo = nil,
  -- PlayerEnteringWorldHasFired = false,
  -- PlayerName = nil,
  -- PlayerFlags = {
  --   AffectingCombat = nil,
  --   Afk = nil,
  --   InParty = nil,
  --   IsDeadOrGhost = nil,
  --   OnTaxi = nil
  -- },
  -- TemporaryTimestamps = { -- These are specifically for time tracking.
  --   Died = nil,
  --   EnteredArea = nil,
  --   EnteredCombat = nil,
  --   EnteredTaxi = nil,
  --   JoinedParty = nil,
  --   LastJump = nil,
  --   MarkedAfk = nil,
  --   OtherPlayerJoinedGroup = {}, -- Dict<UnitGuid, TempTimestamp>
  --   StartedCasting = nil,
  -- },
  -- TimePlayedMessageChatFramesToRegister = nil,
  -- TimePlayedMessageIsUnregistered = nil,
  -- TimePlayedMessageLastTimestamp = nil,
  -- TradeInfo = nil,
  -- ZoneChangedNewAreaEventHasFired = false
}

local EM = TollskisHardcoreHelper_EventManager
-- local Controller = AutoBiographer_Controller

-- Slash Commands

SLASH_TOLLSKISHARDCOREHELPER1, SLASH_TOLLSKISHARDCOREHELPER2 = "/tollskishardcorehelper", "/thh"
function SlashCmdList.TOLLSKISHARDCOREHELPER()
  EM:Test()
end

-- *** Locals ***

-- local damagedUnits = {}

-- local combatLogDamageEvents = { }
-- local combatLogHealEvents = { }
-- do
--     local damageEventPrefixes = { "RANGE", "SPELL", "SPELL_BUILDING", "SPELL_PERIODIC", "SWING" }
--     local damageEventSuffixes = { "DAMAGE", "DRAIN", "INSTAKILL", "LEECH" }
--     for _, prefix in pairs(damageEventPrefixes) do
--         for _, suffix in pairs(damageEventSuffixes) do
--             combatLogDamageEvents[prefix .. "_" .. suffix] = true
--         end
--     end
-- end
-- do
--     local healEventPrefixes = { "SPELL", "SPELL_PERIODIC" }
--     local healEventSuffixes = { "HEAL" }
--     for _, prefix in pairs(healEventPrefixes) do
--         for _, suffix in pairs(healEventSuffixes) do
--             combatLogHealEvents[prefix .. "_" .. suffix] = true
--         end
--     end
-- end

-- local validUnitIds = { "focus", "focuspet", "mouseover", "mouseoverpet", "pet", "player", "target", "targetpet" }
-- for i = 1, 40 do
-- 	if i <= 4 then
-- 		validUnitIds[#validUnitIds + 1] = "party" .. i
-- 		validUnitIds[#validUnitIds + 1] = "partypet" .. i
-- 	end
-- 	validUnitIds[#validUnitIds + 1] = "raid" .. i
-- 	validUnitIds[#validUnitIds + 1] = "raidpet" .. i
-- end
-- for i = 1, 50 do
--   validUnitIds[#validUnitIds + 1] = "nameplate" .. i
-- end
-- for i = 1, #validUnitIds do
-- 	validUnitIds[#validUnitIds + 1] = validUnitIds[i] .. "target"
-- end

-- local function FindUnitGUIDByUnitName(unitName)
-- 	for i = 1, #validUnitIds do
--     if (UnitName(validUnitIds[i]) == unitName) then return UnitGUID(validUnitIds[i]) end
-- 	end
-- 	return nil
-- end

-- local function FindUnitIdByUnitGUID(unitGuid)
-- 	for i = 1, #validUnitIds do
-- 		if UnitGUID(validUnitIds[i]) == unitGuid then return validUnitIds[i] end
-- 	end
-- 	return nil
-- end

-- local function IsUnitGUIDInOurPartyOrRaid(unitGuid)
--   for i = 1, #validUnitIds do
--     if ((string.match(validUnitIds[i], "party") or string.match(validUnitIds[i], "raid")) and not string.match(validUnitIds[i], "target")) then
--         if (UnitGUID(validUnitIds[i]) == unitGuid) then return true end
--     end
-- 	end
-- 	return false
-- end

-- local function IsUnitGUIDPlayerOrPlayerPet(unitGuid)
--   if (UnitGUID("player") == unitGuid) then return true end
--   if (UnitGUID("pet") == unitGuid) then return true end
-- 	return false
-- end

-- *** Event Handlers ***

function EM:OnEvent(_, event, ...)
  if self.EventHandlers[event] then
		self.EventHandlers[event](self, ...)
	end
end

function EM.EventHandlers.ADDON_LOADED(self, addonName, ...)
  if (addonName ~= "TollskisHardcoreHelper") then return end
  
  -- if type(_G["AUTOBIOGRAPHER_SETTINGS"]) ~= "table" then
	-- 	_G["AUTOBIOGRAPHER_SETTINGS"] = {
  --     EventDisplayFilters = {}, -- Dict<EventSubType, bool>
  --     MapEventDisplayFilters = {}, -- Dict<EventSubType, bool>
  --     MapEventShowAnimation = false,
  --     MapEventShowCircle = true,
	-- 		MapEventFollowExpansions = false,
  --     MinimapPos = -25,
  --     Options = { -- Dict<string?, bool>
  --       EnableDebugLogging = false,
  --       EnableMilestoneMessages = true,
  --       ShowFriendlyPlayerToolTips = true,
  --       ShowKillCountOnUnitToolTips = true,
  --       ShowLowRankCombatSkillWarnings = true,
  --       ShowMinimapButton = true,
  --       ShowTimePlayedOnLevelUp = true,
  --       TakeScreenshotOnAchievementEarned = false,
  --       TakeScreenshotOnBossKill = true,
  --       TakeScreenshotOnLevelUp = true,
  --       TakeScreenshotOnlyOnFirstBossKill = true,
  --     }, 
  --   }
  --   for k,v in pairs(AutoBiographerEnum.EventSubType) do
  --     _G["AUTOBIOGRAPHER_SETTINGS"].EventDisplayFilters[v] = true
  --     _G["AUTOBIOGRAPHER_SETTINGS"].MapEventDisplayFilters[v] = true
  --   end
	-- end
  
  -- AutoBiographer_Settings = _G["AUTOBIOGRAPHER_SETTINGS"]
 
  -- if type(_G["AUTOBIOGRAPHER_CATALOGS_CHAR"]) ~= "table" then
	-- 	_G["AUTOBIOGRAPHER_CATALOGS_CHAR"] = Catalogs.New()
	-- end
  -- if type(_G["AUTOBIOGRAPHER_EVENTS_CHAR"]) ~= "table" then
	-- 	_G["AUTOBIOGRAPHER_EVENTS_CHAR"] = {}
	-- end
  -- if type(_G["AUTOBIOGRAPHER_LEVELS_CHAR"]) ~= "table" then
	-- 	_G["AUTOBIOGRAPHER_LEVELS_CHAR"] = {}
	-- end
  -- if type(_G["AUTOBIOGRAPHER_NOTES_CHAR"]) ~= "table" then
	-- 	_G["AUTOBIOGRAPHER_NOTES_CHAR"] = Notes.New()
	-- end
  
  -- Controller.CharacterData = {
  --   Catalogs = _G["AUTOBIOGRAPHER_CATALOGS_CHAR"],
  --   Events = _G["AUTOBIOGRAPHER_EVENTS_CHAR"],
  --   Levels = _G["AUTOBIOGRAPHER_LEVELS_CHAR"],
  --   Notes = _G["AUTOBIOGRAPHER_NOTES_CHAR"]
  -- }
  
  -- if type(_G["AUTOBIOGRAPHER_INFO_CHAR"]) ~= "table" then
	-- 	_G["AUTOBIOGRAPHER_INFO_CHAR"] = {
  --     ArenaStatuses = {},
  --     BattlegroundStatuses = {},
  --     CurrentSubZone = nil,
  --     CurrentZone = nil,
  --     DatabaseVersion = 17,
  --     GuildName = nil,
  --     GuildRankIndex = nil,
  --     GuildRankName = nil,
  --     LastTotalTimePlayed = nil,
  --     PlayerGuid = nil,
  --   }
	-- end
  
  -- self.PersistentPlayerInfo = _G["AUTOBIOGRAPHER_INFO_CHAR"]

  -- AutoBiographer_Databases.Initialiaze()
  
  -- -- Database Migrations
  -- if (not self.PersistentPlayerInfo.DatabaseVersion or self.PersistentPlayerInfo.DatabaseVersion < AutoBiographer_MigrationManager:GetLatestDatabaseVersion()) then
  --   AutoBiographer_MigrationManager:RunMigrations(self.PersistentPlayerInfo.DatabaseVersion, EM, Controller)
  -- end
  
  -- --
  -- local playerLevel = UnitLevel("player")
  -- if (not Controller.CharacterData.Levels[playerLevel]) then 
  --   if (playerLevel == 1 and UnitXP("player") == 0) then
  --     Controller:OnLevelUp(time(), nil, playerLevel, 0)
  --   else 
  --     Controller:OnLevelUp(nil, nil, playerLevel)
  --   end
  -- end
  
  -- AutoBiographer_MinimapButton_Reposition()
  -- if (AutoBiographer_Settings.Options["ShowMinimapButton"] == false) then AutoBiographer_MinimapButton:Hide()
  -- else AutoBiographer_MinimapButton:Show() end

  -- AutoBiographer_DebugWindow:Initialize()
  -- AutoBiographer_EventWindow:Initialize()
  -- AutoBiographer_MainWindow:Initialize()
  -- AutoBiographer_NoteDetailsWindow:Initialize()
  -- AutoBiographer_NotesWindow:Initialize()
  -- AutoBiographer_OptionWindow:Initialize()
  -- AutoBiographer_StatisticsWindow:Initialize()
  -- AutoBiographer_VerificationWindow:Initialize()

  -- AutoBiographer_WorldMapOverlayWindow_Initialize()
  -- AutoBiographer_WorldMapOverlayWindowToggleButton:Initialize()

  -- C_Timer.After(1, function()
  --   EM:RequestTimePlayedInterval()
  -- end)
end

function EM.EventHandlers.COMBAT_LOG_EVENT_UNFILTERED(self)
  -- local timestamp, event, hideCaster, sourceGuid, sourceName, sourceFlags, sourceRaidFlags, destGuid, destName, destFlags, destRaidflags = CombatLogGetCurrentEventInfo()
  
  -- if (combatLogDamageEvents[event]) then
  --   local playerCausedThisEvent = sourceGuid == self.PersistentPlayerInfo.PlayerGuid
  --   local playerPetCausedThisEvent = sourceGuid == UnitGUID("pet")
  --   local groupMemberCausedThisEvent = IsUnitGUIDInOurPartyOrRaid(sourceGuid)
    
  --   -- Get UnitIds of damager and damaged unit.
  --   local damagerUnitId = FindUnitIdByUnitGUID(sourceGuid)
  --   if (damagerUnitId ~= nil) then 
  --     local damagerCatalogUnitId = HelperFunctions.GetCatalogIdFromGuid(sourceGuid)
  --     if (Controller:CatalogUnitIsIncomplete(damagerCatalogUnitId)) then
  --       Controller:UpdateCatalogUnit(CatalogUnit.New(damagerCatalogUnitId, UnitClass(damagerUnitId), UnitClassification(damagerUnitId), UnitCreatureFamily(damagerUnitId), UnitCreatureType(damagerUnitId), UnitName(damagerUnitId), UnitRace(damagerUnitId), nil, HelperFunctions.GetUnitTypeFromCatalogUnitId(damagerCatalogUnitId)))
  --     end
  --   end

  --   -- Set damage flags.
  --   if (damagedUnits[destGuid] == nil or unitWasOutOfCombat) then   
  --     local firstObservedDamageCausedByPlayerOrGroup = playerCausedThisEvent or playerPetCausedThisEvent or groupMemberCausedThisEvent
      
  --     damagedUnits[destGuid] = {
  --       DamageTakenFromGroup = 0,
  --       DamageTakenFromPlayerOrPet = 0,
  --       DamageTakenTotal = 0,
  --       FirstObservedDamageCausedByPlayerOrGroup = firstObservedDamageCausedByPlayerOrGroup,
  --       GroupHasDamaged = nil,
  --       IsTapDenied = nil,
  --       LastUnitGuidWhoCausedDamage = nil,
  --       PlayerHasDamaged = nil,
  --       PlayerPetHasDamaged = nil,
  --     }
  --   else
  --     if (damagedUnitId ~= nil) then
  --       damagedUnits[destGuid].IsTapDenied = UnitIsTapDenied(damagedUnitId)
  --       --if (AutoBiographer_Settings.Options["EnableDebugLogging"]) then Controller:AddLog(destName .. " (" .. damagedUnitId .. ") tap denied: " .. tostring(damagedUnits[destGuid].IsTapDenied), AutoBiographerEnum.LogLevel.Verbose) end
  --     end
  --   end

  --   local damagedUnit = damagedUnits[destGuid]

  --   local damagedUnitId = FindUnitIdByUnitGUID(destGuid)
  --   local unitWasOutOfCombat = nil
  --   if (damagedUnitId ~= nil) then 
  --     unitWasOutOfCombat = not UnitAffectingCombat(damagedUnitId)
      
  --     local damagedCatalogUnitId = HelperFunctions.GetCatalogIdFromGuid(destGuid)
  --     if (Controller:CatalogUnitIsIncomplete(damagedCatalogUnitId)) then
  --       Controller:UpdateCatalogUnit(CatalogUnit.New(damagedCatalogUnitId, UnitClass(damagedUnitId), UnitClassification(damagedUnitId), UnitCreatureFamily(damagedUnitId), UnitCreatureType(damagedUnitId), UnitName(damagedUnitId), UnitRace(damagedUnitId), nil, HelperFunctions.GetUnitTypeFromCatalogUnitId(damagedCatalogUnitId)))
  --     end
  --   end
    
  --   -- Process event's damage amount.
  --   if (string.find(event, "SWING") == 1) then
  --     amount, overKill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = select(12, CombatLogGetCurrentEventInfo())
  --   elseif (string.find(event, "RANGE") == 1 or string.find(event, "SPELL") == 1) then
  --     spellId, spellName, spellSchool, amount, overKill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = select(12, CombatLogGetCurrentEventInfo())
  --   end
    
  --   if (amount) then
  --     if (not overKill or overKill == -1) then overKill = 0 end -- -1 means none, nil means INSTAKILL or other non-DAMAGE type
      
  --     damagedUnit.DamageTakenTotal = damagedUnit.DamageTakenTotal + amount - overKill

  --     if (playerCausedThisEvent) then 
  --       Controller:OnDamageOrHealing(AutoBiographerEnum.DamageOrHealingCategory.DamageDealt, amount, overKill)
  --       damagedUnit.DamageTakenFromPlayerOrPet = damagedUnit.DamageTakenFromPlayerOrPet + amount - overKill
  --     elseif (destGuid == self.PersistentPlayerInfo.PlayerGuid) then
  --       Controller:OnDamageOrHealing(AutoBiographerEnum.DamageOrHealingCategory.DamageTaken, amount, overKill)
  --     elseif (playerPetCausedThisEvent) then 
  --       Controller:OnDamageOrHealing(AutoBiographerEnum.DamageOrHealingCategory.PetDamageDealt, amount, overKill)
  --       damagedUnit.DamageTakenFromPlayerOrPet = damagedUnit.DamageTakenFromPlayerOrPet + amount - overKill
  --     elseif (destGuid == UnitGUID("pet")) then
  --       Controller:OnDamageOrHealing(AutoBiographerEnum.DamageOrHealingCategory.PetDamageTaken, amount, overKill)
  --     elseif (groupMemberCausedThisEvent) then
  --       damagedUnit.DamageTakenFromGroup = damagedUnit.DamageTakenFromGroup + amount - overKill
  --     end
  --   end
    
  --   if (playerCausedThisEvent) then damagedUnit.PlayerHasDamaged = true
  --   elseif (playerPetCausedThisEvent) then damagedUnit.PlayerPetHasDamaged = true
  --   elseif (groupMemberCausedThisEvent) then damagedUnit.GroupHasDamaged = true
  --   end
    
  --   damagedUnit.LastUnitGuidWhoCausedDamage = sourceGuid
    
  --   if (destGuid == self.PersistentPlayerInfo.PlayerGuid) then damagedUnit.LastCombatDamageTakenTimestamp = time() end
  -- elseif (combatLogHealEvents[event]) then
  --   -- Process event's heal amount.
  --   if (sourceGuid == self.PersistentPlayerInfo.PlayerGuid or destGuid == self.PersistentPlayerInfo.PlayerGuid) then
  --     spellId, spellName, spellSchool, amount, overKill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = select(12, CombatLogGetCurrentEventInfo())

  --     if (amount) then 
  --       if (not overKill or overKill == -1) then overKill = 0 end
        
  --       if (sourceGuid == self.PersistentPlayerInfo.PlayerGuid) then
  --         if (destGuid == self.PersistentPlayerInfo.PlayerGuid) then
  --           Controller:OnDamageOrHealing(AutoBiographerEnum.DamageOrHealingCategory.HealingDealtToSelf, amount, overKill)
  --         else
  --           Controller:OnDamageOrHealing(AutoBiographerEnum.DamageOrHealingCategory.HealingDealtToOthers, amount, overKill)
  --         end
  --       end
        
  --       if (destGuid == self.PersistentPlayerInfo.PlayerGuid) then
  --         Controller:OnDamageOrHealing(AutoBiographerEnum.DamageOrHealingCategory.HealingTaken, amount, overKill)
  --       end
        
  --     end
  --   end
  -- end

  -- if (event ~= "UNIT_DIED") then return end
  -- if (damagedUnits[destGuid] == nil) then return end
  
  -- local deadUnit = damagedUnits[destGuid]

  -- local weHadTag = false
  -- if (deadUnit.IsTapDenied) then
  --   weHadTag = false
  -- elseif (deadUnit.IsTapDenied ~= nil and not deadUnit.IsTapDenied and (deadUnit.PlayerHasDamaged or deadUnit.PlayerPetHasDamaged or deadUnit.GroupHasDamaged)) then
  --   weHadTag = true
  -- else
  --   weHadTag = deadUnit.FirstObservedDamageCausedByPlayerOrGroup
  -- end
  
  -- if (deadUnit.PlayerHasDamaged or deadUnit.PlayerPetHasDamaged or weHadTag) then
  --   if (AutoBiographer_Settings.Options["EnableDebugLogging"]) then Controller:AddLog(destName .. " Died.  Tagged: " .. tostring(weHadTag) .. ". FODCBPOG: " .. tostring(deadUnit.FirstObservedDamageCausedByPlayerOrGroup) .. ". ITD: "  .. tostring(deadUnit.IsTapDenied) .. ". PHD: " .. tostring(deadUnit.PlayerHasDamaged) .. ". PPHD: " .. tostring(deadUnit.PlayerPetHasDamaged).. ". GHD: "  .. tostring(deadUnit.GroupHasDamaged)  .. ". LastDmg: " .. tostring(deadUnit.LastUnitGuidWhoCausedDamage), AutoBiographerEnum.LogLevel.Debug) end

  --   local playerOrGroupDmgOfTotal = HelperFunctions.Round(100 * ((deadUnit.DamageTakenFromPlayerOrPet + deadUnit.DamageTakenFromGroup) / deadUnit.DamageTakenTotal))
  --   local kill = Kill.New(deadUnit.GroupHasDamaged, deadUnit.PlayerHasDamaged or deadUnit.PlayerPetHasDamaged, IsUnitGUIDPlayerOrPlayerPet(deadUnit.LastUnitGuidWhoCausedDamage), weHadTag, HelperFunctions.GetCatalogIdFromGuid(destGuid), playerOrGroupDmgOfTotal)
  --   Controller:OnKill(time(), HelperFunctions.GetCoordinatesByUnitId("player"), kill)
  -- end
  
  -- if (destGuid ~= self.PersistentPlayerInfo.PlayerGuid) then damagedUnits[destGuid] = nil end
end







function EM.EventHandlers.UNIT_COMBAT(self, unitId, action, ind, dmg, dmgType)
  --print("UNIT_COMBAT: " .. unitId .. ". " .. action .. ". " .. ind .. ". " .. dmg .. ". " .. dmgType)
end

local healthStatus

function EM.EventHandlers.UNIT_HEALTH(self, unitId)
  --print("UNIT_HEALTH: " .. unitId)

  if (unitId ~= "player") then return end

  local health = UnitHealth(unitId)
  local maxHealth = UnitHealthMax(unitId)

  local healthPercentage = health / maxHealth

  local newHealthStatus = nil
  if (healthPercentage <= 0.25) then
    newHealthStatus = 1 -- red
  elseif (healthPercentage <= 0.50) then
    newHealthStatus = 2 -- orange
  elseif (healthPercentage <= 0.75) then
    newHealthStatus = 3 -- yellow
  else
    newHealthStatus = 4 -- green
  end

  if (newHealthStatus == healthStatus) then return end

  if (newHealthStatus == 1) then
    self:PlaySound("alert")
  elseif (newHealthStatus == 2 and (healthStatus == nil or healthStatus > newHealthStatus)) then
    self:PlaySound("warning")
  end

  healthStatus = newHealthStatus
end

function EM.EventHandlers.UNIT_TARGET(self, unitId)
  --print("UNIT_TARGET: " .. unitId)
end

GameTooltip:HookScript("OnTooltipSetUnit", function(self)
	-- local catalogUnitId = HelperFunctions.GetCatalogIdFromGuid(UnitGUID("mouseover"))
  -- if (not catalogUnitId) then
  --   return
  -- end

	-- if (AutoBiographer_Settings.Options["ShowKillCountOnUnitToolTips"] and UnitCanAttack("player", "mouseover")) then
  --   local killStatistics = Controller:GetAggregatedKillStatisticsByCatalogUnitId(catalogUnitId, 1, 9999)
  --   if (UnitIsPlayer("mouseover")) then
  --     GameTooltip:AddLine("Killed " .. tostring(KillStatistics.GetSum(killStatistics, { AutoBiographerEnum.KillTrackingType.TaggedKillingBlow, AutoBiographerEnum.KillTrackingType.UntaggedKillingBlow })) .. " times.")
  --   else
  --     GameTooltip:AddLine("Killed " .. tostring(KillStatistics.GetSum(killStatistics, { AutoBiographerEnum.KillTrackingType.TaggedAssist, AutoBiographerEnum.KillTrackingType.TaggedGroupAssistOrKillingBlow, AutoBiographerEnum.KillTrackingType.TaggedKillingBlow })) .. " times.")
  --   end
  -- elseif (AutoBiographer_Settings.Options["ShowFriendlyPlayerToolTips"] and not UnitCanAttack("player", "mouseover") and UnitIsPlayer("mouseover")) then
  --   local otherPlayerStatistics = Controller:GetAggregatedOtherPlayerStatisticsByCatalogUnitId(catalogUnitId, 1, 9999)
  --   local tooltipString = ""

  --   local duelsWon = OtherPlayerStatistics.GetSum(otherPlayerStatistics, { AutoBiographerEnum.OtherPlayerTrackingType.DuelsLostToPlayer })
  --   local duelsLost = OtherPlayerStatistics.GetSum(otherPlayerStatistics, { AutoBiographerEnum.OtherPlayerTrackingType.DuelsWonAgainstPlayer })
  --   if (duelsWon > 0 or duelsLost > 0) then
  --     tooltipString = tooltipString .. "Duels (W/L): " .. tostring(duelsWon) .. "/" .. tostring(duelsLost) .. ". "
  --   end

  --   local timeGrouped = HelperFunctions.Round(OtherPlayerStatistics.GetSum(otherPlayerStatistics, { AutoBiographerEnum.OtherPlayerTrackingType.TimeSpentGroupedWithPlayer }) / 3600, 2)
  --   if (timeGrouped > 0) then
  --     tooltipString = tooltipString .. "Time Grouped: " .. timeGrouped .. "h. "
  --   end

  --   if (tooltipString ~= "") then
  --     GameTooltip:AddLine(tooltipString)
  --   end
	-- end

	-- self:Show()
end)





-- Register each event for which we have an event handler.
EM.Frame = CreateFrame("Frame")
for eventName,_ in pairs(EM.EventHandlers) do
	  EM.Frame:RegisterEvent(eventName)
end
EM.Frame:SetScript("OnEvent", function(_, event, ...) EM:OnEvent(_, event, ...) end)

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

function EM:Test()
  print("[THH] Test")
  self:PlaySound("alert")
end