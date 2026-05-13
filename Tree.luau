local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Assets = ReplicatedStorage:WaitForChild("Assets")
local Objects = Assets:WaitForChild("Objects")

local Generation = require(script.Parent)

local Tree = {}
Tree.__index = Tree
setmetatable(Tree, Generation)

function Tree.new()
	local self = setmetatable({}, Tree)
	
	self.Object = Generation.FindObject("Tree")
	self.Module = Generation.FindModule("Tree")
	
	return self
end

function Tree:Spawn()
	local Main : BasePart = self.Object.Main
	local SpawnPart = self.Object.SpawnPart
	
	local PosX = SpawnPart.Position.X
	local PosY = SpawnPart.Position.Y
	local PosZ = SpawnPart.Position.Z
	
	local CollectedLoot = 0
	local MaxLoot = math.random(2,5)
	
	for i = 1, MaxLoot do
		local PosFormula = Vector3.new(PosX + math.random(-3,3) / self.Object:GetScale(), PosY + math.random(5,20) / 10, PosZ + math.random(-3,3) / self.Object:GetScale())

		local Apple = Instance.new("Part")
		Apple.Anchored = true
		Apple.CanCollide = false
		Apple.Color = Color3.fromRGB(255, 0, 0)
		Apple.Material = Enum.Material.SmoothPlastic
		Apple.Size = Vector3.new(1,1,1)
		Apple.Position = PosFormula
		Apple.Name = "Apple"
		
		local Prox : ProximityPrompt = Instance.new("ProximityPrompt")
		Prox.ActionText = "Collect"
		Prox.ObjectText = "Apple"
		Prox.HoldDuration = 0.5
		Prox.RequiresLineOfSight = false
		Prox.Parent = Apple
		
		Prox.Triggered:Connect(function()
			Apple:Destroy()
			CollectedLoot += 1
			
			if CollectedLoot == MaxLoot then
				self.Object:Destroy()
			end
		end)

		Apple.Parent = self.Object:WaitForChild("Loot")
	end
end

return Tree
