-- Services
local RunService = game:GetService("RunService")

-- Dictionary
getgenv().MSSettings = {
	Enabled = true,
	maximumPing = 100,

	MoveSpamSettings = {
		Moves = {"Soul Reaper Special", "Vortex", "Bankai", "Tesseract", "Reitsu Wave", "Celdryx's Hammer", "Shikai", "Getsuga Tensho", "Cero"}
	},
	Cooldowns = { -- wait():0.03309060000083264
		attackCd = 1, -- might be same for this as well
		targetSwitchCd = 1, --0.03, -- any faster will result in some dummies not being hit
	},
}

local Ticks = {
	attackTick = os.clock(),
	targetSwitchTick = os.clock(),
	moveSwitchTick = os.clock()
}

-- Tables
local dummies = {}
local Keys = getgenv().Things.Specifics[game.PlaceId].Keys
local Functions = {}

-- Autoexecs
local counter = 0
for i, object in pairs (workspace:GetDescendants()) do
	if object:IsA("Humanoid") and object.Health > 1000000 and object.Parent and not game.Players:FindFirstChild(object.Parent.Name) and object.Parent.Name == "Trainer" then
		table.insert(dummies, {humanoid = object, secondObj = object.Parent:FindFirstChild("HumanoidRootPart") or nil})
		counter = counter + 1
	end

	if counter >= 5 then
		break
	end

	--[[if object:IsA("IntValue") and object.Value > 1000000 and object.Parent and not game.Players:FindFirstChild(object.Parent.Name) then
		table.insert(dummies, {humanoid = object, secondObj = object.Parent})
	end]]--
end

function Functions.attack(humanoid, secondObj)
	for _, moveName in pairs (getgenv().MSSettings.MoveSpamSettings.Moves) do
		Keys.Event:FireServer(Keys.numPass, Keys.Pass, "Hit", humanoid, secondObj, moveName)
	end
end

if workspace:FindFirstChild("Folder") then
	workspace.Folder:Destroy()
end

-- Loop
while getgenv().MSSettings.Enabled do
	RunService.Heartbeat:Wait()

	if game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() > getgenv().MSSettings.maximumPing then
		repeat wait() until game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() < getgenv().MSSettings.maximumPing
	end

	if getgenv().MSSettings.Cooldowns.attackCd == 0 or (os.clock() - Ticks.attackTick) >= getgenv().MSSettings.Cooldowns.attackCd then
		Ticks.attackTick = os.clock()

		for i=1, #dummies do
			if getgenv().MSSettings.Cooldowns.targetSwitchCd > 0 then
				repeat RunService.RenderStepped:Wait() until (os.clock() - Ticks.targetSwitchTick) >= getgenv().MSSettings.Cooldowns.targetSwitchCd
			else
				RunService.RenderStepped:Wait()
			end

			Ticks.targetSwitchTick = os.clock()
			Functions.attack(dummies[i].humanoid, dummies[i].secondObj)
		end
	end
end
