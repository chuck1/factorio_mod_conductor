

function train_stop_find_rail(train_stop)
	
	local p = train_stop.position
	
	local area = nil
	
	if train_stop.direction == defines.direction.east then
		area = {{p.x - 1, p.y - 2}, {p.x + 1, p.y - 1}}
	else if train_stop.direction == defines.direction.west then
		area = {{p.x - 1, p.y + 1}, {p.x + 1, p.y + 2}}
	end
	
	local entities = train_stop.surface.find_entities_filtered{area = area}

	for i, e in pairs(entities) do
		game.print{"", e.name .. " " .. e.position}
	end

end


