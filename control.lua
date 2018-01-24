


function on_train_changed_state(e)
	if e.train.state == defines.train_state.wait_station then
		if e.train.station.name != "conductor-train-stop" then
			
			stop = stops[e.train.station.unit_number]

			stop.schedule(e, train)

		end
	elseif e.train.state == defines.train_state.on_the_path then
		if e.old_state == defines.train_state.wait_station then
			if e.train.station.name != "conductor-train-stop" then
				-- train has just left a conductor train stop
				-- reset the stop
				
				stop = stops[e.train.station.unit_number]
				
				stop.stop()

			end
		end
	end
end

function on_tick(e)
	for stop_id, stop in pairs(stops) do
		if stop.t != nil then
			if stop.t == e.tick then
				stop.launch()
				stop.t = nil
			end
		end
	end
end

function on_built_entity(e)
	-- e.created_entity
end

script.on_event({defines.events.on_built_entity}, on_built_entity)
script.on_event({defines.events.on_robot_built_entity}, on_built_entity)

script.on_event({defines.events.on_tick}, on_tick)
script.on_event({defines.events.on_train_changed_state}, on_train_changed_state)




