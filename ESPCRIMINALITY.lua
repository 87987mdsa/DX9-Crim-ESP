local Lib = loadstring(dx9.Get("https://raw.githubusercontent.com/soupg/DXLibUI/main/main.lua"))()
local Window = Lib:CreateWindow({Title = "Criminalty | icehook.dx9", Size = {0,0}, Resizable = true, ToggleKey = "[V]", FooterMouseCoords = false })
local Tab1 = Window:AddTab("ESP")
local Groupbox1 = Tab1:AddMiddleGroupbox("ESP TOGGLES") 

local lootESP = Groupbox1:AddToggle({Default = false, Text = "Loot ESP"}):OnChanged(function(value)
    if value then Lib:Notify("Loot ESP Enabled", 1) else Lib:Notify("Loot ESP Disabled", 1) end
end)
local armoryESP = Groupbox1:AddToggle({Default = false, Text = "Armory ESP"}):OnChanged(function(value)
    if value then Lib:Notify("Armory ESP Enabled", 1) else Lib:Notify("Armory ESP Disabled", 1) end
end)
local atmESP = Groupbox1:AddToggle({Default = false, Text = "ATM ESP"}):OnChanged(function(value)
    if value then Lib:Notify("ATM ESP Enabled", 1) else Lib:Notify("ATM ESP Disabled", 1) end
end)
local safeESP = Groupbox1:AddToggle({Default = false, Text = "Brekeables ESP"}):OnChanged(function(value)
    if value then Lib:Notify("Brekeables ESP Enabled", 1) else Lib:Notify("Brekeables ESP Disabled", 1) end
end)

local dist_limit = Groupbox1:AddSlider({Default = 300, Text = "ESP Range", Min = 0, Max = 2000})

local datamodel = dx9.GetDatamodel()
local workspace = dx9.FindFirstChildOfClass(datamodel, 'Workspace')
local map = dx9.FindFirstChild(workspace, 'Map')
local filter = dx9.FindFirstChild(workspace, 'Filter')
local LocalPlayer = dx9.get_localplayer()


local function dist(v)
    local v1 = LocalPlayer.Position
    local v2 = dx9.GetPosition(v)
    local a = (v1.x-v2.x)*(v1.x-v2.x)
    local b = (v1.y-v2.y)*(v1.y-v2.y)
    local c = (v1.z-v2.z)*(v1.z-v2.z)
    return math.floor(math.sqrt(a+b+c)+0.5)
end


local function LootESP()
    for _, v in next, dx9.GetChildren(dx9.FindFirstChild(filter, 'SpawnedPiles')) do
        local name = dx9.GetName(v)
        local meshpart = dx9.FindFirstChild(v, 'MeshPart')
        local pos = dx9.GetPosition(meshpart)
        local pos2 = dx9.WorldToScreen({pos.x, pos.y, pos.z})
        local displayText = "Scrap"
        if name == "C1" then
            displayText = "Crate"
        elseif name == "S2" then
            displayText = "Scrap"
        elseif name == "P" then
            displayText = "Gift"
        end

        if dist(dx9.FindFirstChild(v, 'MeshPart')) <= dist_limit.Value then
            if lootESP.Value then
                dx9.DrawString({pos2.x - 15, pos2.y + 10}, {235, 237, 143}, displayText)
                dx9.DrawCircle({pos2.x, pos2.y}, {235, 237, 143}, 4)
            end
        end
    end
end


local function ArmoryESP()
    for _, v in next, dx9.GetChildren(dx9.FindFirstChild(map, 'Shopz')) do
        local name = dx9.GetName(v)
        local mainpart = dx9.FindFirstChild(v, 'MainPart')
        local pos = dx9.GetPosition(mainpart)
        local pos2 = dx9.WorldToScreen({pos.x, pos.y, pos.z})

        if dist(dx9.FindFirstChild(v, 'MainPart')) <= dist_limit.Value then
            if armoryESP.Value then
                if name == 'ArmoryDealer' then 
                    name = 'Armory'
                end
                dx9.DrawString({pos2.x - 15, pos2.y + 10}, {255, 255, 255}, name)
                dx9.DrawCircle({pos2.x, pos2.y}, {255, 255, 255}, 4)
            end
        end
    end
end


local function ATMESP()
    for _, v in next, dx9.GetChildren(dx9.FindFirstChild(map, 'ATMz')) do
        local mainpart = dx9.FindFirstChild(v, 'MainPart')
        local pos = dx9.GetPosition(mainpart)
        local pos2 = dx9.WorldToScreen({pos.x, pos.y, pos.z})
        if dist(dx9.FindFirstChild(v, 'MainPart')) <= dist_limit.Value then
            if atmESP.Value then
                dx9.DrawString({pos2.x - 10, pos2.y + 10}, {93, 163, 233}, 'ATM')
                dx9.DrawCircle({pos2.x, pos2.y}, {93, 163, 233}, 4)
            end
        end
    end
end

local function SafeESP()
    for _, safe in next, dx9.GetChildren(dx9.FindFirstChild(map, "BredMakurz")) do
        local mainpart = dx9.FindFirstChild(safe, "MainPart")
        if mainpart then
            local pos = dx9.GetPosition(mainpart)
            local pos2 = dx9.WorldToScreen({pos.x, pos.y, pos.z})
            local safeName = dx9.GetName(safe)
            local displ = ""
            if string.find(safeName, "Register") then
                displ = "Register"
            elseif string.find(safeName, "SmallSafe") then
                displ = "SmallSafe"
            elseif string.find(safeName, "MediumSafe") then
                displ = "MediumSafe"
            else
                displ = "Unknown"
            end
            local valuesFolder = dx9.FindFirstChild(safe, "Values")
            local brokenValue = false
            if valuesFolder then
                local broken = dx9.FindFirstChild(valuesFolder, "Broken")
                if broken then
                    brokenValue = dx9.GetBoolValue(broken)
                end
            end

            local color = {0, 204, 63}
            if brokenValue == true then
                color = {191, 3, 3}
            end
            if dist(dx9.FindFirstChild(safe, "MainPart")) <= dist_limit.Value then
                if safeESP.Value then
                    dx9.DrawString({pos2.x - 35, pos2.y + 10}, color, "[" .. displ .. "]")
                    dx9.DrawCircle({pos2.x, pos2.y}, color, 4)
                end
            end
        end
    end
end

while true do
    LootESP()
    ArmoryESP()
    ATMESP()
    SafeESP()
    dx9.Wait(0.1)
end
