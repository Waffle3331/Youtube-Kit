function init()
	Lasers = FindLights("Laser", true)


end

function tick(dt)
	for i=1,#Lasers do 
		for j=1,1 do 
			local trans = TransformToParentVec(GetLightTransform(Lasers[i]), Vec(0,0,-1))
			hit, dist, normal, shape = QueryRaycast(GetLightTransform(Lasers[i]).pos, trans, 120)
			if hit then
				local hitpos = VecAdd(GetLightTransform(Lasers[i]).pos, VecScale(trans, dist))
				MakeHole(hitpos, 0.1, 0.1, 0.1, true)
				DebugCross(hitpos)
				DrawLine(GetLightTransform(Lasers[i]).pos,hitpos,1,0,0,1)
				
				
				local trans = TransformToParentVec(hitpos, Vec(0,0,-1))
				hit2, dist2, normal2, shape2 = QueryRaycast(hitpos, trans, 120)
				if hit2 then
					local hitpos2 = VecAdd(hitpos, VecScale(trans, dist2))
					MakeHole(hitpos, 0.1, 0.1, 0.1, true)
					DebugCross(hitpos2)
					DrawLine(hitpos,hitpos2,1,0,0,1)
				else 
					DebugLine(hitpos, VecAdd(hitpos, VecScale(trans, 5)), 0, 1, 0, 1) 
				end
			else 
				DebugLine(GetLightTransform(Lasers[i]).pos, VecAdd(GetLightTransform(Lasers[i]).pos, VecScale(trans, 120)), 0, 1, 0, 1) 
			end
		end
	end
end

function TriggerDelete(RefShape)
	local Positions = {}
	--local MI,MA = GetTriggerBounds(trigger)
	local size = { GetShapeSize(RefShape) }
	local MI,MA = TransformToParentPoint(GetShapeWorldTransform(RefShape), VecScale(Vec(0+0.5, 0+0.5, 0+0.5), 0.1)),TransformToParentPoint(GetShapeWorldTransform(RefShape), VecScale(Vec(size[1]+0.5, size[2]+0.5, size[3]+0.5), 0.1))
	--local RefShape = nil
	local ShapeList = QueryAabbShapes(MI,MA)
	DebugPrint(#ShapeList)
	--for i=1,#ShapeList do
		--if HasTag(ShapeList[i], "MakeHole") then
		--	RefShape = ShapeList[i]
		--end
	--end
	for x=0, size[1] - 1 do
		for y=0, size[2] - 1 do
			for z=0, size[3] - 1 do
				local material = { GetShapeMaterialAtIndex(shape, x, y, z) }
				if material[1] ~= "air" then
					local transform = TransformToParentPoint(GetShapeWorldTransform(RefShape), VecScale(Vec(x+0.5, y+0.5, z+0.5), 0.1))
					table.insert(Positions,transform)
					--DebugCross(transform)
				end
			end
		end
	end
	DebugPrint(#Positions)
	DebugPrint(Positions[1])
	for i=1,#ShapeList do 
		for j=1,#Positions do 
			local pos = GetShapeCoord(ShapeList[i],Positions[j])
			if GetShapeMaterialAtPosition(ShapeList[i], pos) ~= "air" then
				SetBrush("cube", 1, 0)
				DrawShapeLine(ShapeList[i], pos[1], pos[2], pos[3], pos[1], pos[2], pos[3], true, false)
			end
		end
	end
end

function GetShapeCoord(shape, worldPos)
	local lp = TransformToLocalPoint(GetShapeWorldTransform(shape), worldPos)
	lp[1] = math.floor(lp[1]/.1)
	lp[2] = math.floor(lp[2]/.1)
	lp[3] = math.floor(lp[3]/.1)
	return lp
end

