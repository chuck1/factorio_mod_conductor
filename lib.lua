List = {}

function List:new()
	o = {first = 0, last = -1}
	setmetatable(o, self)
	self.__index = self
	return o
end


function List.push_right (list, value)
	local last = list.last + 1
	list.last = last
	list[last] = value
end

function List.pop_left (list)
	local first = list.first
	if first > list.last then error("list is empty") end
	local value = list[first]
	list[first] = nil        -- to allow garbage collection
	list.first = first + 1
	return value
end


