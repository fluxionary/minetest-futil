# futil - flux's utility mod

a bunch of simiple lua routines and data structures

## data structures

* `futil.class1(super)`
  a simple class w/ optional inheritance
* `futil.class(...)`
  a less simple class w/ multiple inheritance and `is_a` support

* `futil.Deque`
  a deque class. supported methods:
  * `Deque:size()`
  * `Deque:push_front(value)`
  * `Deque:push_back(value)`
  * `Deque:pop_front()`
  * `Deque:pop_back()`

* `futil.PairingHeap`
  a pairing heap. supported methods:
  * `PairingHeap:size()`
  * `PairingHeap:peek_max()`
  * `PairingHeap:delete(value)`
  * `PairingHeap:delete_max()`
  * `PairingHeap:get_priority(value)`
  * `PairingHeap:set_priority(value, priority)`

## general routines

* `futil.check_call(func)`
  wraps `func` in a pcall. if no error occurs, returns the results. otherwise, logs and returns nil.
* `futil.memoize1(f)`
  memoize a single-argument function
* `futil.truncate(s, max_length, suffix)`
  if the string is longer than max_length, truncate it and append suffix. suffix is optional, defaults to "..."
* `futil.lc_cmp(a, b)`
  case-insensitive comparator
* `futil.table_set_all(t1, t2)`
  sets all key/value pairs of t2 in t1
* `futil.pairs_by_value(t, sort_function)`
  iterator which returns key/value pairs, sorted by value
* `futil.pairs_by_key(t, sort_function)`
  iterator which returns key/value pairs, sorted by key
* `futil.table_size(t)`
  gets the size of a table
* `futil.table_is_empty(t)`
  returns true if the table is empty
* `futil.equals(a, b)`
  returns true if the tables (or other values) are equivalent. do not use w/ recursive structures.
  currently does not inspect metatables.
* `futil.count_elements(t)`
  given a table in which some values may repeat, returns a table mapping values to their count.
* `futil.sets_intersect(set1, set2)`
  returns true if `set1` and `set2` have any keys in common.
* `futil.wait(n)`
  busy-waits n microseconds

## minetest-specific routines

* `futil.add_groups(itemstring, new_groups)`
  `new_groups` should be a table of groups to add to the item's existing groups
* `futil.remove_groups(itemstring, ...)`
  `...` should be a list of groups to remove from the item's existing groups
* `futil.get_items_with_group(group)`
  returns a list of itemstrings which belong to the specified group
* `futil.get_location_string(inv)`
  given an `InvRef`, get a location string suitable for use in formspec
* `futil.resolve_item(item)`
  given an itemstring or `ItemStack`, follows aliases until it finds the real item.
  returns an itemstring.
* `futil.items_equals(item1, item2)`
  returns true if two itemstrings/stacks represent identical stacks.
* `futil.get_blockpos(pos)`
  converts a position vector into a blockpos
* `futil.get_block_bounds(blockpos)`
  gets the bound vectors of a blockpos
* `futil.formspec_pos(pos)`
  convert a position into a string suitable for use in formspecs
* `futil.iterate_area(minp, maxp)`
  creates an iterator for every point in the volume between minp and maxp
* `futil.iterate_volume(pos, radius)`
  like the above, given a position and radius (L∞ metric)
* `futil.serialize(x)`
  turns a simple lua data structure (e.g. a table no userdata or functions) into a string
* `futil.deserialize(data)`
  the reverse of the above. not safe; do not use w/ untrusted data
* `futil.strip_translation(msg)`
  strips minetest's translation escape sequences from a message
* `futil.get_safe_short_description(item)`
  gets a short description which won't contain unmatched translation escapes
* `futil.escape_texture(texturestring)`
  escapes a texture modifier, for use within another modifier
