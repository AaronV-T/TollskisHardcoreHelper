TollskisHardcoreHelper_NotificationManager = {
  
}

local NM = TollskisHardcoreHelper_NotificationManager

function NM:ShowNotificationToPlayer(playerWhoNotified, notificationType, arg1)
  local notification = self:GetNotification(playerWhoNotified, notificationType, arg1)
  if (not notification) then
    print("[THH] No notification for notification type " .. tostring(notificationType))
    return
  end

  local r = 1.000
  local g = 1.000
  local b = 1.000
  UIErrorsFrame:AddMessage(notification, r, g, b)
  print("[THH] " .. notification)
end

function NM:GetNotification(playerWhoNotified, notificationType, arg1)
  if (notificationType == ThhEnum.NotificationType.PlayerDisconnected) then
    return string.format("%s has disconnected.", UnitHelperFunctions.FindUnitNameByUnitGuid(arg1))
  end
  if (notificationType == ThhEnum.NotificationType.PlayerReconnected) then
    return string.format("%s has reconnected.", UnitHelperFunctions.FindUnitNameByUnitGuid(arg1))
  end
  if (notificationType == ThhEnum.NotificationType.EnteredCombat) then
    return string.format("%s entered combat.", playerWhoNotified)
  end
  if (notificationType == ThhEnum.NotificationType.LoggingOut) then
    return string.format("%s is logging out.", playerWhoNotified)
  end
  if (notificationType == ThhEnum.NotificationType.LogoutCancelled) then
    return string.format("%s has stopped logging out.", playerWhoNotified)
  end
  if (notificationType == ThhEnum.NotificationType.HealthLow) then
    local prefix
    if (playerWhoNotified == UnitName("player")) then prefix = "Your"
    else prefix = string.format("%s's", playerWhoNotified) end
    return string.format("%s health is low.", prefix)
  end
  if (notificationType == ThhEnum.NotificationType.HealthCriticallyLow) then
    local prefix
    if (playerWhoNotified == UnitName("player")) then prefix = "Your"
    else prefix = string.format("%s's", playerWhoNotified) end
    return string.format("%s health is critically low.", prefix)
  end
  if (notificationType == ThhEnum.NotificationType.SpellCastStarted) then
    local spellName, spellRank, spellIcon, spellCastTime, spellMinRange, spellMaxRange = GetSpellInfo(arg1)
    return string.format("%s is casting %s.", playerWhoNotified, spellName)
  end
  if (notificationType == ThhEnum.NotificationType.SpellCastInterrupted) then
    local spellName, spellRank, spellIcon, spellCastTime, spellMinRange, spellMaxRange = GetSpellInfo(arg1)
    return string.format("%s's %s cast has been stopped.", playerWhoNotified, spellName)
  end
  if (notificationType == ThhEnum.NotificationType.SpellCastSucceeded) then
    local spellName, spellRank, spellIcon, spellCastTime, spellMinRange, spellMaxRange = GetSpellInfo(arg1)
    return string.format("%s cast %s.", playerWhoNotified, spellName)
  end

  return nil
end

function NM:ConvertAddonMessageTypeToNotificationType(addonMessageType)
  if (addonMessageType == ThhEnum.AddonMessageType.PlayerDisconnected) then
    return ThhEnum.NotificationType.PlayerDisconnected
  end
  if (addonMessageType == ThhEnum.AddonMessageType.EnteredCombat) then
    return ThhEnum.NotificationType.EnteredCombat
  end
  if (addonMessageType == ThhEnum.AddonMessageType.LoggingOut) then
    return ThhEnum.NotificationType.LoggingOut
  end
  if (addonMessageType == ThhEnum.AddonMessageType.LogoutCancelled) then
    return ThhEnum.NotificationType.LogoutCancelled
  end
  if (addonMessageType == ThhEnum.AddonMessageType.HealthLow) then
    return ThhEnum.NotificationType.HealthLow
  end
  if (addonMessageType == ThhEnum.AddonMessageType.HealthCriticallyLow) then
    return ThhEnum.NotificationType.HealthCriticallyLow
  end
  if (addonMessageType == ThhEnum.AddonMessageType.SpellCastStarted) then
    return ThhEnum.NotificationType.SpellCastStarted
  end
  if (addonMessageType == ThhEnum.AddonMessageType.SpellCastInterrupted) then
    return ThhEnum.NotificationType.SpellCastInterrupted
  end
  if (addonMessageType == ThhEnum.AddonMessageType.SpellCastSucceeded) then
    return ThhEnum.NotificationType.SpellCastSucceeded
  end

  return nil
end