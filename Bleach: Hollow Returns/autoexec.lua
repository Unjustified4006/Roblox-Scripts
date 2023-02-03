if not table.find({8689257920, 88144401, 4241790494}, game.PlaceId) then return end

local ignoreList = {"DefaultChatSystemChatEvents", "RobloxGui", "RobloxReplicatedStorage"}
getgenv().Things = {
	Remotes = {},
	Wrkspace = {},
	Functions = {},
	Scripts = {},
	RFService = {},
	Specifics = {
		[88144401] = {
			Tables = {
				teleportLocations = {
					KT = CFrame.new(-1.59991455, 55.185154, 495.049866, 1, 0, 0, 0, 1, 0, 0, 0, 1),
					LN = CFrame.new(9825.23633, 8.64586735, 9136.20801, -0.995254815, 0.00139619026, 0.0972929001, 0.00173046405, 0.999992907, 0.0033514481, -0.0972875282, 0.00350390654, -0.995250165),
					MF = CFrame.new(-10367.0586, -84.8749008, 19333.3027, -0.922884583, 1.11660272e-08, 0.385076642, 7.75519926e-10, 1, -2.71382632e-08, -0.385076642, -2.47468499e-08, -0.922884583),
					QP = CFrame.new(5290.98438, 10061.8828, -36020.1992, -0.893160462, -1.08647136e-07, -0.449738115, -1.09651026e-07, 1, -2.3816467e-08, 0.449738115, 2.80423187e-08, -0.893160462),
					SS = CFrame.new(-9991, 5006.18359, -1078.99963, -0.704684794, -3.96676896e-08, -0.709520519, -3.72518016e-08, 1, -1.89098301e-08, 0.709520519, 1.31054474e-08, -0.704684794)
				}
			},

			Settings = {
				Autofarm = false	,
				AntiTimeout = true
			},

			Keys = {
				Event = nil,
				Pass = "",
				numPass = nil
			},

			Autoexecs = {
				kickOnFail = function()
					wait(1)
					if not getgenv().Things.Specifics[game.PlaceId].Keys.Event then game.Players.LocalPlayer:Kick("Failed to load autoexec") end
					if not getgenv().Things.Specifics[game.PlaceId].Keys.numPass then game.Players.LocalPlayer:Kick("Failed to load autoexec") end
					if not getgenv().Things.Specifics[game.PlaceId].Keys.Pass then game.Players.LocalPlayer:Kick("Failed to load autoexec") end
					if not getgenv().Things.Specifics[game.PlaceId].Functions["OCE"] then game.Players.LocalPlayer:Kick("Failed to load autoexec") end
				end,

				setupOCE = function()
					for _, func in next, getgc() do
						if type(func) == "function" and not is_synapse_function(func) and getinfo(func) then
							local info = getinfo(func)
							local funcName = info.name
							local source = info.source
							local nups = info.nups
							local currentline = info.currentline
							if source == "=ReplicatedFirst.First" then
								if nups == 15 and currentline == 3097 then
									getgenv().Things.Specifics[game.PlaceId].Functions["OCE"] = func
								end
							end
						end
					end
				end,

				setupAntiTimeout = function()
					game.Players.LocalPlayer.Idled:Connect(function()
						game:GetService("VirtualUser"):Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
						wait(1)
						game:GetService("VirtualUser"):Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
					end)
				end,

			},

			Functions = {
				enableAbilitySpam = function()
					for names, vals in pairs (debug.getupvalues(getgenv().Things.Specifics[game.PlaceId].Functions["OCE"])[7]) do
						if typeof(vals) ~= 'number' then continue end

						if string.match(tostring(names):lower(), "time") then
							task.spawn(function()
								while true do wait()
									debug.getupvalues(getgenv().Things.Specifics[game.PlaceId].Functions["OCE"])[7][names] = 50
								end
							end)
						elseif string.match(tostring(names):lower(), "cost") then
							debug.getupvalues(getgenv().Things.Specifics[game.PlaceId].Functions["OCE"])[7][names] = 0
						end
					end
				end,

				teleportTo = function(cframe)
					debug.getupvalues(getgenv().Things.Specifics[game.PlaceId].Functions["OCE"])[7].location = cframe
					game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = cframe
				end,

				returnNormalFirePass = function()
					return debug.getupvalue(getgenv().Things.Specifics[game.PlaceId].Functions["OCE"], 3)
				end,

				updateNormalFirePass = function(val) -- this is to update the normal fireserver numPass code to the client so it doesn't break
					debug.setupvalue(getgenv().Things.Specifics[game.PlaceId].Functions["OCE"], 3, val)
				end,

				getQuest = function()
					local Keys = getgenv().Things.Specifics[game.PlaceId].Keys

					local args = {
						[1] = Keys.numPass,
						[2] = Keys.Pass,
						[3] = "QuestAdding"
					}

					return Keys.Event:FireServer(unpack(args))
				end,

				getClosestMonster = function()
					local distance = math.huge
					local monster;

					for i, mob in pairs (workspace.Mobs:GetChildren()) do
						local Root = mob:FindFirstChildOfClass("Part")
						local Humanoid = mob:FindFirstChild("Humanoid")

						if Root and Humanoid and Humanoid.Health > 0 then
							local magnitude = (Root.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
							if distance > magnitude then
								distance = magnitude
								monster = mob
							end
						end
					end

					return monster
				end,

				getStrongestMonster = function()
					local health = 0
					local monster;

					for i, mob in pairs (workspace.Mobs:GetChildren()) do
						local Humanoid = mob:FindFirstChild("Humanoid")

						if Humanoid and Humanoid.Health > health then
							health = Humanoid.health

							monster = mob
						end
					end

					return monster
				end,

				attackMonster = function(num, monster)
					local Keys = getgenv().Things.Specifics[game.PlaceId].Keys
					local Functions = getgenv().Things.Specifics[game.PlaceId].Functions

					task.spawn(function()
						for i=1, num do
							task.spawn(function()
								pcall(function()
									monster = monster or Functions.getClosestMonster()

									local root = monster:FindFirstChildOfClass("Part")
									if not monster or (monster and not monster:FindFirstChild("Humanoid")) or not root then return end

									local args = {
										[1] = Keys.numPass,
										[2] = Keys.Pass,
										[3] = "Hit",
										[4] = monster.Humanoid,
										[5] = (game:GetService("Players").LocalPlayer.Character:FindFirstChild("Tool") and game:GetService("Players").LocalPlayer.Character:FindFirstChild("Tool"):FindFirstChild("Handle")) or game:GetService("Players").LocalPlayer.Character.RightHand, -- might be damage position
										[6] = "NormalSword"
									}

									Keys.Event:FireServer(unpack(args))

									if monster.Humanoid and monster.Humanoid.Health > 0 and isnetworkowner(root) then
										monster.Humanoid.Health = monster.Humanoid.MaxHealth
									end
								end)
							end)
						end
					end)
				end,

				toggleAutofarm = function()
					local Settings = getgenv().Things.Specifics[game.PlaceId].Settings
					local Functions = getgenv().Things.Specifics[game.PlaceId].Functions

					getgenv().Things.Specifics[game.PlaceId].Settings.Autofarm = not Settings.Autofarm

					if not Settings.Autofarm then return end

					while getgenv().Things.Specifics[game.PlaceId].Settings.Autofarm do game:GetService("RunService").RenderStepped:Wait()
						Functions.attackMonster(100, Functions.getStrongestMonster())
					end
				end,

				toggleTimeout = function()
					local Settings = getgenv().Things.Specifics[game.PlaceId].Settings

					getgenv().Things.Specifics[game.PlaceId].Settings.AntiTimeout = not Settings.AntiTimeout
				end,

				glitchInfiniteEXP = function()
					getupvalues(getgenv().Things.Specifics[game.PlaceId].Functions["OCE"])[8].DoubleExp(1, 86400)
				end,
			}
		}
	}
}

local gmt = getrawmetatable(game)
setreadonly(gmt, false)

oldNameCall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
	local Args = {...}
	local method = getnamecallmethod()
	local Script = getcallingscript()
	local instance = self

	if getgenv().Things.Specifics[game.PlaceId] and table.find({"FireServer"}, method) and instance.Parent == game.ReplicatedStorage then
		if getgenv().Things.Specifics[game.PlaceId].Keys.Event and getgenv().Things.Specifics[game.PlaceId].Keys.Event == self then
			getgenv().Things.Specifics[game.PlaceId].Keys.numPass = getgenv().Things.Specifics[game.PlaceId].Keys.numPass + 3

			if not Script then -- to make sure we are the ones firing the event nil means it's us if there is script linked then the game is calling the event
				getgenv().Things.Specifics[game.PlaceId].Functions.updateNormalFirePass(getgenv().Things.Specifics[game.PlaceId].Keys.numPass)
			else
				getgenv().Things.Specifics[game.PlaceId].Keys.Pass = Args[2]
				getgenv().Things.Specifics[game.PlaceId].Keys.numPass = getgenv().Things.Specifics[game.PlaceId].Functions.returnNormalFirePass()	
			end

			return oldNameCall(self, unpack(Args))
		end

		getgenv().Things.Specifics[game.PlaceId].Keys.Event = self
		getgenv().Things.Specifics[game.PlaceId].Keys.Pass = Args[2]
		getgenv().Things.Specifics[game.PlaceId].Keys.numPass = Args[1]
		print("Set:", self, "numPass:", Args[1], "Pass:", Args[2])
	end

	return oldNameCall(self, ...)
end))

-- Functions
local function addRemote(Remote)
	if table.find(ignoreList, Remote.Parent.Name) then return end
	if not Remote or (Remote and Remote.Name == "") then return end

	getgenv().Things.Remotes[Remote.Name] = Remote
end


-- Events
local gameDescAdded
gameDescAdded = game.DescendantAdded:Connect(function(Object)
	if Object:IsA("RemoteEvent") or Object:IsA("RemoteFunction") then
		addRemote(Object)
	end

	if Object:IsA("LocalScript") or Object:IsA("ModuleScript") and not table.find(ignoreList, Object.Parent.Name) then
		getgenv().Things.Scripts[Object.Name] = Object
	end

	getgenv().Things.Wrkspace[Object] = Object.Name
end)

local repFirstAdded
repFirstAdded = game:GetService("ReplicatedFirst").DescendantAdded:Connect(function(Script)
	if Script:IsA("LocalScript") or Script:IsA("ModuleScript") or Script.Name == "ScreenGui" then
		getgenv().Things.RFService[Script.Name] = Script
	end
end)

-- Autoexec
task.spawn(function()
	for i, Script in pairs (game:GetService("ReplicatedFirst"):GetDescendants()) do
		task.spawn(function()
			if Script:IsA("LocalScript") or Script:IsA("ModuleScript") then
				getgenv().Things.RFService[Script.Name] = Script
			end
		end)
	end
end)

task.spawn(function()
	for i, Object in pairs (game:GetDescendants()) do
		task.spawn(function()
			getgenv().Things.Wrkspace[Object] = Object.Name

			if Object:IsA("LocalScript") or Object:IsA("ModuleScript") then
				getgenv().Things.Scripts[Object.Name] = Object
			end

			if Object:IsA("RemoteEvent") or Object:IsA("RemoteFunction") then
				addRemote(Object)
			end
		end)
	end
end)

getgenv().Things.Functions.LoadMapNames = function()
	for i, v in pairs (workspace:GetDescendants()) do
		if getgenv().Things.Wrkspace[v] then
			v.Name = getgenv().Things.Wrkspace[v]
		end
	end
end

repeat wait() until game.Players.LocalPlayer and game.Players.LocalPlayer.Character
for autoexecName, autoexecFunc in pairs (getgenv().Things.Specifics[game.PlaceId].Autoexecs) do
	autoexecFunc()
	print("Autoexec", autoexecName, "executed")
end

gameDescAdded:Disconnect()
