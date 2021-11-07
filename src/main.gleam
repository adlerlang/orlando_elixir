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

pub fn a_string() {
  "hi"
}

pub type Atom {
  // will be :plainatom
  Plainatom
  // pascal case atoms turn to :the_atom 
  PascalAtom

  // {:is_string, "string"}
  IsString(String)
}

pub fn atom() -> List(Atom) {
  let plain_atom: Atom = Plainatom
  let pascal_atom: Atom = PascalAtom
  let is_string: Atom = IsString("is a string")
  let IsString(get_string) = is_string
  io.debug(get_string)

  [plain_atom, pascal_atom, is_string]
}

pub fn is_string(string_value: String) -> Result(String, String) {
  dynamic.string(dynamic.from(string_value))
}

pub fn is_string_also(string_value: String) -> Result(List(Dynamic), String) {
  dynamic.list(dynamic.from(string_value))
}

//globals with const
pub const global_value: Int = 0

pub fn global() -> Int {
  global_value + 1
}

pub fn a_float() -> Float {
  1.00 +. 0.25
  //adding floats requires a period after the operator
  1.00 -. 0.25
}

pub fn tuples() -> #(String, Int) {
  #("one", 1)
}

pub fn maps() -> Map(String, Int) {
  let new_map =
    map.new()
    |> map.insert("one", 1)

  // maps are formed from proplists (List of tuples). List is your standard []
  let gen_map = map.from_list([#("two", 2), #("three", 3)])

  let final_map = map.merge(new_map, gen_map)
  final_map
}

pub fn map_no_key() {
  let my_map: Map(String, Int) = maps()
  map.get(my_map, "million")
}

// After compiled to Erlang, parameters of course aren't 
// going to be type checked to do so use Dynamic
pub fn check_int(value: Int) -> Result(Int, String) {
  // dynamic will return a {:ok, value} or {:error, this is type not an int}
  dynamic.int(dynamic.from(value))
}

pub fn result_to_option() {
  option.from_result(check_int(3))
}

pub fn lambda() -> fn(Int) -> Int {
  let my_first_lambda: fn(Int) -> Int = fn(x) { x + x }
  my_first_lambda
}

//Example(Int)
// custom types are created by inject a type into them. like Example(Int)<- this produces a tuple {:example, 3}
// - record(meetup, {title, names, date}) 
// Elixir usually is 
//  defmethod Meetup do
//defstruct [:title, :names, :date]
pub type Meetup {
  Meetup(title: String, names: List(String), date: String)
  RecordValueReturn(Meetup, List(String))
}

pub fn meetup(title: String, names: List(String), date: String) {
  let data: Meetup = Meetup(title: title, names: names, date: date)

  // %{title: t, names: n, date: d } = %Meetup{} pattern matching
  let Meetup(t, _n, _d) = data

  [RecordValueReturn(data, ["I only return title:", t]), to_json([#(Title, t)])]
}

// pattern matching 
pub fn pattern_matching() -> #(#(Int, String), #(Int, List(Int))) {
  let [head, ..tail]: List(Int) = [1, 2, 3, 4, 5]
  let #(a, b): #(String, Int) = #("one", 1)

  //there is no map literal syntax in Gleam, and you cannot pattern match on a map. Maps are generally not used much in Gleam
  #(#(b, a), #(head, tail))
}

// error handling pattern match
pub fn error_handling() -> Result(Int, String) {
  let value: Int = 1
  case value {
    1 -> {
      io.debug("parentheses are need for multiple values")
      Ok(1)
    }
    // {:ok, 1}
    _ -> Error("is not the one")
  }
}

pub fn iterate() -> List(Int) {
  let my_list: List(Int) = [1, 2, 3, 4, 5, 6, 7, 8, 9]

  iter.from_list(my_list)
  |> iter.map(fn(case_value) {
    case case_value > 1 {
      True -> option.Some(case_value)
      False -> option.None
    }
  })
  |> iter.to_list()
  |> option.values
}

pub fn types_in_action(value: Int) -> Result(Int, String) {
  // we use dynamic because once the code is compiled. Elixir is dynamic so we are insuring what comes
  // from it is indeed an int. 
  let result = dynamic.int(dynamic.from(value))

  //
  case result {
    Ok(return) -> Ok(return)
    Error(error) ->
      Error(string.append("Is not an int with the following error: ", error))
  }
  // this will result in an automatic error if not ok. Just like {:ok, 3} = {:ok, 4}
  // but unlike Elixir it isn't an Match error but a
  //** (ErlangError) Erlang error: %{function: "types_in_action", gleam_error: :assert, line: 130, message:
  // "Assertion pattern match failed", module: "main", value: {:error, "Expected an int, got a binary"}}
  // assert Ok(value) = result
}

// PropList of String,Int [{:one, 1}, {:two,2}] this is a type alias
pub type ListStringInt =
  List(#(String, Int))

// Map of String, Int %{"one"=> 1}
pub type MapStringInt =
  Map(String, Int)

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
  Title
  First
  MyFirstAtom
  MyFirstString(String)
  MyFirstList(List(Int))
  MyFirstTuple(#(String, Int))
  MyFirstMap(Map(String, Int))

  MapResult(String, Result(Int, Nil))
  IsNil(Nil)
}

//starting writing functions. For now, I avoided placing a return type.
// A return type is exactly how Rust, Swift, and maybe others do it. 
//          (without private)
// Example  (marked public)  (function)  (name of function)       (return type)
//          pub              fn          example(a: List(Int))     -> List(Int)
pub external fn to_json(List(#(Basics, String))) -> a =
  "jsx" "encode"

pub fn basics() {
  let first_atom: Basics = First
  let atom_underlined: Basics = MyFirstAtom
  let mynil: Nil = Nil
  let my_first_string: String = "hello"
  let my_first_list: List(Int) = [1, 2, 3, 4]
  let my_first_tuple: #(String, Int) = #("welcome", 1)

  // Lists can only be generated this way from proplists (Lists of Tuples) [#()]
  let my_first_map: Map(String, Int) = map.from_list([#("key", 1)])

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
    MapResult("is ok", map_indexing_ok),
    MapResult(
      "This is returned because Erlang will not handle nil like Elixir does",
      map_indexing_error,
    ),
  ]
}

pub fn map_example() {
  // maps are generated 2 ways new and actual creation of the map as usual in Elixir
  // How to Write Atoms they are just declared as types. The type system is all about them
  let atom = MyAtom

  // piping as normal in Elixir
  let new_map: MapStringInt =
    map.new()
    |> map.insert("inserted_key", 1)
  let new_map: MapExample = MapNew(new_map)

  // to generate a map in gleam the original type must be a proplist List(#()) List of tuples
  // tuples are generated by syntax #("key", 1) {:key, 1} or {key, 1}
  let prop_list: MapExample = PropListBeforeMap([#("key", 1)])
  let PropListBeforeMap(get_prop_list) = prop_list

  let list_to_map: MapStringInt = map.from_list(get_prop_list)
  let create_map: MapExample = MapGenerated(list_to_map)

  [atom, prop_list, new_map, create_map]
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
