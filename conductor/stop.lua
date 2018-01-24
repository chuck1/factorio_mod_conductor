
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





