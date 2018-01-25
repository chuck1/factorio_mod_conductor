
-- a continuous section of rail that we want to make sure only one train
-- occupies at a time
Block = {
	entity = nil,

	-- references by stop id
	stop_blocks = {},

	gates = {},

	-- set by stops when testing
	locked = false,

	last_reset = nil
}

function Block:new()
	o = {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function Block:notify(t_1, t_2)

	-- notify all stops that this block will be occupied from t_1 to t_2
	
	for stop_block_id, stop_block in pairs(self.stop_blocks) do
		stop_block.block_notify(self, t_1, t_2)
	end
end

function Block:check_gates(e)
	--print("Block:check_gates")

	for gate_id, gate in pairs(self.gates) do
		if gate:is_opening() then
			for stop_block_id, stop_block in pairs(self.stop_blocks) do
				stop_block:on_gate_opening(e, gate)
			end
		elseif gate:is_closing() then
			for stop_block_id, stop_block in pairs(self.stop_blocks) do
				stop_block:on_gate_closing(e, gate)
			end
		end
	end
end

function Block:check_connection(e, entity)
	print("Block:check_connection", entity.name)

	if entity.name == "gate" then

		self.gates[entity.unit_number] = entity

	elseif entity.name == "conductor-stop-block-combinator" then
		
		--if entity.conductor_object then
		--	for i, stop_block in pairs(entity.conductor_object) do
		--		self.stop_blocks[stop_block.entity.unit_number] = stop_block
		--	end
		--end

		--stop_block = get_conductor_object(e, entity, nil)
		--stop_block:reset_connections(e)

		--self.stop_blocks[entity.unit_number] = stop_block
	
	end
end

function Block:reset_connections(e)

	if self.last_reset == e.tick then return end
	self.last_reset = e.tick

	stop_blocks = {}
	gates = {}
	locked = false
	
	for i, entity in pairs(self.entity.circuit_connected_entities.red) do
		self:check_connection(e, entity)
	end

	for i, entity in pairs(self.entity.circuit_connected_entities.green) do
		self:check_connection(e, entity)
	end

end


