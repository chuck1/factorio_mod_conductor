
function copy_prototype(entity_type, src, dst, order, ingrendients)

	local item = table.deepcopy(data.raw["item"][src])
	item.name = dst

	if order ~= nil then
		item.order = order
	end

	item.place_result = dst

	local entity = table.deepcopy(data.raw[entity_type][src])
	entity.name = dst

	local recipe = table.deepcopy(data.raw.recipe[src])
	recipe.name = dst
	recipe.enabled = true
	recipe.ingredients = ingredients
	recipe.result = dst

	data:extend({item, entity, recipe})
end

--"a[train-system]-cb[train-stop]"
copy_prototype("train-stop", "train-stop", "conductor-train-stop", nil, {{"train-stop", 1}, {"processing-unit", 10}})

copy_prototype("constant-combinator", "constant-combinator", "conductor-stop-combinator", nil, {{"constant-combinator", 1}, {"processing-unit", 5}})
copy_prototype("constant-combinator", "constant-combinator", "conductor-stop-block-combinator", nil, {{"constant-combinator", 1}, {"processing-unit", 5}})
copy_prototype("constant-combinator", "constant-combinator", "conductor-block-combinator", nil, {{"constant-combinator", 1}, {"processing-unit", 5}})
copy_prototype("rail", "rail", "conductor-rail", nil, {{"rail", 1}, {"processing-unit", 1}})



