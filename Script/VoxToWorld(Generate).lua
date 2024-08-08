ColorBlockColors = {
	["R29 G138 B15"] = "grass",
	["R97 G77 B45"] = "dirt",
	["R99 G99 B99"] = "stone",	
	["R56 G56 B56"] = "cobblestone",	
	["R22 G22 B22"] = "bedrock",
	["R255 G255 B255"] = "glass",
	["R101 G156 B84"] = "copperore",
	["R190 G140 B75"] = "oakplanks",
	["R127 G92 B50"] = "oaklog",
	["R6 G151 B30"] = "oakleaves",

	
}
MaxBlocks = GetIntParam("MaxBlocksPerTick",10)
StaticBlocks = GetBoolParam("StaticBlocks",true)
MakeDynamic = GetBoolParam("MakeDynamic",false)
function init()
	Shape = FindShape("")
	
	local Size = { GetShapeSize(Shape) }
	Table = {}
	for x=0,Size[1]-1 do 
		for y=0,Size[2]-1 do 
			for z=0, Size[3]-1 do
				type, r, g, b, a, entry = GetShapeMaterialAtIndex(Shape, x, y, z)
				if ColorBlockColors["R"..math.floor(r * 255) .." G"..math.floor(g * 255) .." B"..math.floor(b * 255)] then
					local block = ColorBlockColors["R"..math.floor(r * 255) .." G"..math.floor(g * 255) .." B"..math.floor(b * 255)]
					table.insert(Table, {["Prefab"] = '<vox pos="0.0 0.0 0.0" file="MOD/Vox/Minecraft/'..block..'.vox" object="block"/>',["Transform"] = Transform(Vec(1.6*x,1.6*y,1.6*z)),})
				end
			end
		end
	end
	Delete(Shape)
	if MakeDynamic then
		Body = Spawn('<body dynamic="true"></body>',Transform())[1]
		SetBodyDynamic(Body, false)
	end
	Done = false
end

function tick(dt)
	if Done then
		return 
	end
	if #Table == 0 then
		if MakeDynamic then
			SetBodyDynamic(Body, true)
		end
		Done = True
	end
	for i=MaxBlocks, 1, -1 do
		if Table[i] then
			local entities = Spawn(Table[i].Prefab, Table[i].Transform, StaticBlocks)
			if MakeDynamic then
				for j=1,#entities do
					if GetEntityType(entities[j]) == "shape" then
						SetShapeBody(entities[j], Body, TransformToLocalTransform(GetBodyTransform(Body),GetShapeWorldTransform(entities[j])))
					end
				end
			end
			table.remove(Table, i)
		end
	end
	if InputPressed("y") then
		ShuffleTable(Table)
	end
end

function ShuffleTable(t)
    local n = #t
    for i = n, 2, -1 do
        local j = math.random(i)
        t[i], t[j] = t[j], t[i]
    end
end