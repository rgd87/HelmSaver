HelmSaver = CreateFrame("Frame","HelmSaver")

HelmSaver:SetScript("OnEvent", function(self, event, ...)
	self[event](self, event, ...)
end)
HelmSaver:RegisterEvent("ADDON_LOADED")

function HelmSaver.Update()
    local helm = HelmSaver.hcb:GetChecked()
    local cloak = HelmSaver.ccb:GetChecked()
    ShowHelm(helm)
    ShowCloak(cloak)
end

local HelmSaverDB
function HelmSaver.ADDON_LOADED(self,event,arg1)
    if arg1 ~= "HelmSaver" then return end
    
    HelmSaverDB_Character = HelmSaverDB_Character or {}
    HelmSaverDB = HelmSaverDB_Character
    
    
    local OnCheckBoxClick = function()
        HelmSaver.Update()
        if PaperDollEquipmentManagerPane.selectedSetName then
            PaperDollEquipmentManagerPaneSaveSet:Enable()
            PaperDollEquipmentManagerPaneEquipSet:Enable();
        end
    end
    
    local hcb = CreateFrame("CheckButton",nil,CharacterHeadSlot,"UICheckButtonTemplate") -- CharacterHeadSlotPopoutButton to only show on EM screen
    hcb:SetWidth(26); hcb:SetHeight(26);
    hcb:SetPoint("RIGHT",CharacterHeadSlotPopoutButton,"LEFT",-13,0)
    hcb:SetScript("OnClick",OnCheckBoxClick)
    hcb:SetChecked(ShowingHelm())
    HelmSaver.hcb = hcb
    
    local ccb = CreateFrame("CheckButton",nil,CharacterBackSlot,"UICheckButtonTemplate")
    ccb:SetWidth(26); ccb:SetHeight(26);
    ccb:SetPoint("RIGHT",CharacterBackSlotPopoutButton,"LEFT",-13,0)
    ccb:SetScript("OnClick",OnCheckBoxClick)
    ccb:SetChecked(ShowingCloak())
    HelmSaver.ccb = ccb

    PaperDollFrame:HookScript("OnShow",function(self,btn)
        hcb:SetChecked(ShowingHelm())
        ccb:SetChecked(ShowingCloak())
    end)

    
    hooksecurefunc("GearSetButton_OnClick",function(self,btn)
        PaperDollEquipmentManagerPaneEquipSet:Enable();
    end)
    
    hooksecurefunc("UseEquipmentSet", function(name)
        if HelmSaverDB[name] and not InCombatLockdown() then
            hcb:SetChecked(HelmSaverDB[name]["helm"])
            ccb:SetChecked(HelmSaverDB[name]["cloak"])
            HelmSaver.Update()
        end
    end)
    
    hooksecurefunc("SaveEquipmentSet", function(name,icon)
        HelmSaverDB[name] = HelmSaverDB[name] or {}
        HelmSaverDB[name]["helm"] = hcb:GetChecked()
        HelmSaverDB[name]["cloak"] = ccb:GetChecked()
    end)
    
    hooksecurefunc("DeleteEquipmentSet", function(name)
        HelmSaverDB[name] = nil
    end)
    
end