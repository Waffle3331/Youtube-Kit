#include "Automatic.lua"

function init()
	BreakBodies = FindBodies("LiquifyOnBreak", true)
	BreakShapes = FindShapes("LiquifyOnBreak", true)
	
	HitShapes = FindShapes("LiquifyOnHit", true)
	
	
	
	Min = GetLightTransform(FindLight("min")).pos
	Max = GetLightTransform(FindLight("max")).pos
	RejectBodies = FindBodies("reject",true)
end

function tick(dt)
	for i=1,#BreakBodies do 
		if IsBodyBroken(BreakBodies[i]) then
			local BodyShapes = GetBodyShapes(BreakBodies[i])
			for j=1,#BodyShapes do 
				AutoLiquifyShape(BodyShapes[j], false)
			
			end
		end
	end
	for i=1,#BreakShapes do
		if IsShapeBroken(BreakShapes[i]) then
			AutoLiquifyShape(BreakShapes[i],false)
		end
	end
	DebugCross(Min)
	for i=1,#RejectBodies do QueryRejectBody(RejectBodies[i]) end
	local AllShapes = QueryAabbShapes(Min, Max)
	DebugPrint(#AllShapes)
	for i=1,#HitShapes do
		for j=1,#AllShapes do
			if not HasTag(AllShapes[j], "reject") then
				if IsShapeTouching(AllShapes[j], HitShapes[i]) then
					AutoLiquifyShape(AllShapes[j],false)
				end
			end
		end
	end
	

end
