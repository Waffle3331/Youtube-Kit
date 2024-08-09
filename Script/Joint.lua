function init()
	Joints = FindJoints("Motor", true) 


end

function tick(dt)
	for i=1,#Joints do
		local speed = tonumber(GetTagValue(Joints[i], "Speed")) or 1
		SetJointMotor(Joints[i], speed)
	end
end