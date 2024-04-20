-- written by myzsyn, much love

local LocalPlayer = game.Players.LocalPlayer

if _G.apdist == nil then
   _G.apdist = 10
end

local animationInfo = {}

function getInfo(id)
    local success, info = pcall(function()
        return game:GetService("MarketplaceService"):GetProductInfo(id)
    end)
    if success then
        return info
    end
    return {Name=''}
end

local AnimNames = {
    'AttackOne',
    'AttackTwo',
    'AttackThree',
    'AttackFour',
    'Untitled',
}

local apArgsOn = {
    [1] = {
        [1] = {
            [1] = "\13",
            [2] = "True"
        }
    }
}

local apArgsOff = {
    [1] = {
        [1] = {
            [1] = "\13",
            [2] = "False"
        }
    }
}

function parry(v)
task.wait(.2)
game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent"):FireServer(unpack(apArgsOn))
task.wait(.7)
game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent"):FireServer(unpack(apArgsOff)) -- turn off the parry remote so the NPCs wouldn't just stare at you and waiting for you to take your guard down.
end

function npcAdded(v)
        local humanoid = v:WaitForChild("Humanoid", 5)
        if humanoid then
            humanoid.AnimationPlayed:Connect(function(track)
            local info = animationInfo[track.Animation.AnimationId]
            if not info then
                info = getInfo(tonumber(track.Animation.AnimationId:match("%d+")))
                animationInfo[track.Animation.AnimationId] = info
            end
            if (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("HumanoidRootPart")) then
                local magn = (v.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                if magn < _G.apdist then
                    for _, animName in pairs(AnimNames) do
                        if string.match(info.Name, animName) then
                            pcall(parry, v)
                        end
                    end
                end
            end
        end)
    end
end

for i, v in pairs(workspace.Enemies:GetChildren()) do
    npcAdded(v)
end

workspace.Enemies.ChildAdded:Connect(function(npc)
    if npc.Name == "Enemy" then
       for i, v in pairs(workspace.Enemies:GetChildren()) do
           npcAdded(v)
       end
    end
end)