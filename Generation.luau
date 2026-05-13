local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Assets = ReplicatedStorage:WaitForChild("Assets")
local Events = ReplicatedStorage:WaitForChild("Events")

local Objects = Assets:WaitForChild("Objects")
local Remotes = Events:WaitForChild("Remotes")

local Generation = {}
Generation.__index = Generation

Generation.GenerateRadius = 250
Generation.MaxSpawn = 50
Generation.GenerateCooldown = 1

function Generation.FindModule(name : string)
	return script:FindFirstChild(name)
end

function Generation.FindObject(name : string)
	return Objects:FindFirstChild(name)
end

function Generation:Generate()
	if #workspace:WaitForChild("Objects"):GetChildren() > Generation.MaxSpawn then return end
	
	local Baseplate = workspace:WaitForChild("Baseplate")
	
	self.Object  = self.Object:Clone()
	self.Object:ScaleTo(self.Object:GetScale() + math.random(0,5) / 10)
	self.Object.Parent = workspace:WaitForChild("Objects")
	self.Object:PivotTo(CFrame.new(Baseplate.Position.X + math.random(-Generation.GenerateRadius,Generation.GenerateRadius), self.Object.PrimaryPart.Position.X, Baseplate.Position.Z + math.random(-Generation.GenerateRadius,Generation.GenerateRadius)) * CFrame.Angles(0,math.random(1,360), 0))
	
	task.spawn(function()
		Remotes:WaitForChild("GenerationAnimation"):FireAllClients(self.Object)
	end)
end

function Generation:Spawn()
	local succ, err = pcall(function()
		self.Module:Spawn()
	end)
	
	if not succ then
		warn(err)
	end
end

function Generation.Init()
	while task.wait(Generation.GenerateCooldown) do
		local RandomObject = require(script:GetChildren()[math.random(1, #script:GetChildren())]).new()
		RandomObject:Generate()

		RandomObject:Spawn()
	end
end

return Generation
