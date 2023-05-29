on_wield = fmod.create()

on_wield.registered_on_wields = {}

function on_wield.register_on_wield(callback)
	table.insert(on_wield.registered_on_wields, callback)
end

on_wield.registered_on_unwields = {}

function on_wield.register_on_unwield(callback)
	table.insert(on_wield.registered_on_unwields, callback)
end

local last_wields_by_player_name = {}

function on_wield.do_wield(item, player, list, index)
	local def = item:get_definition()

	if def.on_wield then
		def.on_wield(item, player, list, index)
	end

	local registered_on_wields = on_wield.registered_on_wields
	for i = 1, #registered_on_wields do
		registered_on_wields[i](item, player, list, index)
	end
end

function on_wield.do_unwield(item, player, list, index)
	local def = item:get_definition()

	if def.on_unwield then
		def.on_unwield(item, player, list, index)
	end

	local registered_on_unwields = on_wield.registered_on_unwields
	for i = 1, #registered_on_unwields do
		registered_on_unwields[i](item, player, list, index)
	end
end

minetest.register_on_joinplayer(function(player)
	local player_name = player:get_player_name()
	local list = player:get_wield_list()
	local index = player:get_wield_index()
	local item = player:get_wielded_item()

	last_wields_by_player_name[player_name] = { item, list, index }

	on_wield.do_wield(item, player, list, index)
end)

minetest.register_on_leaveplayer(function(player)
	local player_name = player:get_player_name()

	local item, list, index = unpack(last_wields_by_player_name[player_name])
	on_wield.do_unwield(item, player, list, index)

	last_wields_by_player_name[player_name] = nil
end)

minetest.register_globalstep(function()
	local players = minetest.get_connected_players()
	for i = 1, #players do
		local player = players[i]
		local player_name = player:get_player_name()
		local list = player:get_wield_list()
		local index = player:get_wield_index()
		local item = player:get_wielded_item()
		local last_item, last_list, last_index = unpack(last_wields_by_player_name[player_name])

		if not (list == last_list and index == last_index and item == last_item) then
			on_wield.do_unwield(last_item, player, last_list, last_index)

			last_wields_by_player_name[player_name] = { item, list, index }

			on_wield.do_wield(item, player, list, index)
		end
	end
end)
