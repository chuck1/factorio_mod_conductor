

function train_stop_find_rail(train_stop)
	
	local p = train_stop.position
	
	local p_search = nil
	
	if train_stop.direction == defines.direction.east then
		p_search = {x = p.x, y = p.y - 2}
	else if train_stop.direction == defines.direction.west then
		p_search = {x = p.x, y = p.y + 2}
	else if train_stop.direction == defines.direction.north then
		p_search = {x = p.x - 2, y = p.y}
	else if train_stop.direction == defines.direction.south then
		p_search = {x = p.x + 2, y = p.y}
	end
	
	local rail = train_stop.surface.find_entity{entity = "straight-rail", position = p_search}

	for i, e in pairs(entities) do
		game.print{"", e.name .. " " .. e.position}
	end

end


