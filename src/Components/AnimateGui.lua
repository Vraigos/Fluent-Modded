local RunService = game:GetService("RunService")
local Animation = {}
local connections = {}

local function clear()
	for _, c in ipairs(connections) do
		pcall(function() c:Disconnect() end)
	end
	table.clear(connections)
end

function Animation.Apply(theme, root)
	clear()

	if not theme or not root or not theme.ShineEnabled then
		return
	end

	local speed = theme.ShineSpeed or 0.6
	local rotateSpeed = theme.RotationSpeed or 40 
	local dark  = theme.ShineDark or Color3.fromRGB(8,8,8)
	local shine = theme.ShineColor or theme.Accent or Color3.fromRGB(120,200,255)

	for _, obj in ipairs(root:GetDescendants()) do
		if obj:IsA("UIGradient") then
			local t = 0
			local conn
			conn = RunService.RenderStepped:Connect(function(dt)
				t += dt * speed
                obj.Offset = Vector2.new((tick() * 0.15) % 1, 0)
				obj.Rotation = (t * rotateSpeed) % 360
				obj.Color = ColorSequence.new{
					ColorSequenceKeypoint.new(0, dark),
					ColorSequenceKeypoint.new(0.25, shine),
					ColorSequenceKeypoint.new(0.5, dark),
					ColorSequenceKeypoint.new(0.75, shine),
					ColorSequenceKeypoint.new(1, dark)
				}
			end)
			table.insert(connections, conn)
		end

		if obj:IsA("UIStroke") and theme.StrokeShine then
			local from = theme.StrokeDark or theme.AcrylicBorder or dark
			local t = 0
			local conn
			conn = RunService.RenderStepped:Connect(function(dt)
				t += dt * speed
				obj.Color = from:Lerp(shine, (math.sin(t) + 1) / 2)
			end)
			table.insert(connections, conn)
		end
	end
end

return Animation
