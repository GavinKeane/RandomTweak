local typeface = "Fonts\\FRIZQT__.ttf"
local style = "OUTLINE"
local RHAPSODY_SPELLID = 390636
local ANSWERED_PRAYERS_SPELLID = 394289
local DOT_CHAR_VALUE = 226

local function UpdateHotkeyText(button)
    local hotkey = _G[button:GetName().."HotKey"]
    if hotkey then
        local text = hotkey:GetText()
        if text then
            text = text:gsub("s%-", "S")
            text = text:gsub("c%-", "C")
            text = text:gsub("a%-", "A")
            text = text:gsub("`", "~")
            text = text:gsub("Mouse Button ", "MB")
            hotkey:SetText(text)
            hotkey:SetFont(typeface, 16, style)
            hotkey:SetTextColor(1, 1, 1)
        end
        if string.byte(text) == DOT_CHAR_VALUE then
            hotkey:SetText("@")
        end
    end
end

local function UpdateCountText(button)
    button.Count:SetFont(typeface, 16, style)
    button.Count:SetJustifyH("RIGHT")
    button.Count:SetJustifyV("BOTTOM")
    button.Count:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -4, 3)
end

local function ShowApplications(button, rhapsody, answered_prayers)
    if button then
        if button.action then
            actionType, id, _ = GetActionInfo(button.action);
            if actionType == "spell" then
                if C_Spell.GetSpellName(id) == "Holy Nova" then
                    if rhapsody > 0 then
                        button.Count:SetText(rhapsody)
                    else
                        button.Count:SetText("");
                    end
                end
                --[[
                if C_Spell.GetSpellName(id) == "Apotheosis" then
                    if answered_prayers > 0 then
                        button.Count:SetText(50 - answered_prayers)
                    else
                        button.Count:SetText(50)
                    end
                end
                ]]--
            end
        end
    end
end

local function HotkeyFix()
    for _, p in ipairs({"Left", "Right", "BottomLeft", "BottomRight", "5", "6", "7"}) do
        for i = 1, 12 do
            local button = _G["MultiBar"..p.."Button"..i]
            if button then
                UpdateHotkeyText(button)
            end
        end
    end
    for i = 1, 12 do
        local button = _G["ActionButton"..i]
        if button then
            UpdateHotkeyText(button)
        end
    end
end

local function CountFix()
    for _, p in ipairs({"Left", "Right", "BottomLeft", "BottomRight", "5", "6", "7"}) do
        for i = 1, 12 do
            local button = _G["MultiBar"..p.."Button"..i]
            if button then
                UpdateCountText(button)
            end
        end
    end
    for i = 1, 12 do
        local button = _G["ActionButton"..i]
        if button then
            UpdateCountText(button)
        end
    end
end

local function CountApplications()
    rhapsody = 0
    answered_prayers = 0
    rhap_aura = C_UnitAuras.GetPlayerAuraBySpellID(RHAPSODY_SPELLID)
    answered_aura = C_UnitAuras.GetPlayerAuraBySpellID(ANSWERED_PRAYERS_SPELLID)
    if rhap_aura then
        rhapsody = rhap_aura.applications
    end
    if answered_aura then
        answered_prayers = answered_aura.applications
    end
    for _, p in ipairs({"Left", "Right", "BottomLeft", "BottomRight", "5", "6", "7"}) do
        for i = 1, 12 do
            local button = _G["MultiBar"..p.."Button"..i]
            if button then
                ShowApplications(button, rhapsody, answered_prayers)
            end
        end
    end
    for i = 1, 12 do
        local button = _G["ActionButton"..i]
        if button then
            ShowApplications(button,rhapsody, answered_prayers)
        end
    end
end

--[[
TargetFrame:UnregisterEvent("UNIT_AURA")
FocusFrame:UnregisterEvent("UNIT_AURA")
local function ReleaseAllAuras(self)
    for obj in self.auraPools:EnumerateActive() do
        obj:Hide()
    end
    self.auraPools:ReleaseAll()
    self.auraRows, self.spellbarAnchor = 0, nil
    if self.spellbar then
        hooksecurefunc(self.spellbar, "SetPoint", function(spellBar, _, _, _, _, _, shouldIgnore)
            if not shouldIgnore then
                spellBar:ClearAllPoints()
                spellBar:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 43, -100, true)
            end
        end)
    end
end
hooksecurefunc(TargetFrame, "UpdateAuras", ReleaseAllAuras)
hooksecurefunc(FocusFrame, "UpdateAuras", ReleaseAllAuras)
]]--


local f1 = CreateFrame("Frame")
f1:RegisterEvent("PLAYER_ENTERING_WORLD")
f1:RegisterEvent("PLAYER_LOGIN")
f1:RegisterEvent("EDIT_MODE_LAYOUTS_UPDATED")
f1:SetScript("OnEvent", HotkeyFix)

local f2 = CreateFrame("Frame")
f2:RegisterEvent("PLAYER_ENTERING_WORLD")
f2:RegisterEvent("PLAYER_LOGIN")
f2:RegisterEvent("EDIT_MODE_LAYOUTS_UPDATED")
f2:SetScript("OnEvent", CountFix)

local f3 = CreateFrame("Frame")
f3:RegisterEvent("UNIT_AURA")
f3:RegisterEvent("PLAYER_ENTERING_WORLD")
f3:RegisterEvent("PLAYER_LOGIN")
f3:SetScript("OnEvent", CountApplications)