TollskisHardcoreHelper_RaidFramesManager = {}

local RFM = TollskisHardcoreHelper_RaidFramesManager

function RFM:UpdateRaidFrames()
  if (not CompactRaidFrameContainer:IsShown()) then return end
  
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

  if (not TollskisHardcoreHelper_PlayerStates[guid]) then
    frame.ThhIconsContainerFrame:Hide()
    return
  end

  if (not frame.ThhIconsContainerFrame:IsShown()) then frame.ThhIconsContainerFrame:Show() end

  if (TollskisHardcoreHelper_PlayerStates[guid].IsInCombat) then
    if (not frame.ThhIconsContainerFrame.InCombatIcon:IsShown()) then frame.ThhIconsContainerFrame.InCombatIcon:Show() end
  else
    if (frame.ThhIconsContainerFrame.InCombatIcon:IsShown()) then frame.ThhIconsContainerFrame.InCombatIcon:Hide() end
  end
end

function RFM:SetupRaidFrameIcons(frame)
  frame.ThhIconsContainerFrame = CreateFrame("Frame", nil, frame)

  frame.ThhIconsContainerFrame.InCombatIcon = CreateFrame("Frame", nil, frame, BackdropTemplateMixin and "BackdropTemplate")
  frame.ThhIconsContainerFrame.InCombatIcon:SetPoint("TOPLEFT", frame, 2, -2)
  frame.ThhIconsContainerFrame.InCombatIcon:SetSize(8, 8)
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


