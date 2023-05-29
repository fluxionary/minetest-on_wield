note that this API only provides an *approximation* of wield/unwield events. events are only checked once per
server globalstep. if multiple wield/unwield events happen within a single step, some of these may be missed.
note that *any* change in the tool will result in wield/unwield events, including changes to stack size, wear, and
metadata. additionaly, wield events will be generated when a player logs in, and onwield events when a player
disconnects.

* `on_wield.register_on_wield(function(itemstack, player, list, index))`

  register a callback which will be called when a player wields an item which they were not previously wielding.

* `on_wield.register_on_unwield(function(itemstack, player, list, index))`

  register a callback which will be called *after* a player switches the item that they are wielding.
  while the item might still exist at `player:get_inventory():get_stack(list, index)`, it also might not. if
  you need to modify the item, you *must check* that it is still there, do not assume.

additionally, individual item definitions may define the following callbacks:

* `on_wield = function(itemstack, player, list, index)`

  same semantics as above

* `on_unwield = function(itemstack, player, list, index)`

  same semantics as above
