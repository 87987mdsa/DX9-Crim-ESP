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
local safeESP = Groupbox1:AddToggle({Default = false, Text = "Breakables ESP"}):OnChanged(function(value)
    if value then Lib:Notify("Breakables ESP Enabled", 1) else Lib:Notify("Breakables ESP Disabled", 1) end
end)
local datamodel = dx9.GetDatamodel()
local workspace = FindFirstChildOfClass(datamodel, 'Workspace')
local map = FindFirstChild(workspace, 'Map')
local filter = FindFirstChild(workspace, 'Filter')
for i, v in pairs(dx9) do
    _G[i] = v
end
local function LootESP()
    for _, v in next, GetChildren(FindFirstChild(filter, 'SpawnedPiles')) do
        local name = GetName(v)
        local meshpart = FindFirstChild(v, 'MeshPart')
        local pos = GetPosition(meshpart)
        local pos2 = WorldToScreen({pos.x, pos.y, pos.z})
        local displayText = "Scrap"
        if name == "C1" then
            displayText = "Crate"
        elseif name == "S2" then
            displayText = "Scrap"
        elseif name == "P" then
            displayText = "Gift"
        end
        if lootESP.Value then
            DrawString({pos2.x - 15, pos2.y + 10}, {235, 237, 143}, displayText)
            DrawCircle({pos2.x, pos2.y}, {235, 237, 143}, 4)
        end
    end
end
local function ArmoryESP()
    for _, v in next, GetChildren(FindFirstChild(map, 'Shopz')) do
        local name = GetName(v)
        local mainpart = FindFirstChild(v, 'MainPart')
        local pos = GetPosition(mainpart)
        local pos2 = WorldToScreen({pos.x, pos.y, pos.z})
        if armoryESP.Value then
            if name == 'ArmoryDealer' then 
                name = 'Armory'
            end
            DrawString({pos2.x - 15, pos2.y + 10}, {255, 255, 255}, name)
            DrawCircle({pos2.x, pos2.y}, {255, 255, 255}, 4)
        end
    end
end
local function ATMESP()
    for _, v in next, GetChildren(FindFirstChild(map, 'ATMz')) do
        local mainpart = FindFirstChild(v, 'MainPart')
        local pos = GetPosition(mainpart)
        local pos2 = WorldToScreen({pos.x, pos.y, pos.z})
        if atmESP.Value then
            DrawString({pos2.x - 10, pos2.y + 10}, {93, 163, 233}, 'ATM')
            DrawCircle({pos2.x, pos2.y}, {93, 163, 233}, 4)
        end
    end
end
local function SafeESP()
    for _, safe in next, GetChildren(FindFirstChild(map, "BredMakurz")) do
        local mainpart = FindFirstChild(safe, "MainPart")
        if mainpart then
            local pos = GetPosition(mainpart)
            local pos2 = WorldToScreen({pos.x, pos.y, pos.z})
            local safeName = GetName(safe)
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
            local valuesFolder = FindFirstChild(safe, "Values")
            local brokenValue = false
            if valuesFolder then
                local broken = FindFirstChild(valuesFolder, "Broken")
                if broken then
                    brokenValue = GetBoolValue(broken)
                end
            end

            local color = {0, 204, 63}
            if brokenValue == true then
                color = {191, 3, 3}
            end
            if safeESP.Value then
                DrawString({pos2.x - 35, pos2.y + 10}, color, "[" .. displ .. "]")
                DrawCircle({pos2.x, pos2.y}, color, 4)
            end
        end
    end
end
while true do
    LootESP()
    ArmoryESP()
    ATMESP()
    SafeESP()
    Wait(0.1)
end
