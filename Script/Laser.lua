function init()
	Lasers = FindShapes("Laser", true)


end

function tick(dt)
	for i=1,#Lasers do 
		local entry = GetShapePalette(Lasers[i])
		type, red, green, blue, alpha, reflectivity, shininess, metallic, emissive = GetShapeMaterial(Lasers[i], entry[1])
		local lights = GetShapeLights(Lasers[i])
		DrawLine(GetLightTransform(lights[1]).pos,GetLightTransform(lights[2]).pos,red,green,blue,0.8)
		PointLight(GetLightTransform(lights[1]).pos, red, green, blue, 1)
		PointLight(GetLightTransform(lights[2]).pos, red, green, blue, 1)
		TriggerDelete(Lasers[i], {red,green,blue})
	end
end

function TriggerDelete(RefShape, color)
	--local MI,MA = GetTriggerBounds(trigger)
	local size = { GetShapeSize(RefShape) }
	local MI,MA = TransformToParentPoint(GetShapeWorldTransform(RefShape), VecScale(Vec(0+0.5, 0+0.5, 0+0.5), 0.1)),TransformToParentPoint(GetShapeWorldTransform(RefShape), VecScale(Vec(size[1]+0.5, size[2]+0.5, size[3]+0.5), 0.1))
	--local RefShape = nil
	local ShapeList = QueryAabbShapes(MI,MA)
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
					QueryRejectShape(RefShape)
					local amount = QueryAabbShapes(transform,transform)
					if #amount ~= 0 then
						local count = MakeHole(transform, 0.1,0.1,0.1)
						if count ~= 0 then
							PointLight(transform, color[1], color[2], color[3], 1)
						end
					end
				end
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

