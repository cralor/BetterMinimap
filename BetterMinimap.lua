
local bm = CreateFrame("frame")
bm:RegisterEvent("PLAYER_ENTERING_WORLD")

-- START OF SETTINGS
local MOUSEOVER = false --Change to 'true' if you want the minimap zone text to show only on mouseover
local BUTTONS = true --Will hide select minimap buttons (see below) if set to 'true'
local MM_SCALE = 1.1 --Scale of minimap
local HNS = true --Hide "N" (north) symbol?
-- END OF SETTINGS

local function onEvent(self, event, ...)
    local minimapShape

    if MOUSEOVER == true then
        Minimap:SetScript("OnEnter", function() MinimapZoneTextButton:Show() end)
        Minimap:SetScript("OnLeave", function() MinimapZoneTextButton:Hide() end)
    end
    
    minimapShape = "SQUARE"
    MinimapBorder:SetTexture("Interface\\AddOns\\BetterMinimap\\Border.tga") --Adds the square texture
    MinimapBorderTop:SetTexture("Interface\\AddOns\\BetterMinimap\\Border.tga")
    Minimap:SetMaskTexture("Interface\\ChatFrame\\ChatFrameBackground") --Makes the minimap square
    GameTimeFrame:Hide()
    bm:SetParent(Minimap)
    bm:SetFrameLevel(1)
    bm:SetAllPoints(Minimap)

    MiniMapTrackingFrame:Hide()
    MiniMapTrackingFrame:HookScript("OnShow", function(self) self:Hide() end)

    MinimapCluster:ClearAllPoints()
    MinimapCluster:SetPoint("TOPRIGHT", UIParent, -5, -10)--(x,y) --Move the minimap
    MinimapCluster:SetScale(MM_SCALE) --Make the minimap larger

    MinimapZoneTextButton:SetPoint("TOP", Minimap, 0, 18) --Manage the zone text
    MinimapZoneText:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")

    if HNS == true then
    MinimapNorthTag:SetAlpha(0) --Hide the "N" symbol
    end
    Minimap:EnableMouseWheel(true) --Allows zoom scrolling
    Minimap:SetScript("OnMouseWheel", function(_, zoom)
        if zoom > 0 then
            Minimap_ZoomIn()
        else
            Minimap_ZoomOut()
        end
    end)

    if BUTTONS == true then
        local frames = { --Hide some minimap buttons
            MinimapZoomIn, --Zoom in (+)
            MinimapZoomOut, --Zoom out (-)
            MinimapToggleButton, --Show/hide "X" button
            MinimapBorderTop, --Background zone text
            MiniMapWorldMapButton, --World map button
        }

        for _, frame in pairs(frames) do
            frame:Hide()
        end
        frames = nil
    end

    function GetMinimapShape() --Makes minimap buttons know that the minimap is square
        return minimapShape
    end

    TimeManagerClockButton:SetPoint("BOTTOM", Minimap, 0, -26)
    TimeManagerClockButton:GetRegions():Hide()
    TimeManagerClockTicker:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
end

bm:SetScript("OnEvent", onEvent)