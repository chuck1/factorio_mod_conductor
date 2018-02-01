function direction_to_number(direction)
end

function rail_direction_to_number(direction)
end

function position_in_direction(entity, direction)
	if direction == defines.direction.east then
		return entity.position.x
	else if direction == defines.direction.west then
		return -entity.position.x
	else if direction == defines.direction.north then
		return -entity.position.y
	else if direction == defines.direction.south then
		return entity.position.y
	end
end

function number_to_rail_direction(x)
	if x > 0 then
		return defines.rail_dircetion.front
	else if x < 0 then
		return defines.rail_direction.back
	end
end

function train_stop_rail_direction(train_stop, rail1, rail_direction)
	x0 = position_in_direction(train_stop, train_stop.direction)
	x1 = position_in_direction(rail1, train_stop.direction)

	local X = x1 - x0;

	-- X is positive if rail1 is in front of the train stop
	--

	return number_to_rail_direction(X * rail_direction_to_number(rail_direction))
end

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
			--return {rail = rail, direction = train_stop_rail_direction(train_stop, rail1, defines.rail_direction.front)}
		end

		rail1 = rail.get_connected_rail{rail_direction = defines.rail_direction.front, rail_connection_direction = defines.rail_connection_direction.straight}

		game.print{"", "front straight"}
		if rail1 <> nil then
			game.print{"", "rail at " .. rail1.position.x .. " " .. rail1.position.y}
			--return {rail = rail, direction = train_stop_rail_direction(train_stop, rail1, defines.rail_direction.front)}
		end

		rail1 = rail.get_connected_rail{rail_direction = defines.rail_direction.front, rail_connection_direction = defines.rail_connection_direction.right}

		game.print{"", "front right"}
		if rail1 <> nil then
			game.print{"", "rail at " .. rail1.position.x .. " " .. rail1.position.y}
			--return {rail = rail, direction = train_stop_rail_direction(train_stop, rail1, defines.rail_direction.front)}
		end



		rail1 = rail.get_connected_rail{rail_direction = defines.rail_direction.back, rail_connection_direction = defines.rail_connection_direction.left}

		game.print{"", "back left"}
		if rail1 <> nil then
			game.print{"", "rail at " .. rail1.position.x .. " " .. rail1.position.y}
			--return {rail = rail, direction = train_stop_rail_direction(train_stop, rail1, defines.rail_direction.back)}
		end

		rail1 = rail.get_connected_rail{rail_direction = defines.rail_direction.back, rail_connection_direction = defines.rail_connection_direction.straight}

		game.print{"", "back straight"}
		if rail1 <> nil then
			game.print{"", "rail at " .. rail1.position.x .. " " .. rail1.position.y}
			--return {rail = rail, direction = train_stop_rail_direction(train_stop, rail1, defines.rail_direction.back)}
		end

		rail1 = rail.get_connected_rail{rail_direction = defines.rail_direction.back, rail_connection_direction = defines.rail_connection_direction.right}

		game.print{"", "back right"}
		if rail1 <> nil then
			game.print{"", "rail at " .. rail1.position.x .. " " .. rail1.position.y}
			--return {rail = rail, direction = train_stop_rail_direction(train_stop, rail1, defines.rail_direction.back)}
		end

	else


	end


