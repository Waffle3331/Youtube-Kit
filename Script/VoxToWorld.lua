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
MaxBlocks = 1
StaticBlocks = false
MakeDynamic = false
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
					table.insert(Table, '<vox pos="'.. 1.6*x ..' '.. 1.6*y ..' '.. 1.6*z ..'" prop="false" file="MOD/Vox/Minecraft/'..block..'.vox" object="block"/>')
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
	Spawn('<compound pos="0.0 0.0 0.0">'..table.concat(Table,"")..'</compound>', Transform(), true)
end

