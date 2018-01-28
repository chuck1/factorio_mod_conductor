
require "lib"

conductor = {
	-- referenced by train stop unit number
	stops = {},

	stops_testing = {},
	stops_waiting_to_schedule = List:new()
}

function on_train_arrive(e)

	local stop = conductor.stops[e.train.station.unit_number]
	
	print("on train arrive", e.train.station.unit_number, stop.entity.unit_number)
	
	if stop == nil then 
		print("stops")
		for i, stop in pairs(conductor.stops) do
			print(i, stop)
		end
		print()
		error("stop is nil") 
	end
	
	conductor.stops_waiting_to_schedule:push_right(stop)
end

function on_train_leave(e)

	-- train has just left a conductor train stop
	-- reset the stop

	local stop = conductor.stops[e.train.station.unit_number]

	stop.stop()
end

function on_train_changed_state(e)
	
	if e.train.state == defines.train_state.wait_station then
		
		if e.train.station.name ~= "conductor-train-stop" then return end

		e.train.last_station = e.train.station

		on_train_arrive(e)
		
	elseif e.train.state == defines.train_state.on_the_path then

		if e.train.last_station == nil then return end

		if e.train.last_station.name ~= "conductor-train-stop" then return end
		
		if e.old_state == defines.train_state.wait_station then
			on_train_leave(e)
		end
		
	end
end

function on_tick_testing(e)
	for stop_id, stop in pairs(conductor.stops_testing) do
		stop:check_gates(e)
	end
end

function on_tick_schedule(e)

	local l = conductor.stops_waiting_to_schedule

	for i=l.first,l.last do
		stop = l[i]

		if stop:ready() then
			stop:schedule(e)
			l:pop_left()
			-- continue
		else
			if stop:ready_to_test() then
				-- after the test start, other stops can try to schedule trains or start test
				stop:start_test()
				l:pop_left()
				-- continue
			else
				-- dont try to schedule any more stops
				-- next tick this stop will try to schedule again
				break
			end
		end
	end
end

function on_tick(e)
	
	on_tick_testing(e)

	on_tick_schedule(e)
	
	for stop_id, stop in pairs(conductor.stops) do
		if stop.t ~= nil then
			if stop.t == e.tick then
				stop.launch()
				stop.t = nil
			end
		end
	end
end

function is_conductor_entity(entity)
	--print("is conductor entity", entity.name)
	--if entity.name == "conductor-train-stop" then return true end
	if entity.name == "conductor-stop-combinator" then return true end
	if entity.name == "conductor-stop-block-combinator" then return true end
	if entity.name == "conductor-block-combinator" then return true end
	return false
end

function get_conductor_object(e, entity, ref)

	--print("get conductor object", entity.unit_number, entity.name)

	if entity.name == nil then error("entity.name is nil") end

	if entity.conductor_object ~= nil then 
		if entity.name == "conductor-stop-block-combinator" then
			
			--print("ref", ref.entity.unit_number)
			--print(entity.name, "has table of conductor objects")
			--for i, o in pairs(entity.conductor_object) do
			--	print(i, o)
			--end
			--print()

			if entity.conductor_object[ref.entity.unit_number] == nil then

				--print("ref not in table")

				local stop_block = StopBlock:new()
				stop_block.entity = entity

				entity.conductor_object[ref.entity.unit_number] = stop_block
				
				--stop_block:reset_connections(e)
				
				if stop_block == nil then error("stop_block is nil") end

				return stop_block
			else
				--print("ref is in table")
				return entity.conductor_object[ref.entity.unit_number]
			end
		else
			return entity.conductor_object 
		end
	end

	-- entity does not yet have conductor object
	if entity.name == "conductor-stop-combinator" then
		--print("create new Stop", entity.unit_number)

		local stop = Stop:new()
		stop.entity = entity

		entity.conductor_object = stop

		stop:reset_connections(e)

		conductor.stops[stop.train_stop_entity.unit_number] = stop

		return stop
	end

	if entity.name == "conductor-stop-block-combinator" then
		--print("create new StopBlock", entity.unit_number)

		local stop_block = StopBlock:new()
		stop_block.entity = entity
	
		--print("ref", ref.entity.unit_number)
	
		entity.conductor_object = {}
		entity.conductor_object[ref.entity.unit_number] = stop_block

		--stop_block:reset_connections(e)

		return stop_block
	end

	if entity.name == "conductor-block-combinator" then
		--print("create new Block", entity.unit_number)

		block = Block:new()
		block.entity = entity

		entity.conductor_object = block

		block:reset_connections(e)

		--conductor.stops[stop.train_stop_entity.unit_number] = stop

		return block
	end

	--error("need conductor object for ", entity, entity.unit_number, entity.name)
	error("need conductor object")
end

function on_built_entity(e)

	print("on built entity", e.created_entity.name)
	game.print("on built entity", e.created_entity.name)

	if e.created_entity.name == "green-wire" or e.created_entity.name == "red-wire" then
	
		for i, entity in pairs(e.created_entity.circuit_connected_entities.red) do
			if is_conductor_entity(entity) then
				local o = get_conductor_object(e, entity, nil)
				o:reset_connections(e)
			end
		end

		for i, entity in pairs(e.created_entity.circuit_connected_entities.green) do
			--print(entity.name)
			if is_conductor_entity(entity) then
				--print(entity.name)
				local o = get_conductor_object(e, entity, nil)
				o:reset_connections(e)
			end
		end

	end
end

function print_connections()
	print()
	print("connections:")

	for stop_id, stop in pairs(conductor.stops) do
		print("stop", stop.entity.unit_number, stop)
		
		for stop_block_id, stop_block in pairs(stop.stop_blocks) do
			print("\tstop_block", stop_block_id, stop_block, "stop:", stop_block.stop.entity.unit_number)
			print("\t\tt_1", stop_block.t_1)
			print("\t\tt_2", stop_block.t_2)
			
			local block = stop_block.block
			
			print("\t\tblock", block.entity.unit_number)

			print("\t\t\tgates")
			for gate_id, gate in pairs(block.gates) do
				print("\t\t\t\tgate", gate_id)
			end

			print("\t\t\tstop blocks")
			for stop_block_id_1, stop_block_1 in pairs(block.stop_blocks) do
				print("\t\t\t\tstop block", stop_block_id_1)
			end
			
			
		end
	end

	print()
end

function print_state()
	print()
	print("state:")

	local l = conductor.stops_waiting_to_schedule

	for i=l.first,l.last do
		print(i, l[i].entity.name, l[i].entity.unit_number)
	end

	print()
end

script.on_event({defines.events.on_built_entity}, on_built_entity)
--script.on_event({defines.events.on_robot_built_entity}, on_built_entity)

script.on_event({defines.events.on_tick}, on_tick)
script.on_event({defines.events.on_train_changed_state}, on_train_changed_state)











