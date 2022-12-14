# futil - flux's utility mod

a bunch of simiple lua routines and data structures

WARNING: i am contemplating breaking up the api into multiple namespaces, anticipate changes

## classes

* `futil.class1(super)`
  a simple class w/ optional inheritance
* `futil.class(...)`
  a less simple class w/ multiple inheritance and `is_a` support

## data structures

* `futil.Deque`

  a deque. supported methods:
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

* `futil.DefaultTable`

  a table in which missing keys are automatically filled in. usage:
  ```lua
  local default_table = futil.DefaultTable(function(key) return {} end)
  default_table.foo.bar = 100 -- foo is automatically created as a table
  ```

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

* `futil.file_exists(path)`

  returns true if the path points to a file that can be opened

### functional

* `futil.functional.noop()`

  the NOTHING function does nothing.

* `futil.functional.identity(x)`

  returns x

* `futil.functional.izip(...)`

  [zips](https://docs.python.org/3/library/functions.html#zip) iterators.

* `futil.functional.zip(...)`

  [zips](https://docs.python.org/3/library/functions.html#zip) tables.

* `futil.functional.imap(func, ...)`

  maps a function to a sequence of iterators. the first arg to func is the first element of each iterator, etc.

* `futil.functional.map(func, ...)`

  maps a function to a sequence of tables. the first arg to func is the first element of each table, etc.

* `futil.functional.apply(func, t)`

  for all keys `k`, set `t[k] = func(t[k])`

* `futil.functional.reduce(func, t, initial)`

  applies binary function `func` to successive elements in t and a "total". supply `initial` if possibly `#t == 0`.
  e.g. `local sum = function(values) return reduce(function(a, b) return a + b end, values, 0) end`.

* `futil.functional.partial(func, ...)`

  curries `func`. `partial(func, a, b, c)(d, e, f) == func(a, b, c, d, e, f)

* `futil.functional.compose(a, b)`

  binary operator which composes two functions. `compose(a, b)(x) == a(b(x))`

* `futil.functional.ifilter(pred, i)`

  returns an interator which returns the values of iterator `i` which match predicate `pred`

* `futil.functional.filter(pred, t)`

  returns an interator which returns the values of table `t` which match predicate `pred`

### iterators

* `futil.iterators.range(...)`

  * one arg: return an iterator from 1 to x.
  * two args: return an iterator from x to y
  * three args: return an iterator from x to y, incrementing by z

* `iterators.repeat_(value, times)`

  * times = nil: return `value` forever
  * times = positive number: return `value` `times` times

* `iterators.chain(...)`

  given a sequence of iterators, return an iterator which will return the values from each in turn.

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

  like the above, given a position and radius (L??? metric)

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
