
conductor = {
	stops_testing = {}
	stops_waiting_to_schedule = List.new()
}

function on_train_arrive(e)
	stop = stops[e.train.station.unit_number]

	stops_waiting_to_schedule.push_right(stop)
end

function on_train_leave(e)
	-- train has just left a conductor train stop
	-- reset the stop

	stop = stops[e.train.station.unit_number]

	stop.stop()
end

function on_train_changed_state(e)
	if e.train.station.name != "conductor-train-stop" then return end

	if e.train.state == defines.train_state.wait_station then
		on_train_arrive(e)
	elseif e.train.state == defines.train_state.on_the_path then
		if e.old_state == defines.train_state.wait_station then
			on_train_leave(e)
		end
	end
end

function on_tick_testing(e)
	for stop_id, stop in pairs(conductor.stops_testing) do
		stop.check_gates(e)
	end
end

function on_tick_schedule(e)

	l = stops_waiting_to_schedule

	for i=l.first,l.last do
		stop = l[i]

		if stop.ready() then
			stop.schedule(e)
			l[i] = nil
			-- continue
		else
			if stop.ready_to_test() then
				-- after the test start, other stops can try to schedule trains or start test
				stop.start_test()
				l[i] = nil
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
	
	for stop_id, stop in pairs(stops) do
		if stop.t != nil then
			if stop.t == e.tick then
				stop.launch()
				stop.t = nil
			end
		end
	end
end

function is_conductor_entity(entity)
	if entity.name == "conductor-train-stop" then return true end
	if entity.name == "conductor-stop-combinator" then return true end
	if entity.name == "conductor-stop-block-combinator" then return true end
	if entity.name == "conductor-block-combinator" then return true end
	return false
end

function get_conductor_object(entity)
	if entity.conductor_object != nil then return entity.conductor_object end
	
	-- entity does not yet have conductor object
	if entity.name == "conductor-stop-combinator" then
		stop = Stop
		stop.entity = entity
		stop.reset_connections()
	end
	
end

function on_built_entity(e)
	if e.created_entity.name == "green-wire" or e.created_entity.name == "red-wire" then

		for i, entity in pairs(e.created_entity.circuit_connected_entities.red) do
			if is_conductor_entity(entity) then
				o = get_conductor_object(entity)
				o.reset_connections()
			end
		end

		for i, entity in pairs(e.created_entity.circuit_connected_entities.green) do
			if is_conductor_entity(entity) then
				o = get_conductor_object(entity)
				o.reset_connections()
			end
		end

	end
end

script.on_event({defines.events.on_built_entity}, on_built_entity)
script.on_event({defines.events.on_robot_built_entity}, on_built_entity)

script.on_event({defines.events.on_tick}, on_tick)
script.on_event({defines.events.on_train_changed_state}, on_train_changed_state)




