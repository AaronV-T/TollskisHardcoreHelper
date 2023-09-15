TollskisHardcoreHelper_FlashFrame = CreateFrame("Frame", nil, UIParent) -- ,"SecureHandlerStateTemplate")

local flashFrame = TollskisHardcoreHelper_FlashFrame

flashFrame:Hide()
flashFrame:SetAllPoints()
flashFrame:SetAlpha(0)
flashFrame:SetFrameStrata("FULLSCREEN_DIALOG")

flashFrame.Texture = flashFrame:CreateTexture()
flashFrame.Texture:SetAllPoints()
flashFrame.Texture:SetBlendMode("ADD")
flashFrame.Texture:SetTexture("Interface\\FullScreenTextures\\LowHealth")

--flashFrame.Texture:SetVertexColor(0, 0, 1)
--flashFrame.Texture:SetGradient("VERTICAL", CreateColor(1, 1, 0, 1), CreateColor(1, 1, 0, 1))
--flashFrame.Texture:SetColorTexture(1, 1, 0)
--flashFrame.Texture:SetDesaturated(true)

flashFrame:SetScript('OnUpdate', function(self)
  if (not self.LoopStartTimestamp or not self.LoopsRemaining) then return end

  local timeSinceLoopStarted = GetTime() - self.LoopStartTimestamp
  
  local phaseDuration = self.LoopDuration / 3
  local da = 1 / phaseDuration * self.MaxOpacity

  local alpha = 0 
  if (timeSinceLoopStarted <= phaseDuration) then
    alpha = timeSinceLoopStarted * da
  elseif (timeSinceLoopStarted <= phaseDuration * 2) then
    alpha = self.MaxOpacity
  elseif (timeSinceLoopStarted <= phaseDuration * 3) then
    alpha = self.MaxOpacity - (timeSinceLoopStarted - (phaseDuration * 2)) * da
  end

  flashFrame:SetAlpha(alpha)

  if (alpha > 0) then return end
  
  self.LoopsRemaining = self.LoopsRemaining - 1
  if (self.LoopsRemaining == 0) then
    self:StopAnimation()
  else
    self.LoopStartTimestamp = GetTime()
  end
end)

function flashFrame:PlayAnimation(loops, loopDuration, maxOpacity)
  self.LoopDuration = loopDuration
  self.MaxOpacity = maxOpacity

  if (self.LoopsRemaining) then
    self.LoopsRemaining = loops + 1
  else
    self.LoopStartTimestamp = GetTime()
    self.LoopsRemaining = loops
  end

  self:Show()
end

function flashFrame:StopAnimation()
  self.LoopDuration = nil
  self.LoopStartTimestamp = nil
  self.LoopsRemaining = nil
  self.MaxOpacity = nil
  self:Hide()
end