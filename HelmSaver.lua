local addonName, addon = ...
addon.evt = CreateFrame("Frame")
addon.OnEvents = function(self, event, ...)
  return addon[event] and addon[event](addon,...)
end
addon.evt:SetScript("OnEvent",addon.OnEvents)
addon.evt:RegisterEvent("ADDON_LOADED")

function addon.Update()
  local helm = addon.hcb:GetChecked()
  local cloak = addon.ccb:GetChecked()
  ShowHelm(helm)
  ShowCloak(cloak)
end

local HelmSaverDB
function addon:ADDON_LOADED(...)
  if ... ~= addonName then return end

  HelmSaverDB_Character = HelmSaverDB_Character or {}
  HelmSaverDB = HelmSaverDB_Character


  local OnCheckBoxClick = function()
    addon.Update()
    if (PaperDollFrame.EquipmentManagerPane:IsShown() and (PaperDollFrame.EquipmentManagerPane.selectedSetID or GearManagerPopupFrame:IsShown())) then
      PaperDollFrameSaveSet:Enable()
      PaperDollFrameEquipSet:Enable();
    end
  end

  local hcb = CreateFrame("CheckButton",nil,CharacterHeadSlot,"UICheckButtonTemplate") -- CharacterHeadSlotPopoutButton to only show on EM screen
  hcb:SetWidth(26); hcb:SetHeight(26);
  hcb:SetPoint("RIGHT",CharacterHeadSlotPopoutButton,"LEFT",-13,0)
  hcb:SetScript("OnClick",OnCheckBoxClick)
  hcb:SetChecked(ShowingHelm())
  addon.hcb = hcb

  local ccb = CreateFrame("CheckButton",nil,CharacterBackSlot,"UICheckButtonTemplate")
  ccb:SetWidth(26); ccb:SetHeight(26);
  ccb:SetPoint("RIGHT",CharacterBackSlotPopoutButton,"LEFT",-13,0)
  ccb:SetScript("OnClick",OnCheckBoxClick)
  ccb:SetChecked(ShowingCloak())
  addon.ccb = ccb

  PaperDollFrame:HookScript("OnShow",function(self,btn)
    hcb:SetChecked(ShowingHelm())
    ccb:SetChecked(ShowingCloak())
  end)


  hooksecurefunc("GearSetButton_OnClick",function(self,btn)
    PaperDollFrameEquipSet:Enable();
  end)

  hooksecurefunc(C_EquipmentSet, "UseEquipmentSet", function(name)
    if HelmSaverDB[name] and not InCombatLockdown() then
      hcb:SetChecked(HelmSaverDB[name]["helm"])
      ccb:SetChecked(HelmSaverDB[name]["cloak"])
      addon.Update()
    end
  end)

  hooksecurefunc(C_EquipmentSet, "SaveEquipmentSet", function(name,icon)
    HelmSaverDB[name] = HelmSaverDB[name] or {}
    HelmSaverDB[name]["helm"] = hcb:GetChecked()
    HelmSaverDB[name]["cloak"] = ccb:GetChecked()
  end)

  hooksecurefunc(C_EquipmentSet, "DeleteEquipmentSet", function(name)
    HelmSaverDB[name] = nil
  end)
  
end