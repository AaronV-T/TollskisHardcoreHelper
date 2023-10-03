TollskisHardcoreHelper_NotificationManager = {
  ShownNotificationTimestamps = {},
}

local NM = TollskisHardcoreHelper_NotificationManager

function NM:ShowNotificationToPlayer(playerWhoNotified, notificationType, arg1)
  local notification = self:GetNotification(playerWhoNotified, notificationType, arg1)
  if (not notification) then
    print("[THH] No notification for notification type " .. tostring(notificationType))
    return
  end

  local notificationKey = nil
  if (arg1 ~= nil) then
    notificationKey = string.format("%s!%d!%s", playerWhoNotified, notificationType, arg1)
  else
    notificationKey = string.format("%s!%d", playerWhoNotified, notificationType)
  end

  local nowTimestamp = GetTime()
  if (self.ShownNotificationTimestamps[notificationKey] and nowTimestamp - self.ShownNotificationTimestamps[notificationKey] < 1) then return end
  self.ShownNotificationTimestamps[notificationKey] = nowTimestamp

  local r = 1.000
  local g = 1.000
  local b = 1.000
  UIErrorsFrame:AddMessage(notification, r, g, b)
  print("[THH] " .. notification)
  table.insert(TollskisHardcoreHelper_EventManager.DebugLogs, string.format("%d - Notification: %s", time(), notification))
end

function NM:GetNotification(playerWhoNotified, notificationType, arg1)
  if (notificationType == ThhEnum.NotificationType.PlayerDisconnected) then
    return string.format("%s has disconnected.", UnitHelperFunctions.FindUnitNameByUnitGuid(arg1))
  end
  if (notificationType == ThhEnum.NotificationType.PlayerReconnected) then
    return string.format("%s has reconnected.", UnitHelperFunctions.FindUnitNameByUnitGuid(arg1))
  end
  if (notificationType == ThhEnum.NotificationType.PlayerOffline) then
    return string.format("%s has gone offline.", UnitHelperFunctions.FindUnitNameByUnitGuid(arg1))
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
    return string.format("%s is casting %s.", playerWhoNotified, arg1)
  end
  if (notificationType == ThhEnum.NotificationType.SpellCastInterrupted) then
    return string.format("%s's %s cast has been stopped.", playerWhoNotified, arg1)
  end
  if (notificationType == ThhEnum.NotificationType.AuraApplied) then
    local prefix
    if (playerWhoNotified == UnitName("player")) then prefix = "You are"
    else prefix = string.format("%s is", playerWhoNotified) end
    return string.format("%s affected by %s.", prefix, arg1)
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

  return nil
end