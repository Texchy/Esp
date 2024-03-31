local Bracket = loadstring(game:HttpGet("https://raw.githubusercontent.com/AlexR32/Bracket/main/BracketV33.lua"))()

local Window = Bracket:Window({
	Name = "TYPE://SOUL [UPDATE W.I.P] DROWNED HUB",
	Enabled = true,
	Color = Color3.new(0.313725, 0.356862, 0.925490),
	Size = UDim2.new(0, 450, 0, 496),
	Position = UDim2.new(0.6, -247, 0.4, -243),
})

local Watermark = Window:Watermark({
	Title = "[Drowned Hub]",
	Flag = "UI/Watermark/Position",
	Enabled = true,
})

local MainTab = Window:Tab({ Name = "Main" })
local FarmTab = Window:Tab({ Name = "Farm" })
local StatsTab = Window:Tab({ Name = "AutoStats" })
local VisualTab = Window:Tab({ Name = "Visual" })
local SkillTab = Window:Tab({ Name = "AutoSkill" })
local MiscTab = Window:Tab({ Name = "Misc" })
local OptionsTab = Window:Tab({ Name = "Options" })

local MainSection = MainTab:Section({ Name = "MainSection", Side = "left" })
local MainSection2 = MainTab:Section({ Name = "Others", Side = "Right" })

MainSection:Divider()
local AdvancedSpeedModdes = "Velocity"
local AdvancedSpeedVal = 25
local SpeedKeepJump = false
local SpeedKeepJumpReal = false
local SpeedWallCheck = false
local SpeedBypassDelay = 1.103300000000001
local SpeedBypassDuration = 2.5178200000000004
local FakeJumpHeight = 6

players = game:GetService("Players")
speaker = players.LocalPlayer or player:GetPropertyChangedSignal("LocalPlayer"):Wait() and players.LocalPlayer
Mouse = speaker:GetMouse()
char = speaker.Character or speaker.CharacterAdded:Wait()

workspace = game:GetService("Workspace")
Camera = workspace.CurrentCamera

CGUI = game:GetService("CoreGui")
SGUI = game:GetService("StarterGui")
GUIS = game:GetService("GuiService")
ChatService = game:GetService("Chat")
Lighting = game:GetService("Lighting")
UIS = game:GetService("UserInputService")
DebrisService = game:GetService("Debris")
RunService = game:GetService("RunService")
MS = game:GetService("MarketplaceService")
HttpService = game:GetService("HttpService")
CAS = game:GetService("ContextActionService")
SoundService = game:GetService("SoundService")
TweenService = game:GetService("TweenService")
NetworkClient = game:GetService("NetworkClient")
TeleportService = game:GetService("TeleportService")
textChatService = game:GetService("TextChatService")
MaterialService = game:GetService("MaterialService")
ReplicatedStorage = game:GetService("ReplicatedStorage")
PathfindingService = game:GetService("PathfindingService")
ProximityPromptService = game:GetService("ProximityPromptService")

local RunLoops = {
	RenderStepTable = {},
	StepTable = {},
	HeartTable = {},
}

do
	function RunLoops:BindToRenderStep(name, func)
		if RunLoops.RenderStepTable[name] == nil then
			RunLoops.RenderStepTable[name] = RunService.RenderStepped:Connect(func)
		end
	end

	function RunLoops:UnbindFromRenderStep(name)
		if RunLoops.RenderStepTable[name] then
			RunLoops.RenderStepTable[name]:Disconnect()
			RunLoops.RenderStepTable[name] = nil
		end
	end

	function RunLoops:BindToStepped(name, func)
		if RunLoops.StepTable[name] == nil then
			RunLoops.StepTable[name] = RunService.Stepped:Connect(func)
		end
	end

	function RunLoops:UnbindFromStepped(name)
		if RunLoops.StepTable[name] then
			RunLoops.StepTable[name]:Disconnect()
			RunLoops.StepTable[name] = nil
		end
	end

	function RunLoops:BindToHeartbeat(name, func)
		if RunLoops.HeartTable[name] == nil then
			RunLoops.HeartTable[name] = RunService.Heartbeat:Connect(func)
		end
	end

	function RunLoops:UnbindFromHeartbeat(name)
		if RunLoops.HeartTable[name] then
			RunLoops.HeartTable[name]:Disconnect()
			RunLoops.HeartTable[name] = nil
		end
	end
end

function r15(plr)
	if plr.Character:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R15 then
		return true
	end
end
function getRoot(char)
	local rootPart = char:FindFirstChild("HumanoidRootPart")
		or char:FindFirstChild("Torso")
		or char:FindFirstChild("UpperTorso")
	return rootPart
end
function tools(plr)
	if
		plr:FindFirstChildOfClass("Backpack"):FindFirstChildOfClass("Tool")
		or plr.Character:FindFirstChildOfClass("Tool")
	then
		return true
	end
end
function isNumber(num)
	if tonumber(num) ~= nil or num == "inf" then
		return true
	end
end
function copyTool(path)
	for i, c in pairs(path:GetDescendants()) do
		if c:IsA("Tool") or c:IsA("HopperBin") then
			c:Clone().Parent = speaker:FindFirstChildOfClass("Backpack")
		end
		copyTool(c)
	end
end
function findTouchInterest(tool)
	return tool and tool:FindFirstChildWhichIsA("TouchTransmitter", true)
end
function say(message)
	ReplicatedStorage:WaitForChild("DefaultChatSystemChatEvents")
		:WaitForChild("SayMessageRequest")
		:FireServer(message, "All")
end
function isAlive()
	if getRoot(speaker.Character) then
		return true
	end
end

AdvancedSpede = false
getgenv().Speed = false
local SpeedToggle = MainSection:Toggle({
	Name = "Speed",
	Callback = function(Value)
		SpeedToggleState = Value
		if Value then
			local BypassTick = tick()
			task.spawn(function()
				repeat
					BypassTick = tick() + (SpeedBypassDuration / 100)
					task.wait((SpeedBypassDelay / 10) + (SpeedBypassDuration / 100))
				until AdvancedSpede == false
			end)

			RunLoops:BindToHeartbeat("AdvancedSpeed", function(dt)
				if not getRoot(speaker.Character) then
					return
				end

				local Speed = AdvancedSpeedVal
				local Humanoid = speaker.character.Humanoid
				local RootPart = speaker.character:WaitForChild("HumanoidRootPart")
				local MoveDirection = Humanoid.MoveDirection
				local Velocity = RootPart.Velocity
				local X, Z = MoveDirection.X * Speed, MoveDirection.Z * Speed

				if AdvancedSpeedModdes == "Velocity" then
					RootPart.Velocity = Vector3.new(X, Velocity.Y, Z)
				elseif AdvancedSpeedModdes == "CFrame" then
					local Factor = Speed - Humanoid.WalkSpeed
					local MoveDirection = (MoveDirection * Factor) * dt
					local newpos = (MoveDirection * (math.max(Speed - speaker.character.Humanoid.WalkSpeed, 0) * dt))
					if SpeedWallCheck == true then
						local ray = workspace:Raycast(speaker.character.HumanoidRootPart.Position, newpos, SpeedRaycast)
						if ray then
							newpos = (ray.Position - speaker.character.HumanoidRootPart.Position)
						end
					end

					RootPart.CFrame = RootPart.CFrame + newpos
				elseif AdvancedSpeedModdes == "Linear Velocity" then
					LinearVelocity = speaker.character.HumanoidRootPart:FindFirstChildOfClass("LinearVelocity")
						or Instance.new("LinearVelocity", speaker.character.HumanoidRootPart)
					LinearVelocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Line
					LinearVelocity.Attachment0 = speaker.character.HumanoidRootPart:FindFirstChildOfClass("Attachment")
					LinearVelocity.MaxForce = 9e9
					LinearVelocity.LineDirection = MoveDirection
					LinearVelocity.LineVelocity = (MoveDirection.X ~= 0 and MoveDirection.Z) and Speed or 0
				elseif AdvancedSpeedModdes == "ASM Linear Velocity" then
					RootPart.AssemblyLinearVelocity = Vector3.new(X, Velocity.Y, Z)
				elseif AdvancedSpeedModdes == "Body Velocity" then
					BodyVelocity = speaker.character.HumanoidRootPart:FindFirstChildOfClass("BodyVelocity")
						or Instance.new("BodyVelocity", speaker.character.HumanoidRootPart)
					BodyVelocity.Velocity = Vector3.new(X, 2, Z)
					BodyVelocity.MaxForce = Vector3.new(9e9, 0, 9e9)
				elseif AdvancedSpeedModdes == "Bypass" then
					local pulsenum = (SpeedBypassDuration / 100)
					local newvelo = MoveDirection
						* (
							Speed
							+ (speaker.character.Humanoid.WalkSpeed - Speed)
								* (1 - (math.max(BypassTick - tick(), 0)) / pulsenum)
						)
					RootPart.Velocity = Vector3.new(newvelo.X, RootPart.Velocity.Y, newvelo.Z)
				end

				if SpeedKeepJump == true then
					local State = speaker.character.Humanoid:GetState()
					local MoveDirection = speaker.character.Humanoid.MoveDirection
					if State == Enum.HumanoidStateType.Running and MoveDirection ~= Vector3.zero then
						if SpeedKeepJumpReal == true then
							speaker.character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
						else
							speaker.character.HumanoidRootPart.Velocity = Vector3.new(
								speaker.character.HumanoidRootPart.Velocity.X,
								FakeJumpHeight,
								speaker.character.HumanoidRootPart.Velocity.Z
							)
						end
					end
				end
			end)
		else
			SpeedDelayTick = 0
			RunLoops:UnbindFromHeartbeat("AdvancedSpeed")

			if LinearVelocity then
				LinearVelocity:Destroy()
				LinearVelocity = nil
			end
			if BodyVelocity then
				BodyVelocity:Destroy()
				BodyVelocity = nil
			end
		end
	end,
})
local SpeedKeybind = SpeedToggle:Keybind({ Name = "Speed Keybind", Flag = "Main/Speed/Keybind", Default = "LeftShift" })

MainSection:Slider({
	Name = "Speed Slider",
	Flag = "Main/Speed",
	Min = 0,
	Max = 250,
	Value = 0,
	Callback = function(Value)
		AdvancedSpeedVal = Value
	end,
})

function calculateMoveVector(cameraRelativeMoveVector)
	local c, s
	local _, _, _, R00, R01, R02, _, _, R12, _, _, R22 = Camera.CFrame:GetComponents()
	if R12 < 1 and R12 > -1 then
		c = R22
		s = R02
	else
		c = R00
		s = -R01 * math.sign(R12)
	end
	local norm = math.sqrt(c * c + s * s)
	return Vector3.new(
		(c * cameraRelativeMoveVector.X + s * cameraRelativeMoveVector.Z) / norm,
		0,
		(c * cameraRelativeMoveVector.Z - s * cameraRelativeMoveVector.X) / norm
	)
end

local FlyRaycast = RaycastParams.new()
FlyRaycast.FilterType = Enum.RaycastFilterType.Blacklist
FlyRaycast.RespectCanCollide = true
local FlyJumpCFrame = CFrame.new(0, 0, 0)
local FlyAliveCheck = false
local FlyUp = false
local FlyDown = false
local FlyY = 0
local FlightFloorPart
local w = 0
local s = 0
local a = 0
local d = 0
local FlightConnections = {}

function split(str, delim)
	local broken = {}
	if delim == nil then
		delim = ","
	end
	for w in string.gmatch(str, "[^" .. delim .. "]+") do
		table.insert(broken, w)
	end
	return broken
end

local FlyKeys = "E/Q"
local FlightWallCheck = true
local FlightVerticalSpeed = 35
local FlightSpeed = 35
local FlightMode = "Bypass"
local FlightState = nil
local FlyToggle = MainSection:Toggle({
	Name = "Fly",
	Callback = function(state)
		if state then
			local FlyPlatformTick = tick() + 0.2
			w = UIS:IsKeyDown(Enum.KeyCode.W) and -1 or 0
			s = UIS:IsKeyDown(Enum.KeyCode.S) and 1 or 0
			a = UIS:IsKeyDown(Enum.KeyCode.A) and -1 or 0
			d = UIS:IsKeyDown(Enum.KeyCode.D) and 1 or 0

			local FlyVDirection = 0
			local FlyUp = false
			local FlyDown = false

			table.insert(
				FlightConnections,
				UIS.InputBegan:Connect(function(input1)
					if UIS:GetFocusedTextBox() ~= nil then
						return
					end
					if input1.KeyCode == Enum.KeyCode.W then
						w = -1
					elseif input1.KeyCode == Enum.KeyCode.S then
						s = 1
					elseif input1.KeyCode == Enum.KeyCode.A then
						a = -1
					elseif input1.KeyCode == Enum.KeyCode.D then
						d = 1
					end
					local divided = FlyKeys:split("/")
					if input1.KeyCode == Enum.KeyCode[divided[1]] then
						FlyUp = true
					elseif input1.KeyCode == Enum.KeyCode[divided[2]] then
						FlyDown = true
					end
				end)
			)
			table.insert(
				FlightConnections,
				UIS.InputEnded:Connect(function(input1)
					local divided = FlyKeys:split("/")
					if input1.KeyCode == Enum.KeyCode.W then
						w = 0
					elseif input1.KeyCode == Enum.KeyCode.S then
						s = 0
					elseif input1.KeyCode == Enum.KeyCode.A then
						a = 0
					elseif input1.KeyCode == Enum.KeyCode.D then
						d = 0
					elseif input1.KeyCode == Enum.KeyCode[divided[1]] then
						FlyUp = false
					elseif input1.KeyCode == Enum.KeyCode[divided[2]] then
						FlyDown = false
					end
				end)
			)

			if FlightMode == "Jump" and isAlive() then
				speaker.character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			end

			local FlyTP = false
			local FlyTPTick = tick()
			local FlyTPY

			RunLoops:BindToHeartbeat("Fly", function(delta)
				if isAlive() then
					if not FlyY then
						FlyY = speaker.character.HumanoidRootPart.CFrame.p.Y
					end
					local movevec = (
						FlightMoveMethod == "Manual" and calculateMoveVector(Vector3.new(a + d, 0, w + s))
						or speaker.character.Humanoid.MoveDirection
					).Unit
					movevec = movevec == movevec and Vector3.new(movevec.X, 0, movevec.Z) or Vector3.zero

					if FlightState ~= "none" then
						if FlightMode == "Velocity" then
							speaker.character.Humanoid:ChangeState(Enum.HumanoidStateType[FlightState])
						end
					end

					if FlightNoVelo == true then
						speaker.Character.HumanoidRootPart.Velocity = Vector3.zero
					end

					if FlightMode == "Velocity" or FlightMode == "Bypass" then
						speaker.character.HumanoidRootPart.Velocity = (movevec * FlightSpeed)
							+ Vector3.new(
								0,
								0.85
									+ (FlightMode == "Bypass" and (tick() % 0.5 > 0.25 and -10 or 10) or 0)
									+ (FlyUp and FlightVerticalSpeed or 0)
									+ (FlyDown and -FlightVerticalSpeed or 0),
								0
							)
					else
						if FlyUp then
							FlyY = FlyY + (FlightVerticalSpeed * delta)
						end
						if FlyDown then
							FlyY = FlyY - (FlightVerticalSpeed * delta)
						end

						local newMovementPosition = (
							movevec * (math.max(FlightSpeed - speaker.character.Humanoid.WalkSpeed, 0) * delta)
						)
						newMovementPosition = Vector3.new(
							newMovementPosition.X,
							(FlyY - speaker.character.HumanoidRootPart.CFrame.p.Y),
							newMovementPosition.Z
						)

						if FlightWallCheck == true then
							FlyRaycast.FilterDescendantsInstances = { speaker.Character, Camera }
							local ray = workspace:Raycast(
								speaker.character.HumanoidRootPart.Position,
								newMovementPosition,
								FlyRaycast
							)
							if ray and ray.Instance.CanCollide then
								newMovementPosition = (ray.Position - speaker.character.HumanoidRootPart.Position)
								FlyY = ray.Position.Y
							end
						end

						if FlightMode == "CFrame" then
							speaker.character.HumanoidRootPart.CFrame = speaker.character.HumanoidRootPart.CFrame
								+ newMovementPosition
						elseif FlightMode == "Jump" then
							speaker.character.HumanoidRootPart.CFrame = speaker.character.HumanoidRootPart.CFrame
								+ Vector3.new(newMovementPosition.X, 0, newMovementPosition.Z)
							if
								speaker.character.HumanoidRootPart.Velocity.Y
								< -(
									speaker.character.Humanoid.JumpPower
									- ((FlyUp and FlightVerticalSpeed or 0) - (FlyDown and FlightVerticalSpeed or 0))
								)
							then
								FlyJumpCFrame = speaker.character.HumanoidRootPart.CFrame
									* CFrame.new(0, -speaker.character.Humanoid.HipHeight, 0)
								speaker.character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
							end
						elseif FlightMode == "Teleport" then
							if FlyTPTick <= tick() then
								FlyTP = not FlyTP
								if FlyTP then
									if FlyTPY then
										FlyY = FlyTPY
									end
								else
									FlyTPY = FlyY
									FlyRaycast.FilterDescendantsInstances = { speaker.Character, Camera }
									local ray = workspace:Raycast(
										speaker.character.HumanoidRootPart.Position,
										Vector3.new(0, -10000, 0),
										FlyRaycast
									)
									if ray then
										FlyY = ray.Position.Y
											+ (
												(speaker.character.HumanoidRootPart.Size.Y / 2)
												+ speaker.character.Humanoid.HipHeight
											)
									end
								end
								FlyTPTick = tick() + ((FlyTP and FlightTpOn or FlightTpOff) / 10)
							end
							speaker.character.HumanoidRootPart.CFrame = speaker.character.HumanoidRootPart.CFrame
								+ newMovementPosition
						end

						if FlightFloor == true then
							FlightFloorPart = FlightFloorPart or Instance.new("Part", workspace)
							FlightFloorPart.CanQuery = false
							FlightFloorPart.Anchored = true
							FlightFloorPart.CanCollide = true
							FlightFloorPart.Material = 288
							FlightFloorPart.Color = Library.colors.main
							FlightFloorPart.Size = Vector3.new(3, 0.5, 3)
							FlightFloorPart.CFrame = (
								FlightMode == "Jump" and FlyJumpCFrame
								or speaker.character.HumanoidRootPart.CFrame
									* CFrame.new(
										0,
										-(
												speaker.character.Humanoid.HipHeight
												+ (speaker.character.HumanoidRootPart.Size.Y / 2)
												+ 0.53
											),
										0
									)
							)
							FlightFloorPart.Transparency = 0.5

							if FlyUp or FlyPlatformTick >= tick() then
								speaker.character.Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
							end
						else
							if FlightFloorPart then
								FlightFloorPart:Destroy()
								FlightFloorPart = nil
							end
						end
					end
				else
					FlyY = nil
				end
			end)
		else
			FlyUp = false
			FlyDown = false
			FlyY = nil
			RunLoops:UnbindFromHeartbeat("Fly")
			FlightConnections = {}
			if FlightFloorPart then
				FlightFloorPart:Destroy()
				FlightFloorPart = nil
			end
			speaker.character.Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
		end
	end,
})

local FlyKeybind = FlyToggle:Keybind({ Name = "Fly Keybind", Flag = "Main/Fly/Keybind", Default = "X" })
MainSection:Slider({
	Name = "Fly Slider",
	Flag = "Main/Fly",
	Min = 0,
	Max = 250,
	Value = 0,
	Callback = function(Value)
		FlightSpeed = Value
		FlightVerticalSpeed = Value
	end,
})

local PhaseRaycast = RaycastParams.new()
PhaseRaycast.RespectCanCollide = true
PhaseRaycast.FilterType = Enum.RaycastFilterType.Blacklist

local PhaseOverlap = OverlapParams.new()
PhaseOverlap.MaxParts = 9e9
PhaseOverlap.FilterDescendantsInstances = {}
local PhaseModifiedParts = {}

local NoclipToggle = MainSection:Toggle({
	Name = "Noclip",
	Callback = function(state)
		if state then
			RunLoops:BindToStepped("NoclipAround", function()
				local chars = { Camera, speaker.Character }
				for i, v in pairs(players:GetPlayers()) do
					table.insert(chars, v.Character)
				end

				PhaseOverlap.FilterDescendantsInstances = chars
				local rootpos = speaker.character.HumanoidRootPart.CFrame.p
				local parts = workspace:GetPartBoundsInRadius(rootpos, 2, PhaseOverlap)

				for i, v in pairs(parts) do
					if
						v.CanCollide
						and (v.Position.Y + (v.Size.Y / 2)) > (rootpos.Y - speaker.character.Humanoid.HipHeight)
					then
						PhaseModifiedParts[v] = true
						v.CanCollide = false
					end
				end
				for i, v in pairs(PhaseModifiedParts) do
					if not table.find(parts, i) then
						PhaseModifiedParts[i] = nil
						i.CanCollide = true
					end
				end
			end)
		else
			RunLoops:UnbindFromStepped("NoclipAround")
			for i, v in pairs(PhaseModifiedParts) do
				if i then
					i.CanCollide = true
				end
			end
			table.clear(PhaseModifiedParts)
		end
	end,
})

local NoclipKeybind = NoclipToggle:Keybind({ Name = "Noclip Keybind", Flag = "Main/Noclip/Keybind", Default = "Z" })
local LightAttack = MainSection2:Toggle({
	Name = "Auto Light Attack",
	Callback = function(state)
		if state then
			RunLoops:BindToStepped("LightAttack", function()
				local args = {
					[1] = "LightAttack",
				}

				game:GetService("ReplicatedStorage")
					:WaitForChild("Remotes")
					:WaitForChild("ServerCombatHandler")
					:FireServer(unpack(args))
				task.wait()
			end)
		else
			RunLoops:UnbindFromStepped("LightAttack")
		end
	end,
})

local CritAttack = MainSection2:Toggle({
	Name = "Auto Crit Attack",
	Callback = function(state)
		if state then
			RunLoops:BindToStepped("CritAttack", function()
				local args = {
					[1] = "CriticalAttack",
				}

				game:GetService("ReplicatedStorage")
					:WaitForChild("Remotes")
					:WaitForChild("ServerCombatHandler")
					:FireServer(unpack(args))
				task.wait()
			end)
		else
			RunLoops:UnbindFromStepped("CritAttack")
		end
	end,
})

local AutoSprintToggle = MainSection2:Toggle({
	Name = "Auto Sprint",
	Callback = function(state)
		if state then
			RunLoops:BindToStepped("AutoSprintToggle", function()
				local player = game:GetService("Players").LocalPlayer
				local character = player.Character
				local humanoid = character and character:FindFirstChild("Humanoid")

				if humanoid and humanoid.MoveDirection.Magnitude > 1 then
					local args = {
						[1] = "Pressed",
					}

					player.Character.CharacterHandler.Remotes.Sprint:FireServer(unpack(args))
				end

				task.wait()
			end)
		else
			RunLoops:UnbindFromStepped("AutoSprintToggle")
			local args = {
				[1] = "Released",
			}

			game.Players.LocalPlayer.Character.CharacterHandler.Remotes.Sprint:FireServer(unpack(args))
		end
	end,
})

local FarmSection = FarmTab:Section({ Name = "FarmSection", Side = "left" })
local FarmPlayerSection = FarmTab:Section({ Name = "Player Farm", Side = "Right" })

FarmSection:Divider()

local MobFarmToggle = FarmSection:Toggle({
	Name = "MobFarm",
	Callback = function(State)
		-- Your code here
	end,
})

local MobSelectorDropdown = FarmSection:Dropdown({
	Name = "Mob Selector",
	Flag = "Farm/MobSelector",
	List = {
		{
			Name = "Mob 1",
			Mode = "Button",
			Callback = function()
				-- Code to select mob 1
			end,
		},
		{
			Name = "Mob 2",
			Mode = "Button",
			Callback = function()
				-- Code to select mob 2
			end,
		},
		-- Add more mobs as needed
	},
})

local players = {}

-- Get player names and data from workspace.Entities
for _, obj in ipairs(workspace.Entities:GetChildren()) do
	if game.Players:FindFirstChild(obj.Name) then
		players[#players + 1] = {
			Name = obj.Name,
			Mode = "Toggle",
			Value = false,
			Callback = function(Selected)
				print(Selected)
			end,
		}
	end
end

local PlayerSelectorDropdown = FarmPlayerSection:Dropdown({
	Name = "Player Selector",
	Flag = "PlayerSelector",
	Side = "Left",
	List = players,
})

-- Clear the dropdown and add the players as options
PlayerSelectorDropdown:Clear()
for _, player in ipairs(players) do
	PlayerSelectorDropdown:AddOption(player)
end

local FollowPlayerToggle = FarmPlayerSection:Toggle({
	Name = "Follow Player",
	Callback = function(State)
		if State then
			local selectedPlayer = selectedplayer
			if selectedPlayer then
				local humanoid = game.Players.LocalPlayer.Character
					and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
				local bodyVelocity = Instance.new("BodyVelocity")
				bodyVelocity.Velocity = (selectedPlayer.Character.PrimaryPart.Position - humanoid.RootPart.Position).Unit
					* 150
				bodyVelocity.Parent = humanoid.RootPart
				humanoid.HipHeight = -3 -- Make the player go underground
				while (humanoid.RootPart.Position - selectedPlayer.Character.PrimaryPart.Position).Magnitude > 100 do
					wait()
				end
				humanoid.RootPart.CFrame = selectedPlayer.Character.PrimaryPart.CFrame -- Teleport to the player
				bodyVelocity:Destroy()
			end
		else
			local humanoid = game.Players.LocalPlayer.Character
				and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
			if humanoid then
				humanoid.HipHeight = 0 -- Make the player come back to the ground
			end
		end
	end,
})

FarmSection:Slider({
	Name = "Farm Position",
	Flag = "Farm/Position",
	Min = 0,
	Max = 100,
	Value = 50,
	Callback = function(Value)
		-- Your code here
	end,
})

FarmSection:Slider({
	Name = "Tween Speed",
	Flag = "Farm/TweenSpeed",
	Min = 0,
	Max = 100,
	Value = 50,
	Callback = function(Value)
		-- Your code here
	end,
})

local AutoEquipToggle = FarmSection:Toggle({
	Name = "Autoequip",
	Callback = function(State)
		-- Your code here
	end,
})

local AutoQuestToggle = FarmSection:Toggle({
	Name = "Auto Quest",
	Callback = function(State)
		-- Your code here
	end,
})

FarmSection:Slider({
	Name = "Another Farm Position",
	Flag = "Farm/AnotherPosition",
	Min = 0,
	Max = 100,
	Value = 50,
	Callback = function(Value)
		-- Your code here
	end,
})

local AdjustFarmToggle = FarmSection:Toggle({
	Name = "Adjust Farm",
	Callback = function(State)
		-- Your code here
	end,
})

FarmSection:Slider({
	Name = "Close Toggle",
	Flag = "Farm/CloseToggle",
	Min = 0,
	Max = 100,
	Value = 50,
	Callback = function(Value)
		-- Your code here
	end,
})

FarmSection:Slider({
	Name = "Farm Position",
	Flag = "Farm/Position",
	Min = 0,
	Max = 100,
	Value = 50,
	Callback = function(Value)
		-- Your code here
	end,
})

FarmSection:Slider({
	Name = "Range",
	Flag = "Farm/Range",
	Min = 0,
	Max = 100,
	Value = 50,
	Callback = function(Value)
		-- Your code here
	end,
})

local StatsSection = StatsTab:Section({ Name = "StatsSection", Side = "left" })
StatsSection:Divider()

local AutoStatsToggle = StatsSection:Toggle({ Name = "Auto Hakuda" })
local StatsToggle1 = StatsSection:Toggle({ Name = "Auto Kendo" })
local StatsToggle2 = StatsSection:Toggle({ Name = "Auto kido" })
local VisualSection = VisualTab:Section({ Name = "VisualSection", Side = "left" })
-- Load custom fonts
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Load custom fonts
-- Load custom fonts
local customFont = Drawing.new("Font", "abeezee")
customFont.Data = game:HttpGet("http://themes.googleusercontent.com/static/fonts/abeezee/v1/JYPhMn-3Xw-JGuyB-fEdNA.ttf")

local customFont2 = Drawing.new("Font", "abel")
customFont2.Data = game:HttpGet("http://themes.googleusercontent.com/static/fonts/abel/v3/N59kklKPso9WzbZH9jwJSg.ttf")
-- Initialize ESP visuals table
getgenv().esp_visuals = {}

-- Function to create ESP for a player
local function createESP(player)
	local esp_text = Drawing.new("Text")
	esp_text.Text = player.Name
	esp_text.Font = customFont
	esp_text.Size = 18
	esp_text.Color = Color3.new(1, 1, 1) -- White text
	esp_text.Outline = true
	esp_text.OutlineColor = Color3.new(0, 0, 0) -- Black outline
	esp_text.Visible = true

	local esp_distance = Drawing.new("Text")
	esp_distance.Font = customFont2
	esp_distance.Size = 14
	esp_distance.Color = Color3.new(1, 0, 0) -- Red text
	esp_distance.Outline = true
	esp_distance.OutlineColor = Color3.new(0, 0, 0) -- Black outline
	esp_distance.Visible = true

	-- Update the position of the text visuals every 0.1 seconds
	local connection
	connection = RunService.Heartbeat:Connect(function()
		if player.Character and player.Character:FindFirstChild("Head") then
			local pos =
				workspace.CurrentCamera:WorldToViewportPoint(player.Character.Head.Position + Vector3.new(0, 3, 0)) -- Position above the head
			esp_text.Position = Vector2.new(pos.X, pos.Y)
			esp_distance.Position = Vector2.new(pos.X, pos.Y + 20) -- Position below the name
			esp_distance.Text = tostring(
				math.floor((player.Character.Head.Position - Players.LocalPlayer.Character.Head.Position).Magnitude)
			) .. " studs"
		else
			esp_text.Visible = false
			esp_distance.Visible = false
		end
	end)

	-- Store the ESP visuals in the table
	getgenv().esp_visuals[player] = { esp_text, esp_distance, connection }
end


-- Create ESP visuals
local EspToggle = VisualSection:Toggle({
	Name = "ESP",
	Callback = function(State)
		if State then


			ESP:Toggle(State)
        else
		ESP:Toggle(false)
        end
    end,
    TextSize = 18,
})
local TeammatesToggle = VisualSection:Toggle({
	Name = "Teammates",
	Callback = function(State)
		-- Your code here for enabling/disabling teammates display
	end,
	TextSize = 18, -- Adjust the text size as needed
})

local NamesToggle = VisualSection:Toggle({
	Name = "Names",
	Callback = function(State)
		-- Your code here for enabling/disabling names display
	end,
	TextSize = 18, -- Adjust the text size as needed
})

local BoxesToggle = VisualSection:Toggle({
	Name = "Boxes",
	Callback = function(State)
		-- Your code here for enabling/disabling boxes display
	end,
	TextSize = 18, -- Adjust the text size as needed
})

local colorofesp = Color3.new(15, 15, 15)
local ColorPicker = VisualSection:Colorpicker({
	Name = "ESP Color",
	Flag = "Visual/ESPColor",
	Value = Color3.new(1, 0, 0),
	Callback = function(Color)
		colorofesp = Color
	end,
	TextSize = 18, -- Adjust the text size as needed
})

local SkillSection = SkillTab:Section({ Name = "SkillSection", Side = "left" })
SkillSection:Divider()

local SkillToggle1 = SkillSection:Toggle({ Name = "Skill 1" })
local SkillToggle2 = SkillSection:Toggle({ Name = "Skill 2" })
local SkillToggle3 = SkillSection:Toggle({ Name = "Skill 3" })
local SkillToggle4 = SkillSection:Toggle({ Name = "Skill 4" })
local SkillToggle5 = SkillSection:Toggle({ Name = "Skill 5" })
local SkillToggle6 = SkillSection:Toggle({ Name = "Skill 6" })
local SkillToggle7 = SkillSection:Toggle({ Name = "Skill 7" })
local SkillToggle8 = SkillSection:Toggle({ Name = "Skill 8" })
local SkillToggle9 = SkillSection:Toggle({ Name = "Skill 9" })
local SkillToggle0 = SkillSection:Toggle({ Name = "Skill 0" })

local MiscLeftSection = MiscTab:Section({ Name = "MiscLeftSection", Side = "left" })
MiscLeftSection:Divider()

local MiscRightSection = MiscTab:Section({ Name = "MiscRightSection", Side = "right" })
MiscRightSection:Divider()

local ChatloggerToggle = MiscLeftSection:Toggle({
	Name = "ChatLogger",
	Callback = function(State)
		loadstring(game:HttpGet("https://raw.githubusercontent.com/mac2115/Cool-private/main/ESP", true))()
	end,
})

local ServerHopToggle = MiscLeftSection:Toggle({
	Name = "Server Hop",
	Callback = function(State)
		-- Your code here for server hopping
	end,
})

local StreamerModToggle = MiscLeftSection:Toggle({
	Name = "Streamer Mod",
	Callback = function(State)
		-- Your code here for enabling/disabling streamer mod
	end,
})

local DestroyKillBrickToggle = MiscRightSection:Toggle({
	Name = "Destroy Kill Brick",
	Callback = function(State)
		-- Your code here for enabling/disabling destroy kill brick
	end,
})

local InstantResetToggle = MiscRightSection:Toggle({
	Name = "Instant Reset",
	Callback = function(State)
		-- Your code here for enabling/disabling instant reset
	end,
})

local TweenToNPCToggle = MiscRightSection:Toggle({
	Name = "Tween to NPC",
	Callback = function(State)
		-- Your code here for enabling/disabling tween to NPC
	end,
})

local NPCDropdown = MiscRightSection:Dropdown({
	Name = "NPC Selector",
	Flag = "Misc/NPCSelector",
	List = {
		{
			Name = "NPC 1",
			Mode = "Button",
			Callback = function()
				-- Code to select NPC 1
			end,
		},
		{
			Name = "NPC 2",
			Mode = "Button",
			Callback = function()
				-- Code to select NPC 2
			end,
		},
		-- Add more NPCs as needed
	},
})

local StopTweenButton = MiscRightSection:Button({
	Name = "Stop Tween",
	Callback = function()
		-- Your code here to stop tweening
	end,
})

local MenuSection = OptionsTab:Section({ Name = "Menu", Side = "Left" })
local UIToggle = MenuSection:Toggle({
	Name = "UI Enabled",
	Flag = "UI/Enabled",
	IgnoreFlag = true,
	Value = Window.Enabled,
	Callback = function(Bool)
		Window.Enabled = Bool
	end,
})
UIToggle:Keybind({ Value = "RightShift", Flag = "UI/Keybind", DoNotClear = true })
UIToggle:Colorpicker({
	Flag = "UI/Color",
	Value = { 1, 0.25, 1, 0, true },
	Callback = function(HSVAR, Color)
		Window.Color = Color
	end,
})

MenuSection:Toggle({ Name = "Open On Load", Flag = "UI/OOL", Value = true })
MenuSection:Toggle({
	Name = "Blur Gameplay",
	Flag = "UI/Blur",
	Value = true,
	Callback = function(Bool)
		Window.Blur = Bool
	end,
})
MenuSection:Toggle({
	Name = "Watermark",
	Flag = "UI/Watermark/Enabled",
	Value = true,
	Callback = function(Bool)
		Window.Watermark.Enabled = Bool
	end,
}):Keybind({ Flag = "UI/Watermark/Keybind" })

OptionsTab:AddConfigSection("Bracket_Example", "Left")

local BackgroundSection = OptionsTab:Section({ Name = "Background", Side = "Right" })
BackgroundSection:Colorpicker({
	Name = "Color",
	Flag = "Background/Color",
	Value = { 1, 1, 0, 0, false },
	Callback = function(HSVAR, Color)
		Window.Background.ImageColor3 = Color
		Window.Background.ImageTransparency = HSVAR[4]
	end,
})
BackgroundSection:Textbox({
	HideName = true,
	Flag = "Background/CustomImage",
	Placeholder = "rbxassetid://ImageId",
	Callback = function(String, EnterPressed)
		if EnterPressed then
			Window.Background.Image = String
		end
	end,
})
BackgroundSection:Dropdown({
	HideName = true,
	Flag = "Background/Image",
	List = {
		{
			Name = "Legacy",
			Mode = "Button",
			Callback = function()
				Window.Background.Image = "rbxassetid://2151741365"
				Window.Flags["Background/CustomImage"] = ""
			end,
		},
		{
			Name = "Hearts",
			Mode = "Button",
			Callback = function()
				Window.Background.Image = "rbxassetid://6073763717"
				Window.Flags["Background/CustomImage"] = ""
			end,
		},
		{
			Name = "Abstract",
			Mode = "Button",
			Callback = function()
				Window.Background.Image = "rbxassetid://6073743871"
				Window.Flags["Background/CustomImage"] = ""
			end,
		},
		{
			Name = "Hexagon",
			Mode = "Button",
			Callback = function()
				Window.Background.Image = "rbxassetid://6073628839"
				Window.Flags["Background/CustomImage"] = ""
			end,
		},
		{
			Name = "Circles",
			Mode = "Button",
			Callback = function()
				Window.Background.Image = "rbxassetid://6071579801"
				Window.Flags["Background/CustomImage"] = ""
			end,
		},
		{
			Name = "Lace With Flowers",
			Mode = "Button",
			Callback = function()
				Window.Background.Image = "rbxassetid://6071575925"
				Window.Flags["Background/CustomImage"] = ""
			end,
		},
		{
			Name = "Floral",
			Mode = "Button",
			Callback = function()
				Window.Background.Image = "rbxassetid://5553946656"
				Window.Flags["Background/CustomImage"] = ""
			end,
			Value = true,
		},
		{
			Name = "Halloween",
			Mode = "Button",
			Callback = function()
				Window.Background.Image = "rbxassetid://11113209821"
				Window.Flags["Background/CustomImage"] = ""
			end,
		},
		{
			Name = "Christmas",
			Mode = "Button",
			Callback = function()
				Window.Background.Image = "rbxassetid://11711560928"
				Window.Flags["Background/CustomImage"] = ""
			end,
		},
	},
})
BackgroundSection:Slider({
	Name = "Tile Offset",
	Flag = "Background/Offset",
	Wide = true,
	Min = 74,
	Max = 293,
	Value = 74,
	Callback = function(Number)
		Window.Background.TileSize = UDim2.fromOffset(Number, Number)
	end,
})

Window:SetValue("Background/Offset", 74)
Window:AutoLoadConfig("Bracket_Example")
Window:SetValue("UI/Enabled", Window.Flags["UI/OOL"])
