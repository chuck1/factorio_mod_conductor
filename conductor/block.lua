
-- a continuous section of rail that we want to make sure only one train
-- occupies at a time
Block = {
	entity = nil,

	stop_blocks = {}

	gates = {}

	-- ste by stops when testing
	locked = false
}

function Block:notify(t_1, t_2)

	-- notify all stops that this block will be occupied from t_1 to t_2
	
	for stop_block_id, stop_block in pairs(self.stop_blocks) do
		stop_block.block_notify(self, t_1, t_2)
	end
end

function Block:check_gates(e)
	for gate_id, gate in pairs(self.gates) do
		if gate.is_opening() then
			for stop_block_id, stop_block in pairs(self.stop_blocks) do
				stop_block.on_gate_opening(e, gate)
			end
		elseif gate.is_closing() then
			for stop_block_id, stop_block in pairs(self.stop_blocks) do
				stop_block.on_gate_closing(e, gate)
			end
		end
	end
end


