local BackpackGUI = script.Parent

local TooltipFrame = BackpackGUI:WaitForChild("Tooltip")

local MainFrame = BackpackGUI:WaitForChild("Main")
local BodyFrame = MainFrame:WaitForChild("Body")
local Buttons = BodyFrame:WaitForChild("Categories"):WaitForChild("Buttons")
local PetsButton = Buttons:WaitForChild("pets")

local ScrollingFrame = BodyFrame:WaitForChild("ScrollComplex"):WaitForChild("ScrollingFrame")
local PetsFrame = ScrollingFrame:WaitForChild("pets")

local BackpackButton = BackpackGUI:WaitForChild("OpenBackpack")

local PetTemplate = script:WaitForChild("PetTemplate")

local RS = game:GetService("ReplicatedStorage")
local GetPets = RS:WaitForChild("GetPets")
local EquipPet = RS:WaitForChild("EquipPet")

BackpackButton.MouseButton1Click:Connect(function()
	MainFrame.Visible = not MainFrame.Visible
end)

PetsButton.MouseButton1Click:Connect(function()
	PetsFrame.Visible = true
	
	local Pets = GetPets:InvokeServer()
	if Pets then
		for _, frame in pairs(PetsFrame:GetChildren()) do
			if frame:IsA("Frame") then
				frame:Destroy()
			end
		end		
		
		for PetName, PetModel in pairs(Pets) do
			local Frame = PetTemplate:Clone()
			Frame.PetName.Text = PetName
			Frame.Parent = PetsFrame
			
			local viewportFrame = Frame:WaitForChild("ViewportFrame")
			
			local Pet = PetModel:Clone()
			Pet.Parent = viewportFrame
			
			local HumRP = Pet:WaitForChild("HumanoidRootPart")
			
			local viewportCamera = Instance.new("Camera")
			viewportFrame.CurrentCamera = viewportCamera
			viewportCamera.Parent = viewportFrame
			
			viewportCamera.CFrame = CFrame.new(HumRP.Position + Vector3.new(4, 3, 3), HumRP.Position)
			
			local Button = Frame.Button
			Button.MouseButton1Click:Connect(function()
				EquipPet:InvokeServer(PetName)
			end)
		end
	end
end)
