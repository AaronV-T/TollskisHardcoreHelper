TollskisHardcoreHelper_OptionWindow = CreateFrame("Frame", "TollskisHardcoreHelper Options", UIParent)

function TollskisHardcoreHelper_OptionWindow:Initialize()
  self.Header = self:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  self.Header:SetPoint("TOPLEFT", 10, -10)
  self.Header:SetText("TollskisHardcoreHelper Options")
  
  local yPos = -50

  self.cbEnableChatMessages = CreateFrame("CheckButton", nil, self, "UICheckButtonTemplate") 
  self.cbEnableChatMessages:SetPoint("LEFT", self, "TOPLEFT", 10, yPos)
  self.fsEnableChatMessages = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsEnableChatMessages:SetPoint("LEFT", self, "TOPLEFT", 40, yPos)
  self.fsEnableChatMessages:SetText("Enable Chat Messages")
  yPos = yPos - 25

  self.cbEnableChatMessagesLogout = CreateFrame("CheckButton", nil, self, "UICheckButtonTemplate") 
  self.cbEnableChatMessagesLogout:SetPoint("LEFT", self, "TOPLEFT", 30, yPos)
  self.fsEnableChatMessagesLogout = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsEnableChatMessagesLogout:SetPoint("LEFT", self, "TOPLEFT", 60, yPos)
  self.fsEnableChatMessagesLogout:SetText("Send chat messages when you are logging out.")
  yPos = yPos - 25

  self.cbEnableChatMessagesLowHealth = CreateFrame("CheckButton", nil, self, "UICheckButtonTemplate") 
  self.cbEnableChatMessagesLowHealth:SetPoint("LEFT", self, "TOPLEFT", 30, yPos)
  self.fsEnableChatMessagesLowHealth = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsEnableChatMessagesLowHealth:SetPoint("LEFT", self, "TOPLEFT", 60, yPos)
  self.fsEnableChatMessagesLowHealth:SetText("Send chat messages when your health is critically low. (Requires low health alerts to be enabled.)")
  yPos = yPos - 25

  self.cbEnableChatMessagesSpellCasts = CreateFrame("CheckButton", nil, self, "UICheckButtonTemplate") 
  self.cbEnableChatMessagesSpellCasts:SetPoint("LEFT", self, "TOPLEFT", 30, yPos)
  self.fsEnableChatMessagesSpellCasts = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsEnableChatMessagesSpellCasts:SetPoint("LEFT", self, "TOPLEFT", 60, yPos)
  self.fsEnableChatMessagesSpellCasts:SetText("Send chat messages when you cast certain spells (e.g. Hearthstone).")
  yPos = yPos - 25

  self.cbEnableLowHealthAlerts = CreateFrame("CheckButton", nil, self, "UICheckButtonTemplate") 
  self.cbEnableLowHealthAlerts:SetPoint("LEFT", self, "TOPLEFT", 10, yPos)
  self.fsEnableLowHealthAlerts = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsEnableLowHealthAlerts:SetPoint("LEFT", self, "TOPLEFT", 40, yPos)
  self.fsEnableLowHealthAlerts:SetText("Enable Low Health Alerts")
  yPos = yPos - 25

  self.cbEnableLowHealthAlertScreenFlashing = CreateFrame("CheckButton", nil, self, "UICheckButtonTemplate") 
  self.cbEnableLowHealthAlertScreenFlashing:SetPoint("LEFT", self, "TOPLEFT", 30, yPos)
  self.fsEnableLowHealthAlertScreenFlashing = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsEnableLowHealthAlertScreenFlashing:SetPoint("LEFT", self, "TOPLEFT", 60, yPos)
  self.fsEnableLowHealthAlertScreenFlashing:SetText("Enable screen flashing when your health is low.")
  yPos = yPos - 25

  self.cbEnableLowHealthAlertSounds = CreateFrame("CheckButton", nil, self, "UICheckButtonTemplate") 
  self.cbEnableLowHealthAlertSounds:SetPoint("LEFT", self, "TOPLEFT", 30, yPos)
  self.fsEnableLowHealthAlertSounds = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsEnableLowHealthAlertSounds:SetPoint("LEFT", self, "TOPLEFT", 60, yPos)
  self.fsEnableLowHealthAlertSounds:SetText("Enable alert sounds when your health is low.")
  yPos = yPos - 25

  self.fsLowHealthAlertNote = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsLowHealthAlertNote:SetPoint("LEFT", self, "TOPLEFT", 30, yPos)
  self.fsLowHealthAlertNote:SetText("Note: Chat messages and notification settings can be set in their respective sections.")
  yPos = yPos - 25

  self.cbEnableTextNotifications = CreateFrame("CheckButton", nil, self, "UICheckButtonTemplate") 
  self.cbEnableTextNotifications:SetPoint("LEFT", self, "TOPLEFT", 10, yPos)
  self.fsEnableTextNotifications = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsEnableTextNotifications:SetPoint("LEFT", self, "TOPLEFT", 40, yPos)
  self.fsEnableTextNotifications:SetText("Enable Onscreen Text Notifications")
  yPos = yPos - 25

  self.cbEnableTextNotificationsCombatSelf = CreateFrame("CheckButton", nil, self, "UICheckButtonTemplate") 
  self.cbEnableTextNotificationsCombatSelf:SetPoint("LEFT", self, "TOPLEFT", 30, yPos)
  self.fsEnableTextNotificationsCombatSelf = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsEnableTextNotificationsCombatSelf:SetPoint("LEFT", self, "TOPLEFT", 60, yPos)
  self.fsEnableTextNotificationsCombatSelf:SetText("Enable notifications when you enter combat.")
  yPos = yPos - 25

  self.cbEnableTextNotificationsCombatGroup = CreateFrame("CheckButton", nil, self, "UICheckButtonTemplate") 
  self.cbEnableTextNotificationsCombatGroup:SetPoint("LEFT", self, "TOPLEFT", 30, yPos)
  self.fsEnableTextNotificationsCombatGroup = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsEnableTextNotificationsCombatGroup:SetPoint("LEFT", self, "TOPLEFT", 60, yPos)
  self.fsEnableTextNotificationsCombatGroup:SetText("Enable notifications when a party member enters combat.")
  yPos = yPos - 25

  self.cbEnableTextNotificationsConnectionSelf = CreateFrame("CheckButton", nil, self, "UICheckButtonTemplate") 
  self.cbEnableTextNotificationsConnectionSelf:SetPoint("LEFT", self, "TOPLEFT", 30, yPos)
  self.fsEnableTextNotificationsConnectionSelf = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsEnableTextNotificationsConnectionSelf:SetPoint("LEFT", self, "TOPLEFT", 60, yPos)
  self.fsEnableTextNotificationsConnectionSelf:SetText("Enable notifications when you disconnect.")
  yPos = yPos - 25

  self.cbEnableTextNotificationsConnectionGroup = CreateFrame("CheckButton", nil, self, "UICheckButtonTemplate") 
  self.cbEnableTextNotificationsConnectionGroup:SetPoint("LEFT", self, "TOPLEFT", 30, yPos)
  self.fsEnableTextNotificationsConnectionGroup = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsEnableTextNotificationsConnectionGroup:SetPoint("LEFT", self, "TOPLEFT", 60, yPos)
  self.fsEnableTextNotificationsConnectionGroup:SetText("Enable notifications when a party member disconnects or goes offline.")
  yPos = yPos - 25

  self.cbEnableTextNotificationsLogout = CreateFrame("CheckButton", nil, self, "UICheckButtonTemplate") 
  self.cbEnableTextNotificationsLogout:SetPoint("LEFT", self, "TOPLEFT", 30, yPos)
  self.fsEnableTextNotificationsLogout = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsEnableTextNotificationsLogout:SetPoint("LEFT", self, "TOPLEFT", 60, yPos)
  self.fsEnableTextNotificationsLogout:SetText("Enable notifications when a party member is logging out.")
  yPos = yPos - 25

  self.cbEnableTextNotificationsLowHealthSelf = CreateFrame("CheckButton", nil, self, "UICheckButtonTemplate") 
  self.cbEnableTextNotificationsLowHealthSelf:SetPoint("LEFT", self, "TOPLEFT", 30, yPos)
  self.fsEnableTextNotificationsLowHealthSelf = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsEnableTextNotificationsLowHealthSelf:SetPoint("LEFT", self, "TOPLEFT", 60, yPos)
  self.fsEnableTextNotificationsLowHealthSelf:SetText("Enable notifications when you have low health. (Requires low health alerts to be enabled.)")
  yPos = yPos - 25

  self.cbEnableTextNotificationsLowHealthGroup = CreateFrame("CheckButton", nil, self, "UICheckButtonTemplate") 
  self.cbEnableTextNotificationsLowHealthGroup:SetPoint("LEFT", self, "TOPLEFT", 30, yPos)
  self.fsEnableTextNotificationsLowHealthGroup = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsEnableTextNotificationsLowHealthGroup:SetPoint("LEFT", self, "TOPLEFT", 60, yPos)
  self.fsEnableTextNotificationsLowHealthGroup:SetText("Enable notifications when a party member has low health. (Requires low health alerts to be enabled.)")
  yPos = yPos - 25

  self.cbEnableTextNotificationsSpellcasts = CreateFrame("CheckButton", nil, self, "UICheckButtonTemplate") 
  self.cbEnableTextNotificationsSpellcasts:SetPoint("LEFT", self, "TOPLEFT", 30, yPos)
  self.fsEnableTextNotificationsSpellcasts = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsEnableTextNotificationsSpellcasts:SetPoint("LEFT", self, "TOPLEFT", 60, yPos)
  self.fsEnableTextNotificationsSpellcasts:SetText("Enable notifications when a party member casts certain spells (e.g. Hearthstone).")
  yPos = yPos - 25

  self.cbEnableTextNotificationsAurasSelf = CreateFrame("CheckButton", nil, self, "UICheckButtonTemplate") 
  self.cbEnableTextNotificationsAurasSelf:SetPoint("LEFT", self, "TOPLEFT", 30, yPos)
  self.fsEnableTextNotificationsAurasSelf = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsEnableTextNotificationsAurasSelf:SetPoint("LEFT", self, "TOPLEFT", 60, yPos)
  self.fsEnableTextNotificationsAurasSelf:SetText("Enable notifications when you are affected by certain threat-altering effects.")
  yPos = yPos - 25

  self.cbEnableTextNotificationsAurasGroup = CreateFrame("CheckButton", nil, self, "UICheckButtonTemplate") 
  self.cbEnableTextNotificationsAurasGroup:SetPoint("LEFT", self, "TOPLEFT", 30, yPos)
  self.fsEnableTextNotificationsAurasGroup = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsEnableTextNotificationsAurasGroup:SetPoint("LEFT", self, "TOPLEFT", 60, yPos)
  self.fsEnableTextNotificationsAurasGroup:SetText("Enable notifications when nearby players are affected by certain threat-altering effects.")
  yPos = yPos - 25

  self.cbShowIconsOnRaidFrames = CreateFrame("CheckButton", nil, self, "UICheckButtonTemplate") 
  self.cbShowIconsOnRaidFrames:SetPoint("LEFT", self, "TOPLEFT", 10, yPos)
  self.fsShowIconsOnRaidFrames = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsShowIconsOnRaidFrames:SetPoint("LEFT", self, "TOPLEFT", 40, yPos)
  self.fsShowIconsOnRaidFrames:SetText("Show Icons on Raid Frames")
  yPos = yPos - 25
  
  self:LoadOptions()
end

function TollskisHardcoreHelper_OptionWindow:LoadOptions()
  self.cbEnableChatMessages:SetChecked(TollskisHardcoreHelper_Settings.Options.EnableChatMessages)
  self.cbEnableChatMessagesLogout:SetChecked(TollskisHardcoreHelper_Settings.Options.EnableChatMessagesLogout)
  self.cbEnableChatMessagesLowHealth:SetChecked(TollskisHardcoreHelper_Settings.Options.EnableChatMessagesLowHealth)
  self.cbEnableChatMessagesSpellCasts:SetChecked(TollskisHardcoreHelper_Settings.Options.EnableChatMessagesSpellCasts)
  self.cbEnableLowHealthAlerts:SetChecked(TollskisHardcoreHelper_Settings.Options.EnableLowHealthAlerts)
  self.cbEnableLowHealthAlertScreenFlashing:SetChecked(TollskisHardcoreHelper_Settings.Options.EnableLowHealthAlertScreenFlashing)
  self.cbEnableLowHealthAlertSounds:SetChecked(TollskisHardcoreHelper_Settings.Options.EnableLowHealthAlertSounds)
  self.cbEnableTextNotifications:SetChecked(TollskisHardcoreHelper_Settings.Options.EnableTextNotifications)
  self.cbEnableTextNotificationsCombatSelf:SetChecked(TollskisHardcoreHelper_Settings.Options.EnableTextNotificationsCombatSelf)
  self.cbEnableTextNotificationsCombatGroup:SetChecked(TollskisHardcoreHelper_Settings.Options.EnableTextNotificationsCombatGroup)
  self.cbEnableTextNotificationsConnectionSelf:SetChecked(TollskisHardcoreHelper_Settings.Options.EnableTextNotificationsConnectionSelf)
  self.cbEnableTextNotificationsConnectionGroup:SetChecked(TollskisHardcoreHelper_Settings.Options.EnableTextNotificationsConnectionGroup)
  self.cbEnableTextNotificationsLogout:SetChecked(TollskisHardcoreHelper_Settings.Options.EnableTextNotificationsLogout)
  self.cbEnableTextNotificationsLowHealthSelf:SetChecked(TollskisHardcoreHelper_Settings.Options.EnableTextNotificationsLowHealthSelf)
  self.cbEnableTextNotificationsLowHealthGroup:SetChecked(TollskisHardcoreHelper_Settings.Options.EnableTextNotificationsLowHealthGroup)
  self.cbEnableTextNotificationsSpellcasts:SetChecked(TollskisHardcoreHelper_Settings.Options.EnableTextNotificationsSpellcasts)
  self.cbEnableTextNotificationsAurasSelf:SetChecked(TollskisHardcoreHelper_Settings.Options.EnableTextNotificationsAurasSelf)
  self.cbEnableTextNotificationsAurasGroup:SetChecked(TollskisHardcoreHelper_Settings.Options.EnableTextNotificationsAurasGroup)
  self.cbShowIconsOnRaidFrames:SetChecked(TollskisHardcoreHelper_Settings.Options.ShowIconsOnRaidFrames)
end

function TollskisHardcoreHelper_OptionWindow:SaveOptions()
  TollskisHardcoreHelper_Settings.Options.EnableChatMessages = self.cbEnableChatMessages:GetChecked()
  TollskisHardcoreHelper_Settings.Options.EnableChatMessagesLogout = self.cbEnableChatMessagesLogout:GetChecked()
  TollskisHardcoreHelper_Settings.Options.EnableChatMessagesLowHealth = self.cbEnableChatMessagesLowHealth:GetChecked()
  TollskisHardcoreHelper_Settings.Options.EnableChatMessagesSpellCasts = self.cbEnableChatMessagesSpellCasts:GetChecked()
  TollskisHardcoreHelper_Settings.Options.EnableLowHealthAlerts = self.cbEnableLowHealthAlerts:GetChecked()
  TollskisHardcoreHelper_Settings.Options.EnableLowHealthAlertScreenFlashing = self.cbEnableLowHealthAlertScreenFlashing:GetChecked()
  TollskisHardcoreHelper_Settings.Options.EnableLowHealthAlertSounds = self.cbEnableLowHealthAlertSounds:GetChecked()
  TollskisHardcoreHelper_Settings.Options.EnableTextNotifications = self.cbEnableTextNotifications:GetChecked()
  TollskisHardcoreHelper_Settings.Options.EnableTextNotificationsCombatSelf = self.cbEnableTextNotificationsCombatSelf:GetChecked()
  TollskisHardcoreHelper_Settings.Options.EnableTextNotificationsCombatGroup = self.cbEnableTextNotificationsCombatGroup:GetChecked()
  TollskisHardcoreHelper_Settings.Options.EnableTextNotificationsConnectionSelf = self.cbEnableTextNotificationsConnectionSelf:GetChecked()
  TollskisHardcoreHelper_Settings.Options.EnableTextNotificationsConnectionGroup = self.cbEnableTextNotificationsConnectionGroup:GetChecked()
  TollskisHardcoreHelper_Settings.Options.EnableTextNotificationsLogout = self.cbEnableTextNotificationsLogout:GetChecked()
  TollskisHardcoreHelper_Settings.Options.EnableTextNotificationsLowHealthSelf = self.cbEnableTextNotificationsLowHealthSelf:GetChecked()
  TollskisHardcoreHelper_Settings.Options.EnableTextNotificationsLowHealthGroup = self.cbEnableTextNotificationsLowHealthGroup:GetChecked()
  TollskisHardcoreHelper_Settings.Options.EnableTextNotificationsSpellcasts = self.cbEnableTextNotificationsSpellcasts:GetChecked()
  TollskisHardcoreHelper_Settings.Options.EnableTextNotificationsAurasSelf = self.cbEnableTextNotificationsAurasSelf:GetChecked()
  TollskisHardcoreHelper_Settings.Options.EnableTextNotificationsAurasGroup = self.cbEnableTextNotificationsAurasGroup:GetChecked()

  local shouldUpdateRaidFrames = TollskisHardcoreHelper_Settings.Options.ShowIconsOnRaidFrames ~= self.cbShowIconsOnRaidFrames:GetChecked()
  TollskisHardcoreHelper_Settings.Options.ShowIconsOnRaidFrames = self.cbShowIconsOnRaidFrames:GetChecked()
  if (shouldUpdateRaidFrames) then TollskisHardcoreHelper_RaidFramesManager:UpdateRaidFrames() end
end

TollskisHardcoreHelper_OptionWindow.name = "Tollski's Hardcore Helper"
TollskisHardcoreHelper_OptionWindow.cancel = function() TollskisHardcoreHelper_OptionWindow:LoadOptions() end
TollskisHardcoreHelper_OptionWindow.default = function() print("[AutoBiographer] Not implemented.") end
TollskisHardcoreHelper_OptionWindow.okay = function() TollskisHardcoreHelper_OptionWindow:SaveOptions() end
InterfaceOptions_AddCategory(TollskisHardcoreHelper_OptionWindow)
