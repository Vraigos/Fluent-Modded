local Animation = {}
local connections = {}

local function clear()
	for _, c in ipairs(connections) do
		if c.disconnect then
			c.disconnect()
		end
	end
	table.clear(connections)
end

function Animation.Apply(theme, root)
	clear()

	if not theme or not root or not theme.ShineEnabled then
		return
	end

	local rotationSpeed = theme.RotationSpeed * 0.1 or 1
	local pulseSpeed = theme.ShineSpeed or 0.05
	local dark = theme.StrokeDark or Color3.fromRGB(15, 15, 15)
	local shine = theme.ShineColor or theme.Accent or Color3.fromRGB(120, 200, 255)

	for _, obj in ipairs(root:GetDescendants()) do
		if obj:IsA("UIGradient") then
			obj.Rotation = 0
			local active = true

			local rotationThread
			rotationThread = task.spawn(function()
				while active and obj.Parent do
					task.wait(0.03)
					if obj then
						t += rotationSpeed / 100
					
					    obj.Offset = Vector2.new((math.sin(t) + 1) / 2, (math.cos(t) + 1) / 2)
					    obj.Rotation = (obj.Rotation + rotationSpeed) % 360
					end
				end
			end)

			table.insert(connections, {
				disconnect = function()
					active = false
				end
			})
		end

		if obj:IsA("UIStroke") and theme.StrokeShine then
			local active = true
			local t = 0

			local pulseThread
			pulseThread = task.spawn(function()
				while active and obj.Parent do
					task.wait(pulseSpeed)
					t += pulseSpeed
					if obj then
						obj.Color = dark:Lerp(shine, (math.sin(t) + 1) / 2)
					end
				end
			end)

			table.insert(connections, {
				disconnect = function()
					active = false
				end
			})
		end
	end
end

return Animation
