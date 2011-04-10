NugEMExt = CreateFrame("Frame","NugEMExt")

NugEMExt:SetScript("OnEvent", function(self, event, ...)
	self[event](self, event, ...)
end)
NugEMExt:RegisterEvent("ADDON_LOADED")

function NugEMExt.Update()
    local helm = NugEMExt.hcb:GetChecked()
    local cloak = NugEMExt.ccb:GetChecked()
    ShowHelm(helm)
    ShowCloak(cloak)
end

local NugEMExtDB
function NugEMExt.ADDON_LOADED(self,event,arg1)
    if arg1 ~= "NugEMExt" then return end
    
    NugEMExtDB_Character = NugEMExtDB_Character or {}
    NugEMExtDB = NugEMExtDB_Character
    
    
    local OnCheckBoxClick = function()
        NugEMExt.Update()
        if PaperDollEquipmentManagerPane.selectedSetName then
            PaperDollEquipmentManagerPaneSaveSet:Enable()
            PaperDollEquipmentManagerPaneEquipSet:Enable();
        end
    end
    
    local hcb = CreateFrame("CheckButton",nil,CharacterHeadSlotPopoutButton,"UICheckButtonTemplate")
    hcb:SetWidth(26); hcb:SetHeight(26);
    hcb:SetPoint("RIGHT",CharacterHeadSlotPopoutButton,"LEFT",-13,0)
    hcb:SetScript("OnClick",OnCheckBoxClick)
    hcb:SetChecked(ShowingHelm())
    NugEMExt.hcb = hcb
    
    local ccb = CreateFrame("CheckButton",nil,CharacterBackSlotPopoutButton,"UICheckButtonTemplate")
    ccb:SetWidth(26); ccb:SetHeight(26);
    ccb:SetPoint("RIGHT",CharacterBackSlotPopoutButton,"LEFT",-13,0)
    ccb:SetScript("OnClick",OnCheckBoxClick)
    ccb:SetChecked(ShowingCloak())
    NugEMExt.ccb = ccb
    
    hooksecurefunc("GearSetButton_OnClick",function(self,btn)
        PaperDollEquipmentManagerPaneEquipSet:Enable();
    end)
    
    hooksecurefunc("UseEquipmentSet", function(name)
        if NugEMExtDB[name] then
            hcb:SetChecked(NugEMExtDB[name]["helm"])
            ccb:SetChecked(NugEMExtDB[name]["cloak"])
            NugEMExt.Update()
        end
    end)
    
    hooksecurefunc("SaveEquipmentSet", function(name,icon)
        NugEMExtDB[name] = NugEMExtDB[name] or {}
        NugEMExtDB[name]["helm"] = hcb:GetChecked()
        NugEMExtDB[name]["cloak"] = ccb:GetChecked()
    end)
    
    hooksecurefunc("DeleteEquipmentSet", function(name)
        NugEMExtDB[name] = nil
    end)
    
end