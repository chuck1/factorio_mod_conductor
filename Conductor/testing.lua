

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

	if rail == nil then
		game.print{"", "rail not found!"}
	else
		
		game.print{"", "found rail at " .. rail.position.x .. " " .. rail.position.y}

		local rail1 = nil
		
		rail1 = rail.get_connected_rail{rail_direction = defines.rail_direction.front, rail_connection_direction = defines.rail_connection_direction.left}

		game.print{"", "front left"}
		if rail1 <> nil then
			game.print{"", "rail at " .. rail1.position.x .. " " .. rail1.position.y}
		end

		rail1 = rail.get_connected_rail{rail_direction = defines.rail_direction.front, rail_connection_direction = defines.rail_connection_direction.straight}

		game.print{"", "front straight"}
		if rail1 <> nil then
			game.print{"", "rail at " .. rail1.position.x .. " " .. rail1.position.y}
		end
		
		rail1 = rail.get_connected_rail{rail_direction = defines.rail_direction.front, rail_connection_direction = defines.rail_connection_direction.right}

		game.print{"", "front right"}
		if rail1 <> nil then
			game.print{"", "rail at " .. rail1.position.x .. " " .. rail1.position.y}
		end



		rail1 = rail.get_connected_rail{rail_direction = defines.rail_direction.back, rail_connection_direction = defines.rail_connection_direction.left}

		game.print{"", "back left"}
		if rail1 <> nil then
			game.print{"", "rail at " .. rail1.position.x .. " " .. rail1.position.y}
		end
		
		rail1 = rail.get_connected_rail{rail_direction = defines.rail_direction.back, rail_connection_direction = defines.rail_connection_direction.straight}

		game.print{"", "back straight"}
		if rail1 <> nil then
			game.print{"", "rail at " .. rail1.position.x .. " " .. rail1.position.y}
		end

		rail1 = rail.get_connected_rail{rail_direction = defines.rail_direction.back, rail_connection_direction = defines.rail_connection_direction.right}

		game.print{"", "back right"}
		if rail1 <> nil then
			game.print{"", "rail at " .. rail1.position.x .. " " .. rail1.position.y}
		end

	else


end


