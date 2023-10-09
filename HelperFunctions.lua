Safeguard_HelperFunctions = {}

local HF = Safeguard_HelperFunctions

function HF.BoolToNumber(bool)
  return bool and 1 or 0
end

function HF.NumberToBool(number)
  if (number == 0) then
    return false
  elseif (number == 1) 
    then return true
  else
    return nil
  end
end