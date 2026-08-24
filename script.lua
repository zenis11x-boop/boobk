--==================================================
-- SERVICES
--==================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

--==================================================
-- PLAYER
--==================================================

local player = Players.LocalPlayer

--==================================================
-- CHARACTER
--==================================================

local character
local humanoid
local root

local function setupCharacter(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    root = character:WaitForChild("HumanoidRootPart")
end

if player.Character then
    setupCharacter(player.Character)
end

player.CharacterAdded:Connect(setupCharacter)

--==================================================
-- SETTINGS
--==================================================

-- JUMP ADJUSTER
local MIN_JUMP_ADJUSTER = 10
local MAX_JUMP_ADJUSTER = 200
local jumpAdjuster = 50

-- FALL VELOCITY
local MIN_FALL_VELOCITY = 10
local MAX_FALL_VELOCITY = 300
local fallVelocity = 40

-- SEPARATE FALL GRAVITY
local MIN_FALL_GRAVITY = 0
local MAX_FALL_GRAVITY = 300
local fallGravity = 0

-- NORMAL GAME SETTINGS
local BASE_GRAVITY = 196.2
local CUSTOM_GRAVITY = 192
local enabled = false
local guiVisible = true

-- CURRENT VERTICAL VELOCITY
local verticalVelocity = 0

--==================================================
-- GUI
--==================================================

local gui = Instance.new("ScreenGui")
gui.Name = "😭"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Name = "Main"
frame.Size = UDim2.new(0, 270, 0, 260)
frame.Position = UDim2.new(0.05, 0, 0.35, 0)
frame.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
frame.BorderSizePixel = 0
frame.Active = true
frame.ClipsDescendants = true
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(
        0,
        Color3.fromRGB(255, 255, 255)
    ),
    ColorSequenceKeypoint.new(
        0.5,
        Color3.fromRGB(240, 240, 240)
    ),
    ColorSequenceKeypoint.new(
        1,
        Color3.fromRGB(220, 220, 220)
    )
})
gradient.Rotation = 135
gradient.Parent = frame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(175, 175, 175)
stroke.Thickness = 1.2
stroke.Transparency = 0.25
stroke.Parent = frame

--==================================================
-- TITLE
--==================================================

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 25)
title.Position = UDim2.new(0, 10, 0, 6)
title.BackgroundTransparency = 1
title.Text = "😭"
title.Font = Enum.Font.Gotham
title.TextColor3 = Color3.fromRGB(25, 25, 25)
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

--==================================================
-- MAIN TOGGLE
--==================================================

local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(1, -20, 0, 27)
toggle.Position = UDim2.new(0, 10, 0, 34)
toggle.BackgroundColor3 = Color3.fromRGB(225, 225, 225)
toggle.BorderSizePixel = 0
toggle.Text = "●  OFF"
toggle.TextColor3 = Color3.fromRGB(35, 35, 35)
toggle.TextSize = 13
toggle.Font = Enum.Font.Gotham
toggle.AutoButtonColor = false
toggle.Parent = frame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 7)
toggleCorner.Parent = toggle

--==================================================
-- JUMP ADJUSTER LABEL
--==================================================

local jumpLabel = Instance.new("TextLabel")
jumpLabel.Size = UDim2.new(1, -20, 0, 18)
jumpLabel.Position = UDim2.new(0, 10, 0, 66)
jumpLabel.BackgroundTransparency = 1
jumpLabel.Text = "Jump Adjuster: 50"
jumpLabel.TextColor3 = Color3.fromRGB(75, 75, 75)
jumpLabel.TextSize = 12
jumpLabel.Font = Enum.Font.Gotham
jumpLabel.TextXAlignment = Enum.TextXAlignment.Left
jumpLabel.Parent = frame

--==================================================
-- JUMP ADJUSTER SLIDER
--==================================================

local jumpSlider = Instance.new("Frame")
jumpSlider.Size = UDim2.new(1, -30, 0, 6)
jumpSlider.Position = UDim2.new(0, 15, 0, 89)
jumpSlider.BackgroundColor3 = Color3.fromRGB(205, 205, 205)
jumpSlider.BorderSizePixel = 0
jumpSlider.Active = true
jumpSlider.Parent = frame

local jumpSliderCorner = Instance.new("UICorner")
jumpSliderCorner.CornerRadius = UDim.new(1, 0)
jumpSliderCorner.Parent = jumpSlider

local jumpFill = Instance.new("Frame")
jumpFill.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
jumpFill.BorderSizePixel = 0
jumpFill.Parent = jumpSlider

local jumpFillCorner = Instance.new("UICorner")
jumpFillCorner.CornerRadius = UDim.new(1, 0)
jumpFillCorner.Parent = jumpFill

--==================================================
-- FALL VELOCITY LABEL
--==================================================

local fallLabel = Instance.new("TextLabel")
fallLabel.Size = UDim2.new(1, -20, 0, 18)
fallLabel.Position = UDim2.new(0, 10, 0, 103)
fallLabel.BackgroundTransparency = 1
fallLabel.Text = "Fall Velocity: 40"
fallLabel.TextColor3 = Color3.fromRGB(75, 75, 75)
fallLabel.TextSize = 12
fallLabel.Font = Enum.Font.Gotham
fallLabel.TextXAlignment = Enum.TextXAlignment.Left
fallLabel.Parent = frame

--==================================================
-- FALL VELOCITY SLIDER
--==================================================

local fallSlider = Instance.new("Frame")
fallSlider.Size = UDim2.new(1, -30, 0, 6)
fallSlider.Position = UDim2.new(0, 15, 0, 126)
fallSlider.BackgroundColor3 = Color3.fromRGB(205, 205, 205)
fallSlider.BorderSizePixel = 0
fallSlider.Active = true
fallSlider.Parent = frame

local fallSliderCorner = Instance.new("UICorner")
fallSliderCorner.CornerRadius = UDim.new(1, 0)
fallSliderCorner.Parent = fallSlider

local fallFill = Instance.new("Frame")
fallFill.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
fallFill.BorderSizePixel = 0
fallFill.Parent = fallSlider

local fallFillCorner = Instance.new("UICorner")
fallFillCorner.CornerRadius = UDim.new(1, 0)
fallFillCorner.Parent = fallFill

--==================================================
-- FALL GRAVITY LABEL
--==================================================

local gravityLabel = Instance.new("TextLabel")
gravityLabel.Size = UDim2.new(1, -20, 0, 18)
gravityLabel.Position = UDim2.new(0, 10, 0, 140)
gravityLabel.BackgroundTransparency = 1
gravityLabel.Text = "Fall Gravity: 0"
gravityLabel.TextColor3 = Color3.fromRGB(75, 75, 75)
gravityLabel.TextSize = 12
gravityLabel.Font = Enum.Font.Gotham
gravityLabel.TextXAlignment = Enum.TextXAlignment.Left
gravityLabel.Parent = frame

--==================================================
-- FALL GRAVITY SLIDER
--==================================================

local gravitySlider = Instance.new("Frame")
gravitySlider.Size = UDim2.new(1, -30, 0, 6)
gravitySlider.Position = UDim2.new(0, 15, 0, 163)
gravitySlider.BackgroundColor3 = Color3.fromRGB(205, 205, 205)
gravitySlider.BorderSizePixel = 0
gravitySlider.Active = true
gravitySlider.Parent = frame

local gravitySliderCorner = Instance.new("UICorner")
gravitySliderCorner.CornerRadius = UDim.new(1, 0)
gravitySliderCorner.Parent = gravitySlider

local gravityFill = Instance.new("Frame")
gravityFill.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
gravityFill.BorderSizePixel = 0
gravityFill.Parent = gravitySlider

local gravityFillCorner = Instance.new("UICorner")
gravityFillCorner.CornerRadius = UDim.new(1, 0)
gravityFillCorner.Parent = gravityFill

--==================================================
-- FOOTER
--==================================================

local madeBy = Instance.new("TextLabel")
madeBy.Size = UDim2.new(1, -20, 0, 25)
madeBy.Position = UDim2.new(0, 10, 0, 195)
madeBy.BackgroundTransparency = 1
madeBy.Text = "made by @catinsnow • discord.gg/karashop"
madeBy.TextColor3 = Color3.fromRGB(120, 120, 120)
madeBy.TextSize = 9
madeBy.Font = Enum.Font.Gotham
madeBy.TextXAlignment = Enum.TextXAlignment.Center
madeBy.Parent = frame

--==================================================
-- APPLY SETTINGS
--==================================================

local function applySettings()
    if not humanoid then
        return
    end

    humanoid.UseJumpPower = true
    humanoid.JumpPower = 50
    workspace.Gravity = CUSTOM_GRAVITY
end

--==================================================
-- RESET
--==================================================

local function resetSettings()
    if humanoid then
        humanoid.UseJumpPower = true
        humanoid.JumpPower = 50
    end

    workspace.Gravity = BASE_GRAVITY
    verticalVelocity = 0
end

--==================================================
-- MAIN TOGGLE
--==================================================

local function setEnabled(state)
    enabled = state

    if enabled then
        toggle.Text = "●  ON"
        toggle.BackgroundColor3 = Color3.fromRGB(205, 205, 205)
        applySettings()
    else
        toggle.Text = "●  OFF"
        toggle.BackgroundColor3 = Color3.fromRGB(225, 225, 225)
        resetSettings()
    end
end

toggle.MouseButton1Click:Connect(function()
    setEnabled(not enabled)
end)

--==================================================
-- GENERIC SLIDER
--==================================================

local function sliderValue(input, slider, minValue, maxValue)
    local x = math.clamp(
        (input.Position.X - slider.AbsolutePosition.X)
            / slider.AbsoluteSize.X,
        0,
        1
    )

    return minValue + ((maxValue - minValue) * x), x
end

--==================================================
-- JUMP ADJUSTER SLIDER
--==================================================

local jumpDragging = false

local function updateJumpSlider(input)
    local value, percentage =
        sliderValue(
            input,
            jumpSlider,
            MIN_JUMP_ADJUSTER,
            MAX_JUMP_ADJUSTER
        )

    jumpAdjuster = math.round(value)

    jumpLabel.Text =
        "Jump Adjuster: " .. jumpAdjuster

    jumpFill.Size =
        UDim2.new(
            percentage,
            0,
            1,
            0
        )
end

jumpSlider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        jumpDragging = true
        updateJumpSlider(input)
    end
end)

--==================================================
-- FALL VELOCITY SLIDER
--==================================================

local fallDragging = false

local function updateFallSlider(input)
    local value, percentage =
        sliderValue(
            input,
            fallSlider,
            MIN_FALL_VELOCITY,
            MAX_FALL_VELOCITY
        )

    fallVelocity = math.round(value)

    fallLabel.Text =
        "Fall Velocity: " .. fallVelocity

    fallFill.Size =
        UDim2.new(
            percentage,
            0,
            1,
            0
        )
end

fallSlider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        fallDragging = true
        updateFallSlider(input)
    end
end)

--==================================================
-- FALL GRAVITY SLIDER
--==================================================

local gravityDragging = false

local function updateGravitySlider(input)
    local value, percentage =
        sliderValue(
            input,
            gravitySlider,
            MIN_FALL_GRAVITY,
            MAX_FALL_GRAVITY
        )

    fallGravity = math.round(value)

    gravityLabel.Text =
        "Fall Gravity: " .. fallGravity

    gravityFill.Size =
        UDim2.new(
            percentage,
            0,
            1,
            0
        )
end

gravitySlider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        gravityDragging = true
        updateGravitySlider(input)
    end
end)

--==================================================
-- SLIDER INPUT
--==================================================

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType ~= Enum.UserInputType.MouseMovement
        and input.UserInputType ~= Enum.UserInputType.Touch then
        return
    end

    if jumpDragging then
        updateJumpSlider(input)
    end

    if fallDragging then
        updateFallSlider(input)
    end

    if gravityDragging then
        updateGravitySlider(input)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        jumpDragging = false
        fallDragging = false
        gravityDragging = false
    end
end)

--==================================================
-- JUMP SYSTEM
--==================================================

local function connectJumpEvent(currentHumanoid, currentRoot)
    if not currentHumanoid or not currentRoot then
        return
    end

    currentHumanoid.Jumping:Connect(function(active)
        if not active then
            return
        end

        if not enabled then
            return
        end

        verticalVelocity = jumpAdjuster

        local currentVelocity =
            currentRoot.AssemblyLinearVelocity

        currentRoot.AssemblyLinearVelocity =
            Vector3.new(
                currentVelocity.X,
                verticalVelocity,
                currentVelocity.Z
            )
    end)
end

if humanoid and root then
    connectJumpEvent(humanoid, root)
end

player.CharacterAdded:Connect(function(newCharacter)
    local newHumanoid =
        newCharacter:WaitForChild("Humanoid")

    local newRoot =
        newCharacter:WaitForChild("HumanoidRootPart")

    task.wait()

    connectJumpEvent(newHumanoid, newRoot)
end)

--==================================================
-- FALL SYSTEM
-- NORMAL FALL / DIVE
--==================================================

RunService.RenderStepped:Connect(function(delta)
    if not enabled then
        return
    end

    if not humanoid or not root then
        return
    end

    local state = humanoid:GetState()
    local velocity = root.AssemblyLinearVelocity

    -- NORMAL FREEFALL
    if state == Enum.HumanoidStateType.Freefall then

        -- Only apply optional fall gravity.
        -- Fall velocity no longer aggressively pulls
        -- the character toward the ground.

        if fallGravity > 0 then

            verticalVelocity =
                velocity.Y
                - (fallGravity * delta * 0.5)

            verticalVelocity =
                math.max(
                    verticalVelocity,
                    -120
                )

            root.AssemblyLinearVelocity =
                Vector3.new(
                    velocity.X,
                    verticalVelocity,
                    velocity.Z
                )
        else

            -- Let Roblox handle normal falling.
            verticalVelocity = velocity.Y
        end

    --==================================================
    -- JUMPING
    --==================================================

    elseif state == Enum.HumanoidStateType.Jumping then

        -- Don't fight Roblox's normal jump physics.
        verticalVelocity = velocity.Y

    --==================================================
    -- GROUND / OTHER STATES
    --==================================================

    else
        verticalVelocity = velocity.Y
    end
end)

--==================================================
-- GUI DRAGGING
--==================================================

local dragging = false
local dragStart
local startPosition

title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPosition = frame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not dragging then
        return
    end

    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then

        local delta =
            input.Position - dragStart

        frame.Position =
            UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + delta.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset + delta.Y
            )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = false
    end
end)

--==================================================
-- CONTROLS
--
-- D-PAD LEFT = SHOW / HIDE GUI
-- RB = MAIN TOGGLE
-- D-PAD RIGHT = REMOVED
--==================================================

UserInputService.InputBegan:Connect(function(
    input,
    gameProcessed
)

    if gameProcessed then
        return
    end

    -- D-PAD LEFT = SHOW / HIDE GUI
    if input.KeyCode == Enum.KeyCode.DPadLeft then
        guiVisible = not guiVisible
        gui.Enabled = guiVisible
    end

    -- RB = MAIN TOGGLE
    if input.KeyCode == Enum.KeyCode.ButtonR1 then
        setEnabled(not enabled)
    end
end)

--==================================================
-- INITIALIZE SLIDERS
--==================================================

do
    local jumpPercentage =
        (jumpAdjuster - MIN_JUMP_ADJUSTER)
        / (MAX_JUMP_ADJUSTER - MIN_JUMP_ADJUSTER)

    jumpFill.Size =
        UDim2.new(
            jumpPercentage,
            0,
            1,
            0
        )

    local fallPercentage =
        (fallVelocity - MIN_FALL_VELOCITY)
        / (MAX_FALL_VELOCITY - MIN_FALL_VELOCITY)

    fallFill.Size =
        UDim2.new(
            fallPercentage,
            0,
            1,
            0
        )

    local gravityPercentage =
        (fallGravity - MIN_FALL_GRAVITY)
        / (MAX_FALL_GRAVITY - MIN_FALL_GRAVITY)

    gravityFill.Size =
        UDim2.new(
            gravityPercentage,
            0,
            1,
            0
        )
end

--==================================================
-- START DISABLED
--==================================================

setEnabled(false)
