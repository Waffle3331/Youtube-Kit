function init()
    Conveyers = FindShapes("Conveyer", true)
end

function tick(dt)
    for i=1, #Conveyers do 
        local bounds = { GetShapeBounds(Conveyers[i]) }
        local min = Vec(bounds[1][1], bounds[1][2], bounds[1][3])
        local max = Vec(bounds[2][1], bounds[2][2], bounds[2][3])
        QueryRejectBody(GetToolBody())
		QueryRejectBody(GetWorldBody())
		local bodies = QueryAabbBodies(min, max)
        
        for j=1, #bodies do
            local shapes = GetBodyShapes(bodies[j])
			local touching = false
			for k=1,#shapes do
				if IsShapeTouching(Conveyers[i], shapes[k]) then
					touching = true
				end
			end
			if touching then
				local body = bodies[j]
				local forcetag = Split(GetTagValue(Conveyers[i], "Direction"), ",")
				local forceDirection = Vec(forcetag[1],forcetag[2],forcetag[3]) or Vec(1,0,0)
				local forceMagnitude = 1
				local force = VecScale(forceDirection, forceMagnitude)
				
			   SetBodyVelocity(body, force)
			 end
        end
    end
end

function Split(s, delimiter)
    local result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end