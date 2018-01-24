
StopBlock = {
	stop = nil,
	block = nil,
	t_1 = nil,
	t_2 = nil,
	gate_1 = nil,
	gate_2 = nil,
}

function StopBlock:on_gate_opening(e, gate)
	-- check if we're testing
	if !stop.is_testing then return end

	if self.gate_1 == nil then
		self.gate_1 = gate
		self.t_1 = e.tick
	elseif gate_2 == nil then
		self.gate_2 = gate
	end
end

function StopBlock:on_gate_closing(e, gate)
	-- check if we're testing
	if !stop.is_testing then return end

	if self.gate_2 == gate then
		if self.t_2 == nil then
			self.t_2 = e.tick

			if stop.has_data() then
				stop.stop_test()
			end
		end
	end
end

function StopBlock:block_notify(block, t_1, t_2)
	self.stop.block_notify(block, t_1, t_2)
end

function StopBlock:has_data()
	if self.t_1 == nil then return false end
	if self.t_2 == nil then return false end
	return true
end




