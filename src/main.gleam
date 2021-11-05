//Rules
// Modules are created by file name. example.gleam -> example.erl and folder/example.erl -> folder@example.erl the names are also the external
// calls folder@example:hello() -> hello function in the module. 
// We are skipping the Elixir layer and going straight to Erlang when compiled
// Familar syntax though we are using Rust. Though there are some different and added methods. 
// There is no map literal syntax in Gleam, and you cannot pattern match on a map. Maps are generally not used much in Gleam.
// Atoms are rarely used. In fact after 0.16 version 0.17 doesn't include the Atom libary. This will break the gleam/otp library
// which is experimental to begin with. 
import gleam/io
import gleam/string
import gleam/string_builder
import gleam/int
import gleam/bit_string
import gleam/map.{Map}
import gleam/list
import gleam/iterator as iter
import gleam/dynamic
import gleam/option.{Option}
import gleam/queue.{Queue}
import gleam/dynamic.{Dynamic}
import gleam/should
import gleam/result
import second

pub type ListStringInt =
  List(#(String, Int))

pub type MapStringInt =
  Map(String, Int)

pub type Details {
  Names(List(String))
  Date(String)
}

pub type Meetup {
  Meetup(List(Details))
}

pub type MapExample {
  MyAtom
  MapNew(MapStringInt)
  MapGenerated(MapStringInt)
  PropListBeforeMap(ListStringInt)
  ListFromMap
  MapIterator
  KeyNotInMap(Nil)
}

pub type ListExample {
  PatternMatchList(List(#(String, Int)))
  PatternMatchResults(String)
  ListIterator(ListStringInt)
  Head(#(String, Int))
  Tail(ListStringInt)
}

pub type Basics {
  First
  MyFirstAtom
  MyFirstString(String)
  MyFirstList(List(Int))
  MyFirstTuple(#(String, Int))
  MyFirstMap(Map(String, Int))
  MapResult(Result(Int, Nil))
  IsNil(Nil)
}

pub fn meetup(names: List(String), date: String) {
  let meetup_data: List(Meetup) = [Meetup([Names(names), Date(date)])]
}

pub fn basics() {
  let first_atom: Basics = First
  let atom_underlined: Basics = MyFirstAtom
  let mynil: Nil = Nil

  let my_first_string: String = "hello"
  let my_first_list: List(Int) = [1, 2, 3, 4]
  let my_first_tuple: #(String, Int) = #("welcome", 1)

  // Lists can only be generated this way from proplists (Lists of Tuples) [#()]
  let my_first_map: Map(String, Int) = map.from_list([#("key", 1)])

  // Indexing isn't what you expect. You get back a tuple of ok or error because Erlang doesn't handle nils. 
  let map_indexing_ok =
    my_first_map
    |> map.insert("new_key", 2)
    |> map.get("new_key")

  let map_indexing_error =
    my_first_map
    |> map.get("not_a_key")

  [
    first_atom,
    atom_underlined,
    IsNil(mynil),
    MyFirstString(my_first_string),
    MyFirstList(my_first_list),
    MyFirstTuple(my_first_tuple),
    MyFirstMap(my_first_map),
    MapResult(map_indexing_ok),
    MapResult(map_indexing_error),
  ]
}

pub fn map_example() {
  // maps are generated 2 ways new and actual creation of the map as usual in Elixir
  // How to Write Atoms they are just declared as types. The type system is all about them 
  let atom = MyAtom

  // piping as normal in Elixir
  let new_map: MapStringInt =
    map.new()
    |> map.insert("key", 1)

  // to generate a map in gleam the original type must be a proplist List(#()) List of tuples
  // tuples are generated by syntax #("key", 1) {:key, 1} or {key, 1}
  let prop_list: MapExample = PropListBeforeMap([#("key", 1)])
  let PropListBeforeMap(get_prop_list) = prop_list

  let list_to_map: MapStringInt = map.from_list(get_prop_list)
  let create_map: MapExample = MapGenerated(list_to_map)

  [atom, prop_list, create_map]
}

pub fn list_example() {
  let mylist: ListExample = PatternMatchList([#("key", 1)])
  let PatternMatchList([#(key, value)]) = mylist

  let iter_list: ListStringInt = [#("a", 1), #("b", 2)]
  let iteration =
    iter.from_list(iter_list)
    |> iter.map(fn(value) {
      let #(letter, number) = value
      let letter =
        letter
        |> string.uppercase
      let number = number + 1
      #(letter, number)
    })
    |> iter.to_list

  let [head, ..tail] = iter_list

  let m = string.append(key, int.to_string(value))

  [ListIterator(iteration), Head(head), Tail(tail), PatternMatchResults(m)]
}
