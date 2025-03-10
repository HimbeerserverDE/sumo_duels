minetest.register_on_craft(function(itemstack, player, old_craft_grid, craft_inv)
	itemstack:set_count(0)
	return itemstack
end)

minetest.register_privilege("build", {
	description = "Player can build and dig nodes",
})

minetest.register_on_placenode(function(pos, newnode, placer, oldnode, itemstack, pointed_thing)
	if not placer then return end
	if not placer:is_player() then return end
	if not minetest.check_player_privs(placer:get_player_name(), {build = true}) then
		minetest.set_node(pos, oldnode)
		minetest.chat_send_player(placer:get_player_name(), "You can't place this node.")
		return itemstack
	end
end)

minetest.register_on_dignode(function(pos, oldnode, digger)
	if not digger then return end
	if not digger:is_player() then return end
	if not minetest.check_player_privs(digger:get_player_name(), {build = true}) then
		minetest.set_node(pos, oldnode)
		minetest.chat_send_player(digger:get_player_name(), "You can't dig this node.")
		local inv = digger:get_inventory()
		local lists = inv:get_lists()
		for list, v in pairs(lists) do
			for _, itemstack in ipairs(v) do
				if itemstack:get_name() == oldnode.name then
					itemstack:set_count(itemstack:get_count() - 1)
				end
			end
		end
		inv:set_lists(lists)
	end
end)
