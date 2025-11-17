-- Separate Teleport Script (Terminal / DroneLoot / Airdrop)
-- Requires Rayfield already created + TTab available in globals

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer


----------------------------------------------------------
-- Utility: Teleport 3 studs above part
----------------------------------------------------------
local function teleportAbove(part)
    local hrp = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local targetPos = part.Position + Vector3.new(0, 3, 0)

    if getgenv().TweenToPosition then
        getgenv().TweenToPosition(targetPos)
    else
        hrp.CFrame = CFrame.new(targetPos)
    end
end


----------------------------------------------------------
-- Find Nearest Airdrop Crate
----------------------------------------------------------
local function getNearestAirdrop()
    local debris = workspace:FindFirstChild("Debris")
    if not debris then return nil end

    local myHRP = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myHRP then return nil end

    local nearest, distMin = nil, math.huge

    for _, ad in ipairs(debris:GetChildren()) do
        if ad.Name == "Airdrop" then
            local drop = ad:FindFirstChild("Drop")
            local crate = drop and drop:FindFirstChild("Crate")
            if crate then
                local dist = (crate.Position - myHRP.Position).Magnitude
                if dist < distMin then
                    nearest = crate
                    distMin = dist
                end
            end
        end
    end

    return nearest
end


----------------------------------------------------------
-- Find Nearest DroneLoot
----------------------------------------------------------
local function getNearestDroneLoot()
    local debris = workspace:FindFirstChild("Debris")
    if not debris then return nil end

    local lootFolder = debris:FindFirstChild("Loot")
    if not lootFolder then return nil end

    local myHRP = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myHRP then return nil end

    local nearest, distMin = nil, math.huge

    for _, obj in ipairs(lootFolder:GetChildren()) do
        if obj.Name == "DroneLoot" then
            local primary = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
            if primary then
                local dist = (primary.Position - myHRP.Position).Magnitude
                if dist < distMin then
                    nearest = primary
                    distMin = dist
                end
            end
        end
    end

    return nearest
end


----------------------------------------------------------
-- Find Nearest Terminal
----------------------------------------------------------
local function getNearestTerminal()
    local terminalsFolder = workspace:FindFirstChild("Terminals")
    if not terminalsFolder then return nil end

    local terminalRoot = terminalsFolder:FindFirstChild("Terminal")
    if not terminalRoot then return nil end

    local myHRP = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myHRP then return nil end

    local nearest, distMin = nil, math.huge

    for _, obj in ipairs(terminalRoot:GetChildren()) do
        if obj:IsA("Model") then
            local pp = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
            if pp then
                local dist = (pp.Position - myHRP.Position).Magnitude
                if dist < distMin then
                    nearest = pp
                    distMin = dist
                end
            end
        end
    end

    return nearest
end


