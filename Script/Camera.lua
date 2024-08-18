function init()
    LookLight = FindLight("LookAt1", true)
    BackLight = FindLight("Back1", true)
    FOV = tonumber(GetTagValue(BackLight, "FOV")) or 90
    Radius = 0
    Angle = 0
	DOF = tonumber(GetTagValue(BackLight, "DOF")) or 0
    Circle = true
	CurrentCameraToFind = 1
	local Shapes = FindShapes("", true) for i=1,#Shapes do SetTag(Shapes[i], "nocull") end
	Normal = false
end

function tick(dt)
	SetPlayerHidden()
	if InputPressed("o") then Normal = not Normal end
	if not Normal then
		SetTag(BackLight, "DOF", DOF)
		SetTag(BackLight, "FOV", FOV)
	   if not InputDown("tab") then
			if InputPressed("1") then
				CurrentCameraToFind = 1
				LookLight = FindLight("LookAt"..CurrentCameraToFind.."", true)
				BackLight = FindLight("Back"..CurrentCameraToFind.."", true)
			elseif InputPressed("2") then
				CurrentCameraToFind = 2
				LookLight = FindLight("LookAt"..CurrentCameraToFind.."", true)
				BackLight = FindLight("Back"..CurrentCameraToFind.."", true)
			elseif InputPressed("3") then
				CurrentCameraToFind = 3
				LookLight = FindLight("LookAt"..CurrentCameraToFind.."", true)
				BackLight = FindLight("Back"..CurrentCameraToFind.."", true)
			elseif InputPressed("4") then
				CurrentCameraToFind = 4
				LookLight = FindLight("LookAt"..CurrentCameraToFind.."", true)
				BackLight = FindLight("Back"..CurrentCameraToFind.."", true)
			elseif InputPressed("5") then
				CurrentCameraToFind = 5
				LookLight = FindLight("LookAt"..CurrentCameraToFind.."", true)
				BackLight = FindLight("Back"..CurrentCameraToFind.."", true)
			elseif InputPressed("6") then
				CurrentCameraToFind = 6
				LookLight = FindLight("LookAt"..CurrentCameraToFind.."", true)
				BackLight = FindLight("Back"..CurrentCameraToFind.."", true)
			elseif InputPressed("7") then
				CurrentCameraToFind = 7
				LookLight = FindLight("LookAt"..CurrentCameraToFind.."", true)
				BackLight = FindLight("Back"..CurrentCameraToFind.."", true)
			elseif InputPressed("8") then
				CurrentCameraToFind = 8
				LookLight = FindLight("LookAt"..CurrentCameraToFind.."", true)
				BackLight = FindLight("Back"..CurrentCameraToFind.."", true)
			elseif InputPressed("9") then
				CurrentCameraToFind = 9
				LookLight = FindLight("LookAt"..CurrentCameraToFind.."", true)
				BackLight = FindLight("Back"..CurrentCameraToFind.."", true)
	
			end
	   end
	   
	   if InputPressed("1") and InputDown("tab") then
			if FindLight("LookAt"..CurrentCameraToFind + 1 .."", true) ~= 0 and FindLight("Back"..CurrentCameraToFind + 1 .."", true) ~= 0 then
				CurrentCameraToFind = CurrentCameraToFind + 1
			else
				CurrentCameraToFind = 1
			end
			
			DOF = tonumber(GetTagValue(BackLight, "DOF")) or 0
			FOV = tonumber(GetTagValue(BackLight, "FOV")) or 90
			LookLight = FindLight("LookAt"..CurrentCameraToFind.."", true)
			BackLight = FindLight("Back"..CurrentCameraToFind.."", true)
		end
		
		local LookLightPos = GetLightTransform(LookLight).pos
		local BackLightPos = GetLightTransform(BackLight).pos

		if InputPressed("shift") then 
			Circle = not Circle
			Angle = 0
			Radius = VecLength(VecSub(LookLightPos, BackLightPos)) 
		end
		if not HasTag(BackLight, "Stationary") then
			if Circle then
				-- Adjust Angle based on key input for rotation direction
				if InputDown("w") then
					Radius = Radius - 0.1
				elseif InputDown("s") then
					Radius = Radius + 0.1
				end
					
				
				if InputDown("a") then
					Angle = Angle + 0.01  -- Rotate left
				elseif InputDown("d") then
					Angle = Angle - 0.01  -- Rotate right
				end

				-- Calculate new position in circular motion
				local newX = LookLightPos[1] + Radius * math.cos(Angle)
				local newZ = LookLightPos[3] + Radius * math.sin(Angle)
				local newY = BackLightPos[2]  -- Maintain the same height by default

				-- Adjust Y position for vertical movement
				if InputDown("space") then
					newY = newY + 0.05  -- Move up when space is pressed
				elseif InputDown("ctrl") then
					newY = newY - 0.05  -- Move down when ctrl is pressed
				end

				-- Set the new transform with rotation towards the LookLight
				local newPos = Vec(newX, newY, newZ)
				SetProperty(BackLight, "transform", Transform(newPos, QuatLookAt(newPos, LookLightPos)))

				-- Adjust the camera to follow the circular motion
				SetCameraTransform(Transform(newPos, QuatLookAt(newPos, LookLightPos)), FOV)
			else
				-- Normal non-circular behavior
				SetCameraTransform(Transform(BackLightPos, QuatLookAt(BackLightPos, LookLightPos)), FOV)

				-- Movement controls
				if InputDown("space") then
					local RearLightTransform = GetProperty(BackLight, "transform")
					SetProperty(BackLight, "transform", Transform(VecAdd(RearLightTransform.pos, Vec(0, 0.1, 0)), RearLightTransform.rot))
				end
				if InputDown("ctrl") then
					local RearLightTransform = GetProperty(BackLight, "transform")
					SetProperty(BackLight, "transform", Transform(VecAdd(RearLightTransform.pos, Vec(0, -0.1, 0)), RearLightTransform.rot))
				end
				if InputDown("a") then
					local RearLightTransform = GetProperty(BackLight, "transform")
					SetProperty(BackLight, "transform", Transform(VecAdd(RearLightTransform.pos, Vec(0, 0, 0.1)), RearLightTransform.rot))
				end
				if InputDown("d") then
					local RearLightTransform = GetProperty(BackLight, "transform")
					SetProperty(BackLight, "transform", Transform(VecAdd(RearLightTransform.pos, Vec(0, 0, -0.1)), RearLightTransform.rot))
				end
				if InputDown("w") then
					local RearLightTransform = GetProperty(BackLight, "transform")
					SetProperty(BackLight, "transform", Transform(VecAdd(RearLightTransform.pos, Vec(0.1, 0, 0)), RearLightTransform.rot))
				end
				if InputDown("s") then
					local RearLightTransform = GetProperty(BackLight, "transform")
					SetProperty(BackLight, "transform", Transform(VecAdd(RearLightTransform.pos, Vec(-0.1, 0, 0)), RearLightTransform.rot))
				end
			end
		end
		SetCameraTransform(Transform(BackLightPos, QuatLookAt(BackLightPos, LookLightPos)), FOV)
		--SetCameraDof(DOF)
		-- Adjust FOV
		if InputDown("q") then
			FOV = FOV - 1
		elseif InputDown("e") then
			FOV = FOV + 1     
		end
		if InputDown("z") then
			DOF = DOF + 1
		elseif InputDown("x") then
			DOF = math.max(DOF - 1, 0)
		end
		
		
		end
end

