TollskisHardcoreHelper_OptionWindow = CreateFrame("Frame", "TollskisHardcoreHelper Options", UIParent)

function TollskisHardcoreHelper_OptionWindow:Initialize()
  self.Header = self:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  self.Header:SetPoint("TOPLEFT", 10, -10)
  self.Header:SetText("TollskisHardcoreHelper Options")
  
  local yPos = -50

  self.cbEnableLowHealthAlerts = CreateFrame("CheckButton", nil, self, "UICheckButtonTemplate") 
  self.cbEnableLowHealthAlerts:SetPoint("LEFT", self, "TOPLEFT", 10, yPos)
  self.fsEnableLowHealthAlerts = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsEnableLowHealthAlerts:SetPoint("LEFT", self, "TOPLEFT", 40, yPos)
  self.fsEnableLowHealthAlerts:SetText("Enable Low Health Alerts")
  yPos = yPos - 30

  self.cbEnableLowHealthAlertChatMessages = CreateFrame("CheckButton", nil, self, "UICheckButtonTemplate") 
  self.cbEnableLowHealthAlertChatMessages:SetPoint("LEFT", self, "TOPLEFT", 30, yPos)
  self.fsEnableLowHealthAlertChatMessages = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsEnableLowHealthAlertChatMessages:SetPoint("LEFT", self, "TOPLEFT", 60, yPos)
  self.fsEnableLowHealthAlertChatMessages:SetText("Enable sending chat messages to your party when your health is critically low.")
  yPos = yPos - 30

  self.cbEnableLowHealthAlertScreenFlashing = CreateFrame("CheckButton", nil, self, "UICheckButtonTemplate") 
  self.cbEnableLowHealthAlertScreenFlashing:SetPoint("LEFT", self, "TOPLEFT", 30, yPos)
  self.fsEnableLowHealthAlertScreenFlashing = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsEnableLowHealthAlertScreenFlashing:SetPoint("LEFT", self, "TOPLEFT", 60, yPos)
  self.fsEnableLowHealthAlertScreenFlashing:SetText("Enable screen flashing when your health is low.")
  yPos = yPos - 30

  self.cbEnableLowHealthAlertSounds = CreateFrame("CheckButton", nil, self, "UICheckButtonTemplate") 
  self.cbEnableLowHealthAlertSounds:SetPoint("LEFT", self, "TOPLEFT", 30, yPos)
  self.fsEnableLowHealthAlertSounds = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsEnableLowHealthAlertSounds:SetPoint("LEFT", self, "TOPLEFT", 60, yPos)
  self.fsEnableLowHealthAlertSounds:SetText("Enable alert sounds when your health is low.")
  yPos = yPos - 30

  self.cbEnableLowHealthAlertTextNotifications = CreateFrame("CheckButton", nil, self, "UICheckButtonTemplate") 
  self.cbEnableLowHealthAlertTextNotifications:SetPoint("LEFT", self, "TOPLEFT", 30, yPos)
  self.fsEnableLowHealthAlertTextNotifications = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsEnableLowHealthAlertTextNotifications:SetPoint("LEFT", self, "TOPLEFT", 60, yPos)
  self.fsEnableLowHealthAlertTextNotifications:SetText("Enable onscreen text notifications when you or a party member has low health.")
  yPos = yPos - 30

  self.cbShowIconsOnRaidFrames = CreateFrame("CheckButton", nil, self, "UICheckButtonTemplate") 
  self.cbShowIconsOnRaidFrames:SetPoint("LEFT", self, "TOPLEFT", 10, yPos)
  self.fsShowIconsOnRaidFrames = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsShowIconsOnRaidFrames:SetPoint("LEFT", self, "TOPLEFT", 40, yPos)
  self.fsShowIconsOnRaidFrames:SetText("Show Icons on Raid Frames")
  yPos = yPos - 30
  
  self:LoadOptions()
end

function TollskisHardcoreHelper_OptionWindow:LoadOptions()
  self.cbEnableLowHealthAlerts:SetChecked(TollskisHardcoreHelper_Settings.Options.EnableLowHealthAlerts)
  self.cbEnableLowHealthAlertChatMessages:SetChecked(TollskisHardcoreHelper_Settings.Options.EnableLowHealthAlertChatMessages)
  self.cbEnableLowHealthAlertScreenFlashing:SetChecked(TollskisHardcoreHelper_Settings.Options.EnableLowHealthAlertScreenFlashing)
  self.cbEnableLowHealthAlertSounds:SetChecked(TollskisHardcoreHelper_Settings.Options.EnableLowHealthAlertSounds)
  self.cbEnableLowHealthAlertTextNotifications:SetChecked(TollskisHardcoreHelper_Settings.Options.EnableLowHealthAlertTextNotifications)
  self.cbShowIconsOnRaidFrames:SetChecked(TollskisHardcoreHelper_Settings.Options.ShowIconsOnRaidFrames)
end

function TollskisHardcoreHelper_OptionWindow:SaveOptions()
  TollskisHardcoreHelper_Settings.Options.EnableLowHealthAlerts = self.cbEnableLowHealthAlerts:GetChecked()
  TollskisHardcoreHelper_Settings.Options.EnableLowHealthAlertChatMessages = self.cbEnableLowHealthAlertChatMessages:GetChecked()
  TollskisHardcoreHelper_Settings.Options.EnableLowHealthAlertScreenFlashing = self.cbEnableLowHealthAlertScreenFlashing:GetChecked()
  TollskisHardcoreHelper_Settings.Options.EnableLowHealthAlertSounds = self.cbEnableLowHealthAlertSounds:GetChecked()
  TollskisHardcoreHelper_Settings.Options.EnableLowHealthAlertTextNotifications = self.cbEnableLowHealthAlertTextNotifications:GetChecked()

  local shouldUpdateRaidFrames = TollskisHardcoreHelper_Settings.Options.ShowIconsOnRaidFrames ~= self.cbShowIconsOnRaidFrames:GetChecked()
  TollskisHardcoreHelper_Settings.Options.ShowIconsOnRaidFrames = self.cbShowIconsOnRaidFrames:GetChecked()
  if (shouldUpdateRaidFrames) then TollskisHardcoreHelper_RaidFramesManager:UpdateRaidFrames() end
end

TollskisHardcoreHelper_OptionWindow.name = "Tollski's Hardcore Helper"
TollskisHardcoreHelper_OptionWindow.cancel = function() TollskisHardcoreHelper_OptionWindow:LoadOptions() end
TollskisHardcoreHelper_OptionWindow.default = function() print("[AutoBiographer] Not implemented.") end
TollskisHardcoreHelper_OptionWindow.okay = function() TollskisHardcoreHelper_OptionWindow:SaveOptions() end
InterfaceOptions_AddCategory(TollskisHardcoreHelper_OptionWindow)
