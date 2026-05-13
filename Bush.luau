local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Assets = ReplicatedStorage:WaitForChild("Assets")
local Objects = Assets:WaitForChild("Objects")

local Generation = require(script.Parent)

local Bush = {}
Bush.__index = Bush
setmetatable(Bush, Generation)

function Bush.new()
	local self = setmetatable({}, Bush)
	
	self.Object = Generation.FindObject("Bush")
	self.Module = Generation.FindModule("Bush")
	
	return self
end

function Bush:Spawn()
	local Main : BasePart = self.Object.Main
	local SpawnPart = self.Object.SpawnPart

	local PosX = SpawnPart.Position.X
	local PosY = SpawnPart.Position.Y
	local PosZ = SpawnPart.Position.Z
	
	local CollectedLoot = 0
	local MaxLoot = math.random(1,5)
	
	for i = 1, MaxLoot do
		local PosFormula = Vector3.new(PosX + math.random(-3,3) / self.Object:GetScale(), PosY + math.random(5,20) / 10, PosZ + math.random(-3,3) / self.Object:GetScale())

		local Berry = Instance.new("Part")
		Berry.Anchored = true
		Berry.CanCollide = false
		Berry.Color = Color3.fromRGB(97, 44, 255)
		Berry.Material = Enum.Material.SmoothPlastic
		Berry.Size = Vector3.new(1,1,1)
		Berry.Position = PosFormula
		Berry.Name = "Berry"
		
		local Prox : ProximityPrompt = Instance.new("ProximityPrompt")
		Prox.ActionText = "Collect"
		Prox.ObjectText = "Berry"
		Prox.HoldDuration = 0.5
		Prox.RequiresLineOfSight = false
		Prox.Parent = Berry
		
		Prox.Triggered:Connect(function()
			Berry:Destroy()
			CollectedLoot += 1
			
			if CollectedLoot == MaxLoot then
				self.Object:Destroy()
			end
		end)

		Berry.Parent = self.Object:WaitForChild("Loot")
	end
end

return Bush
