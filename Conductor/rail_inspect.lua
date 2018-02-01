
-- start at a conductor train stop
-- proceed forward relative to the starting train stop
-- when you reach another train stop (conductor or stock) stop and return the path

function rail_find_train_stop(rail, direction)
	if rail.name <> "straight-rail" then return nil end

	local train_stop
	
	local x = rail.position.x
	local y = rail.position.y

	if rail.direction == defines.direction.north then
		if direction == defines.rail_direction.front then
			train_stop = rail.surface.find_entity{name = "train-stop", position = {x = x, y = y}}
		else if direction == defines.rail_direction.back then
			train_stop = rail.surface.find_entity{name = "train-stop", position = {x = x, y = y}}
		end
	else if rail.direction == defines.direction.south then
		if direction == defines.rail_direction.front then
			train_stop = rail.surface.find_entity{name = "train-stop", position = {x = x, y = y}}
		else if direction == defines.rail_direction.back then
			train_stop = rail.surface.find_entity{name = "train-stop", position = {x = x, y = y}}
		end
	else if rail.direction == defines.direction.east then
		if direction == defines.rail_direction.front then
			train_stop = rail.surface.find_entity{name = "train-stop", position = {x = x, y = y}}
		else if direction == defines.rail_direction.back then
			train_stop = rail.surface.find_entity{name = "train-stop", position = {x = x, y = y}}
		end
	else if rail.direction == defines.direction.west then
		if direction == defines.rail_direction.front then
			train_stop = rail.surface.find_entity{name = "train-stop", position = {x = x, y = y}}
		else if direction == defines.rail_direction.back then
			train_stop = rail.surface.find_entity{name = "train-stop", position = {x = x, y = y}}
		end
	else 
	
	return train_stop
end

function search(paths, path, rail, direction)
	
	-- continue along rail
	
	local copy
	local rail1
	
	-- left

	rail1 = rail.get_connected_rail{direction=direction, connection_direction=defines.rail_connection_direction.left}

	if rail1 <> nil then
		copy = table.copy(path)
		search1(paths, copy, rail1, direction)
	end

	-- straight

	rail1 = rail.get_connected_rail{direction=direction, connection_direction=defines.rail_connection_direction.straight}

	if rail1 <> nil then
		copy = table.copy(path)
		search1(paths, copy, rail1, direction)
	end

	-- right

	rail1 = rail.get_connected_rail{direction=direction, connection_direction=defines.rail_connection_direction.right}

	if rail1 <> nil then
		copy = table.copy(path)
		search1(paths, copy, rail1, direction)
	end
end

function search1(paths, path, rail, direction)

	if rail == nil then return end
	
	table.insert(path, rail)
	
	-- look for train stop
	
	local train_stop = rail_find_train_stop(rail, direction)

	if train_stop <> nil then
		paths.insert(path)
		return
	end

	-- continue along rail

	search(paths, path, rail, direction)
end

function train_stop_get_rail(train_stop)
	return {rail = , direction = }
end

function train_stop_find_paths(train_stop)
	
	local res = train_stop_get_rail(train_stop)

	local rail = res.rail
	local direction = res.direction

	local paths = {}

	search(paths, {rail}, rail, direction)

	game.print{"", "found " .. table.getn(paths) .. " paths from train stop"}

end







