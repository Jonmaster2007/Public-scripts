--===============================
--  TERMINAL / DRONE / AIRDROP TP SCRIPT
--  Requires: _G.TweenToPosition already defined
--===============================

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

----------------------------------------------------------
-- Teleport 3 studs above a part
----------------------------------------------------------
local function teleportAbove(part)
    local hrp = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp or not part then return end

    local targetPos = part.Position + Vector3.new(0, 3, 0)

    if _G.TweenToPosition then
        _G.TweenToPosition(targetPos)
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
                    nearest, distMin = crate, dist
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
            local pp = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
            if pp then
                local dist = (pp.Position - myHRP.Position).Magnitude
                if dist < distMin then
                    nearest, distMin = pp, dist
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
                    nearest, distMin = pp, dist
                end
            end
        end
    end

    return nearest
end

----------------------------------------------------------
-- Expose functions globally (UI uses these)
----------------------------------------------------------
_G.GetNearestAirdrop = getNearestAirdrop
_G.GetNearestDroneLoot = getNearestDroneLoot
_G.GetNearestTerminal = getNearestTerminal
_G.TeleportAbove = teleportAbove
