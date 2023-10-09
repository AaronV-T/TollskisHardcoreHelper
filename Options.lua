Safeguard_OptionWindow = CreateFrame("Frame", "Safeguard Options", UIParent)

function Safeguard_OptionWindow:Initialize()
  self.Header = self:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  self.Header:SetPoint("TOPLEFT", 10, -10)
  self.Header:SetText("Safeguard Options")
  
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

function Safeguard_OptionWindow:LoadOptions()
  self.cbEnableChatMessages:SetChecked(Safeguard_Settings.Options.EnableChatMessages)
  self.cbEnableChatMessagesLogout:SetChecked(Safeguard_Settings.Options.EnableChatMessagesLogout)
  self.cbEnableChatMessagesLowHealth:SetChecked(Safeguard_Settings.Options.EnableChatMessagesLowHealth)
  self.cbEnableChatMessagesSpellCasts:SetChecked(Safeguard_Settings.Options.EnableChatMessagesSpellCasts)
  self.cbEnableLowHealthAlerts:SetChecked(Safeguard_Settings.Options.EnableLowHealthAlerts)
  self.cbEnableLowHealthAlertScreenFlashing:SetChecked(Safeguard_Settings.Options.EnableLowHealthAlertScreenFlashing)
  self.cbEnableLowHealthAlertSounds:SetChecked(Safeguard_Settings.Options.EnableLowHealthAlertSounds)
  self.cbEnableTextNotifications:SetChecked(Safeguard_Settings.Options.EnableTextNotifications)
  self.cbEnableTextNotificationsCombatSelf:SetChecked(Safeguard_Settings.Options.EnableTextNotificationsCombatSelf)
  self.cbEnableTextNotificationsCombatGroup:SetChecked(Safeguard_Settings.Options.EnableTextNotificationsCombatGroup)
  self.cbEnableTextNotificationsConnectionSelf:SetChecked(Safeguard_Settings.Options.EnableTextNotificationsConnectionSelf)
  self.cbEnableTextNotificationsConnectionGroup:SetChecked(Safeguard_Settings.Options.EnableTextNotificationsConnectionGroup)
  self.cbEnableTextNotificationsLogout:SetChecked(Safeguard_Settings.Options.EnableTextNotificationsLogout)
  self.cbEnableTextNotificationsLowHealthSelf:SetChecked(Safeguard_Settings.Options.EnableTextNotificationsLowHealthSelf)
  self.cbEnableTextNotificationsLowHealthGroup:SetChecked(Safeguard_Settings.Options.EnableTextNotificationsLowHealthGroup)
  self.cbEnableTextNotificationsSpellcasts:SetChecked(Safeguard_Settings.Options.EnableTextNotificationsSpellcasts)
  self.cbEnableTextNotificationsAurasSelf:SetChecked(Safeguard_Settings.Options.EnableTextNotificationsAurasSelf)
  self.cbEnableTextNotificationsAurasGroup:SetChecked(Safeguard_Settings.Options.EnableTextNotificationsAurasGroup)
  self.cbShowIconsOnRaidFrames:SetChecked(Safeguard_Settings.Options.ShowIconsOnRaidFrames)
end

function Safeguard_OptionWindow:SaveOptions()
  Safeguard_Settings.Options.EnableChatMessages = self.cbEnableChatMessages:GetChecked()
  Safeguard_Settings.Options.EnableChatMessagesLogout = self.cbEnableChatMessagesLogout:GetChecked()
  Safeguard_Settings.Options.EnableChatMessagesLowHealth = self.cbEnableChatMessagesLowHealth:GetChecked()
  Safeguard_Settings.Options.EnableChatMessagesSpellCasts = self.cbEnableChatMessagesSpellCasts:GetChecked()
  Safeguard_Settings.Options.EnableLowHealthAlerts = self.cbEnableLowHealthAlerts:GetChecked()
  Safeguard_Settings.Options.EnableLowHealthAlertScreenFlashing = self.cbEnableLowHealthAlertScreenFlashing:GetChecked()
  Safeguard_Settings.Options.EnableLowHealthAlertSounds = self.cbEnableLowHealthAlertSounds:GetChecked()
  Safeguard_Settings.Options.EnableTextNotifications = self.cbEnableTextNotifications:GetChecked()
  Safeguard_Settings.Options.EnableTextNotificationsCombatSelf = self.cbEnableTextNotificationsCombatSelf:GetChecked()
  Safeguard_Settings.Options.EnableTextNotificationsCombatGroup = self.cbEnableTextNotificationsCombatGroup:GetChecked()
  Safeguard_Settings.Options.EnableTextNotificationsConnectionSelf = self.cbEnableTextNotificationsConnectionSelf:GetChecked()
  Safeguard_Settings.Options.EnableTextNotificationsConnectionGroup = self.cbEnableTextNotificationsConnectionGroup:GetChecked()
  Safeguard_Settings.Options.EnableTextNotificationsLogout = self.cbEnableTextNotificationsLogout:GetChecked()
  Safeguard_Settings.Options.EnableTextNotificationsLowHealthSelf = self.cbEnableTextNotificationsLowHealthSelf:GetChecked()
  Safeguard_Settings.Options.EnableTextNotificationsLowHealthGroup = self.cbEnableTextNotificationsLowHealthGroup:GetChecked()
  Safeguard_Settings.Options.EnableTextNotificationsSpellcasts = self.cbEnableTextNotificationsSpellcasts:GetChecked()
  Safeguard_Settings.Options.EnableTextNotificationsAurasSelf = self.cbEnableTextNotificationsAurasSelf:GetChecked()
  Safeguard_Settings.Options.EnableTextNotificationsAurasGroup = self.cbEnableTextNotificationsAurasGroup:GetChecked()

  local shouldUpdateRaidFrames = Safeguard_Settings.Options.ShowIconsOnRaidFrames ~= self.cbShowIconsOnRaidFrames:GetChecked()
  Safeguard_Settings.Options.ShowIconsOnRaidFrames = self.cbShowIconsOnRaidFrames:GetChecked()
  if (shouldUpdateRaidFrames) then Safeguard_RaidFramesManager:UpdateRaidFrames() end
end

Safeguard_OptionWindow.name = "Safeguard"
Safeguard_OptionWindow.cancel = function() Safeguard_OptionWindow:LoadOptions() end
Safeguard_OptionWindow.default = function() print("[AutoBiographer] Not implemented.") end
Safeguard_OptionWindow.okay = function() Safeguard_OptionWindow:SaveOptions() end
InterfaceOptions_AddCategory(Safeguard_OptionWindow)
