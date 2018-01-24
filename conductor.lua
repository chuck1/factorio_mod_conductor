
-- data to initialize
-- Line.crossings
-- Station.stops
-- Block.lines
--

-- A combinator will be copied to create an entity for
--   line
--   station
--   stop
--
-- These will be used to define associations and uniquely identify.
-- I will need to figure out how to have in and out circuit network connections on an entity
--


Window = {
	new = function(self, t_1, t_2)
		self.t_1 = t_1
		self.t_2 = t_2
	end
}

Line = {
	-- list of crossings
	crossings = {},

	-- station on one end of the line
	station_A = nil,
	-- station on the other end of the line
	station_B = nil
}

Station = {
	entity = nil,

	-- table of conductor train stops
	stops = {},

	-- block where tracks from this station merge
	merge_block = nil,

	-- block that includes the main line and the merge blocks at stations A and B
	-- used only when both stations A and B are begin used
	line_block = nil
}

function Station:schedule(train)
	-- find the stop that this train is at and call the Stop.schedule function
end

function Station:block_notify(block, t_1, t_2)
	for stop_id, stop in pairs(self.stops) do
		stop.block_notify(block, t_1, t_2)
	end
end

-- a section of rail where tracks merge or cross
Block = {
	entity = nil,

	stations = {}
}

function Block:notify(station, t_1, t_2)
	-- notify all stops in all stations except 'station' that this block
	-- will be occupied from t_1 to t_2
	for line_id, line in pairs(self.lines) do
		if line.station_A then
			if line.station_A.entity.unit_number != station.entity.unit_number then
				line.station_A.block_notify(self, t_1, t_2)
			end
		end
		if line.station_B then
			if line.station_B.entity.unit_number != station.entity.unit_number then
				line.station_B.block_notify(self, t_1, t_2)
			end
		end
	end
end

Stop = {
	train_stop = nil,
	combinator = nil,

	-- Station to which this stop belongs
	station = nil,

	-- table of blocks and how long it will take this train to enter and exit
	blocks = {},

	-- list of time windows during which this stop should not release a train
	windows = {},

	-- time at which the train currently at this stop should be released
	t = nil,
}

function Stop:block_notify(block, t_1, t_2)
	w = self.blocks[block.entity.unit_number]
	
	-- release such that my train will exit the block at t_1
	T_1 = t_1 - w.t_2
	
	-- release such that my train will enter the block at t_2
	T_2 = t_2 - w.t_1
	
	table.insert(self.windows, Window.new(T_1, T_2))

end

function Stop:schedule(e, train)

	table.sort(self.windows, function(a, b) return a.t_1 < b.t_1 end)

	-- self.windows is sorted by t_1

	t = e.tick

	for i, w in pairs(self.windows) do
		if e.tick >= w.t_2 then
			-- window has passed so delete the window
			self.windows[i] = nil
		else
			if t >= w.t_2 then
				-- t does not violate w
				-- since t only increases, t will never violate w
			elseif t > w.t_1 and t < w.t_2 then
				-- t violates w
				-- set t to the end of w and continue
				t = w.t_2
			elseif t <= w.t_1 then
				-- t does not violate w
				-- since self.windows is sorted with t_1 ascending, t must also be less than 
				-- t_1 for all subsequent windows
				break
			end
		end
	end
	
	-- notify the relevant blocks
	for block_id, w in pairs(self.blocks) do
		block = blocks[block_id]
		block.notify(self.station, t + w.t_1, t + w.t_2)
	end
	
	-- The above will exclude this station.
	-- To prevent collisions between trains leaving the same station, we will use the merge block.
	-- Only stops belonging to a given station will reference the station's merge block (stops
	-- on the opposing station will reference the line_block)
	w = self.blocks[self.station.merge_block]
	self.station.merge_block.notify(nil, t + w.t_1, t + w.t_2)
end

function Stop:launch()
	x = {signal = {type = "virtual", name = "A"}, count = 1}
	self.combinator.get_control_behavior().set_signal(1, x)
end

function Stop:stop()
	x = {signal = {type = "virtual", name = "A"}, count = 0}
	self.combinator.get_control_behavior().set_signal(1, x)
end





