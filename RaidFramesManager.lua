Safeguard_RaidFramesManager = {
  ARaidFrameUpdateIsQueued = nil,
  LastRaidFramesUpdateTimestamp = nil,
}

local RFM = Safeguard_RaidFramesManager

function RFM:UpdateRaidFrames()
  if (not CompactRaidFrameContainer:IsShown()) then return end

  local now = GetTime()
  if (self.LastRaidFramesUpdateTimestamp and now - self.LastRaidFramesUpdateTimestamp < 1) then
    if (not self.ARaidFrameUpdateIsQueued) then
      C_Timer.After(1 - (now - self.LastRaidFramesUpdateTimestamp), function()
        RFM:UpdateRaidFrames()
      end)
      self.ARaidFrameUpdateIsQueued = true
    end

    return
  end

  self.ARaidFrameUpdateIsQueued = false
  self.LastRaidFramesUpdateTimestamp = now

  -- CompactRaidFrameContainer:ApplyToFrames("normal",
  --   function(frame)
  --     print(frame)
  --   end)
  CompactRaidFrameContainer_ApplyToFrames(CompactRaidFrameContainer, "normal", function(frame) RFM:UpdateRaidFrame(frame) end)
end

function RFM:UpdateRaidFrame(frame)
  if (not frame.unit) then return end

  local guid = UnitGUID(frame.unit)
  if (not guid) then return end

  if (not frame.ThhIconsContainerFrame) then RFM:SetupRaidFrameIcons(frame) end

  if (not Safeguard_PlayerStates[guid] or not Safeguard_Settings.Options.ShowIconsOnRaidFrames) then
    if (frame.ThhIconsContainerFrame.ConnectedIcon:IsShown()) then frame.ThhIconsContainerFrame.ConnectedIcon:Hide() end
    if (frame.ThhIconsContainerFrame.DisconnectedIcon:IsShown()) then frame.ThhIconsContainerFrame.DisconnectedIcon:Hide() end
    if (frame.ThhIconsContainerFrame.InCombatIcon:IsShown()) then frame.ThhIconsContainerFrame.InCombatIcon:Hide() end

    return
  end

  if (not frame.ThhIconsContainerFrame:IsShown()) then frame.ThhIconsContainerFrame:Show() end

  if (not Safeguard_PlayerStates[guid].ConnectionInfo) then
    if (frame.ThhIconsContainerFrame.ConnectedIcon:IsShown()) then frame.ThhIconsContainerFrame.ConnectedIcon:Hide() end
    if (frame.ThhIconsContainerFrame.DisconnectedIcon:IsShown()) then frame.ThhIconsContainerFrame.DisconnectedIcon:Hide() end
  else
    if (Safeguard_PlayerStates[guid].ConnectionInfo.IsConnected) then
      if (not frame.ThhIconsContainerFrame.ConnectedIcon:IsShown()) then frame.ThhIconsContainerFrame.ConnectedIcon:Show() end
      if (frame.ThhIconsContainerFrame.DisconnectedIcon:IsShown()) then frame.ThhIconsContainerFrame.DisconnectedIcon:Hide() end
    else
      if (frame.ThhIconsContainerFrame.ConnectedIcon:IsShown()) then frame.ThhIconsContainerFrame.ConnectedIcon:Hide() end
      if (not frame.ThhIconsContainerFrame.DisconnectedIcon:IsShown()) then frame.ThhIconsContainerFrame.DisconnectedIcon:Show() end
    end
  end

  if (Safeguard_PlayerStates[guid].IsInCombat) then
    if (not frame.ThhIconsContainerFrame.InCombatIcon:IsShown()) then frame.ThhIconsContainerFrame.InCombatIcon:Show() end
  else
    if (frame.ThhIconsContainerFrame.InCombatIcon:IsShown()) then frame.ThhIconsContainerFrame.InCombatIcon:Hide() end
  end
end

function RFM:SetupRaidFrameIcons(frame)
  frame.ThhIconsContainerFrame = CreateFrame("Frame", nil, frame)

  -- ConnectedIcon
  frame.ThhIconsContainerFrame.ConnectedIcon = CreateFrame("Frame", nil, frame, BackdropTemplateMixin and "BackdropTemplate")
  frame.ThhIconsContainerFrame.ConnectedIcon:SetPoint("TOPLEFT", frame, 2, -2)
  frame.ThhIconsContainerFrame.ConnectedIcon:SetSize(6, 6)
  
  frame.ThhIconsContainerFrame.ConnectedIcon.Texture = frame.ThhIconsContainerFrame.ConnectedIcon:CreateTexture()
  frame.ThhIconsContainerFrame.ConnectedIcon.Texture:SetAllPoints()
  frame.ThhIconsContainerFrame.ConnectedIcon.Texture:SetColorTexture(0, 1, 0)

  frame.ThhIconsContainerFrame.ConnectedIcon:SetScript("OnEnter", function(self, button)
    GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
    GameTooltip:ClearAllPoints();
    GameTooltip:SetPoint("TOPRIGHT", frame.ConnectedIcon, "BOTTOMRIGHT", 0, 0)

    GameTooltip:SetText("Connected")
    
    GameTooltip:Show()
  end)

  frame.ThhIconsContainerFrame.ConnectedIcon:SetScript("OnLeave", function(self, button)
    GameTooltip:Hide()
  end)

  --icon:SetFrameLevel(999)
  frame.ThhIconsContainerFrame.ConnectedIcon:Hide()

  -- DisconnectedIcon
  frame.ThhIconsContainerFrame.DisconnectedIcon = CreateFrame("Frame", nil, frame, BackdropTemplateMixin and "BackdropTemplate")
  frame.ThhIconsContainerFrame.DisconnectedIcon:SetPoint("TOPLEFT", frame, 2, -2)
  frame.ThhIconsContainerFrame.DisconnectedIcon:SetSize(6, 6)
  
  frame.ThhIconsContainerFrame.DisconnectedIcon.Texture = frame.ThhIconsContainerFrame.DisconnectedIcon:CreateTexture()
  frame.ThhIconsContainerFrame.DisconnectedIcon.Texture:SetAllPoints()
  frame.ThhIconsContainerFrame.DisconnectedIcon.Texture:SetColorTexture(1, 0, 0)

  frame.ThhIconsContainerFrame.DisconnectedIcon:SetScript("OnEnter", function(self, button)
    GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
    GameTooltip:ClearAllPoints();
    GameTooltip:SetPoint("TOPRIGHT", frame.DisconnectedIcon, "BOTTOMRIGHT", 0, 0)

    GameTooltip:SetText("Disconnected")
    
    GameTooltip:Show()
  end)

  frame.ThhIconsContainerFrame.DisconnectedIcon:SetScript("OnLeave", function(self, button)
    GameTooltip:Hide()
  end)

  --icon:SetFrameLevel(999)
  frame.ThhIconsContainerFrame.DisconnectedIcon:Hide()

  -- InCombatIcon
  frame.ThhIconsContainerFrame.InCombatIcon = CreateFrame("Frame", nil, frame, BackdropTemplateMixin and "BackdropTemplate")
  frame.ThhIconsContainerFrame.InCombatIcon:SetPoint("TOPLEFT", frame, 8, -2)
  frame.ThhIconsContainerFrame.InCombatIcon:SetSize(6, 6)
  frame.ThhIconsContainerFrame.InCombatIcon:SetBackdrop({bgFile = "Interface\\Icons\\ability_warrior_challange"})

  frame.ThhIconsContainerFrame.InCombatIcon:SetScript("OnEnter", function(self, button)
    GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
    GameTooltip:ClearAllPoints();
    GameTooltip:SetPoint("TOPRIGHT", frame.InCombatIcon, "BOTTOMRIGHT", 0, 0)

    GameTooltip:SetText("In Combat")
    
    GameTooltip:Show()
  end)

  frame.ThhIconsContainerFrame.InCombatIcon:SetScript("OnLeave", function(self, button)
    GameTooltip:Hide()
  end)

  --icon:SetFrameLevel(999)
  frame.ThhIconsContainerFrame.InCombatIcon:Hide()
end


