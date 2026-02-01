_G.behindback = false
_G.behindbackSpeed = 1.5

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local plr = Players.LocalPlayer
local ANIM_ID = 99563839802389
local track
local lastState = false
local lastSpeed = _G.behindbackSpeed

local function play(char)
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not hum then return end

	local ok, objs = pcall(function()
		return game:GetObjects("rbxassetid://" .. ANIM_ID)
	end)

	local anim = ok and objs and objs[1]
	if anim and anim:IsA("Animation") then
		if track then pcall(function() track:Stop(0) end) end
		local tr = hum:LoadAnimation(anim)
		tr.Looped = true
		tr.Priority = Enum.AnimationPriority.Action
		tr:Play()
		tr:AdjustSpeed(_G.behindbackSpeed or 1)
		track = tr
		lastSpeed = _G.behindbackSpeed
	end
end

local function stop()
	if track then
		pcall(function() track:Stop(0) end)
		track = nil
	end
end

UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.N then
		_G.behindback = not _G.behindback
	end
end)

task.spawn(function()
	while true do
		task.wait(0.1)

		if _G.behindback ~= lastState then
			lastState = _G.behindback
			if _G.behindback then
				if plr.Character then play(plr.Character) end
			else
				stop()
			end
		end

		if track and _G.behindbackSpeed ~= lastSpeed then
			lastSpeed = _G.behindbackSpeed
			pcall(function()
				track:AdjustSpeed(_G.behindbackSpeed or 1)
			end)
		end
	end
end)

plr.CharacterAdded:Connect(function(c)
	if _G.behindback then
		play(c)
	else
		stop()
	end
end)
