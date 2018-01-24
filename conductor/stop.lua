
Stop = {
	-- combinator entity
	entity = nil,

	-- train stop entity
	train_stop = nil,

	-- table of blocks and how long it will take this train to enter and exit
	stop_blocks = {},

	-- list of time windows during which this stop should not release a train
	windows = {},

	-- time at which the train currently at this stop should be released
	t = nil,

	is_testing = false
}

function Stop:block_notify(block, t_1, t_2)
	sb = self.stop_blocks[block.entity.unit_number]

	-- release such that my train will exit the block at t_1
	T_1 = t_1 - sb.t_2

	-- release such that my train will enter the block at t_2
	T_2 = t_2 - sb.t_1

	table.insert(self.windows, Window.new(T_1, T_2))

end

function Stop:blocks_unlocked()
	for stop_block_id, stop_block in pairs(self.stop_blocks) do
		if stop_block.block.locked then return false end
	end
	return true
end

function Stop:windows_empty(e)
	for i, w in pairs(self.windows) do
		if e.tick >= w.t_2 then
			-- window has passed so delete the window
			self.windows[i] = nil
			-- continue
		else
			return false
		end
	end
	return true
end

function Stop:ready_to_test()
	return self.windows_empty() and self.blocks_unlocked()
end

function Stop:lock_blocks()
	for stop_block_id, stop_block in pairs(self.stop_blocks) do
		stop_block.block.locked = true
	end
end

function Stop:unlock_blocks()
	for stop_block_id, stop_block in pairs(self.stop_blocks) do
		stop_block.block.locked = false
	end
end

function Stop:start_test()

	self.is_testing = true

	self.lock_blocks()

	self.launch()
end

function Stop:stop_test()

	self.is_testing = false

	self.unlock_blocks()
end

function Stop:schedule(e)

	table.sort(self.windows, function(a, b) return a.t_1 < b.t_1 end)

	-- self.windows is sorted by t_1

	t = e.tick + 1

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
	for block_id, w in pairs(self.stop_blocks) do
		block = stop_blocks[block_id].block
		block.notify(t + w.t_1, t + w.t_2)
	end
end

function Stop:launch()
	x = {signal = {type = "virtual", name = "A"}, count = 1}
	self.combinator.get_control_behavior().set_signal(1, x)
end

function Stop:stop()
	x = {signal = {type = "virtual", name = "A"}, count = 0}
	self.combinator.get_control_behavior().set_signal(1, x)
end

function Stop:check_gates(e)
	for stop_block_id, stop_block in pairs(self.stop_blocks) do
		stop_block.block.check_gates(e)
	end
end

function Stop:has_data()
	for stop_block_id, stop_block in pairs(self.stop_blocks) do
		if !stop_block.has_data() then
			return false
		end
	end

	return true
end

function Stop:ready()
	return self()has_data and self.blocks_unlocked()
end





