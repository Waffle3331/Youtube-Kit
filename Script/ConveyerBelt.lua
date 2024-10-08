function init()
    Conveyers = FindShapes("Conveyer", true)
end

function tick(dt)
    for i = 1, #Conveyers do 
        local bounds = { GetShapeBounds(Conveyers[i]) }
        local min = Vec(bounds[1][1], bounds[1][2], bounds[1][3])
        local max = Vec(bounds[2][1], bounds[2][2]+5, bounds[2][3])
        QueryRejectBody(GetToolBody())
        QueryRejectBody(GetWorldBody())
        local bodies = QueryAabbBodies(min, max)
        
        for j = 1, #bodies do
            local shapes = GetBodyShapes(bodies[j])
            local touching = false
            for k = 1, #shapes do
                if IsShapeTouching(Conveyers[i], shapes[k]) then
                    touching = true
                end
            end
            if --[[touching]] true then
                
				local speed = tonumber(GetTagValue(Conveyers[i], "Speed")) or 0.01
				local body = bodies[j]
                local forcetag = Split(GetTagValue(Conveyers[i], "Direction"), ",")
				
                local forceDirection = GetShapeWorldTransform(Conveyers[i]).rot
				local forceDirection = EulerToVector(math.rad(forceDirection[1]),math.rad(forceDirection[2]),math.rad(forceDirection[3]))
                local bodytrans = GetBodyTransform(body)
				SetBodyTransform(body, Transform(VecAdd(bodytrans.pos, Vec(forceDirection[1] * speed,forceDirection[2] * speed,forceDirection[3] * speed)),bodytrans.rot))
            end
        end
    end
end

function EulerToVector(yaw, pitch, roll)
    local x = math.cos(pitch) * math.cos(yaw)
    local y = math.sin(pitch)
    local z = -math.cos(pitch) * math.sin(yaw)
    return {x, y, z}
end

function Split(s, delimiter)
    local result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end