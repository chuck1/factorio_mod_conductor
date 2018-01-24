
-- represents relationship between a stop and a block
--
-- there can be multiple StopBlock objects per stop-block entity
StopBlock = {
	entity = nil,
	stop = nil,
	block = nil,
	t_1 = nil,
	t_2 = nil,
	gate_1 = nil,
	gate_2 = nil,
	last_reset = nil,
}

function StopBlock:new()
	o = {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function StopBlock:check_connection(e, entity)
	
	if entity.name == "conductor-block-combinator" then
		
		self.block = get_conductor_object(e, entity, nil)
		self.block:reset_connections(e)

	elseif entity.name == "conductor-stop-combinator" then
		
		self.stop = get_conductor_object(e, entity, nil)
		self.stop:reset_connections(e)
		
	end
end

function StopBlock:reset_connections(e)
	
	print("StopBlock reset connections", self.entity.unit_number, e.tick, self.last_reset)

	if self.last_reset == e.tick then return end
	self.last_reset = e.tick

	self.block = nil
	self.stop = nil
	self.t_1 = nil
	self.t_2 = nil
	self.gate_1 = nil
	self.gate_2 = nil

	for i, entity in pairs(self.entity.circuit_connected_entities.red) do
		self:check_connection(e, entity)
	end

	for i, entity in pairs(self.entity.circuit_connected_entities.green) do
		self:check_connection(e, entity)
	end

end

function StopBlock:on_gate_opening(e, gate)
	-- check if we're testing
	if not stop.is_testing then return end

	if self.gate_1 == nil then
		self.gate_1 = gate
		self.t_1 = e.tick
	elseif gate_2 == nil then
		self.gate_2 = gate
	end
end

function StopBlock:on_gate_closing(e, gate)
	-- check if we're testing
	if not stop.is_testing then return end

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




