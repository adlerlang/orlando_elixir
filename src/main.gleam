//Questions
// 1. Using Gleam as a webserver. Gleam has an Elli webserver. It is experimental so expect breaking
//    as Gleam Standard Library changes and if you are using Elixir, the Mix Compile library might
//    cause you some issues. You can call Elixir/Erlang libraries like Cowboy, but in conjuction,
//    it will be your preference in design. 
// 2. Calling Gleam from Elixir. That is what is happening here but not special going on the Elixir side. 
//    As I would have to cover three different code bases. We just use alias :main, as: Main.
//    Gleam is just a higher level langauge that compiles to Erlang. 
// These are some of the most used libraries included in the stdlib.
// We import gleam/map ... We import a type as gleam/map.{Map} ...
// We import another gleam file as import gleamfile and we alias with as
import gleam/io
import gleam/string
import gleam/string_builder
import gleam/int
import gleam/bit_string
import gleam/map.{Map}
import gleam/list
import gleam/iterator.{Iterator} as iter
import gleam/dynamic
import gleam/option.{Option}
import gleam/queue.{Queue}
import gleam/dynamic.{Dynamic}
import gleam/result

// 1.  There is no need for module naming. The file name generates the module name automatically.
//     This file name is main.gleam and it compiles to main.erl
//     If it was in a directory say json/main.gleam the module name becomes json@main.erl    
//      Calling if from Elixir is the same as calling a Erlang based module
//      alias :main, as: Main for example now I can call Main.function in Elixir fashion.
// 2.  Atoms package has been drop as of recent version, and so, 
//     I will not be talking about concurrency in general as OTP in gleam at this beginner talk. 
//     As I mentioned above the Atom package is removed but is needed for OTP library as a dependency.
//     Expect things to break at times wth version changes until Gleam 1... something. 
// 3.  There are different ways libraries work between languages on the beam. If you do Erlang
//     you will know about thesse differences already. I am going to keep this talk related to Elixir. 
//--------------------------------------------------------------------------------------------------------
// pub is public and without is private
// functions and variables are usually lowercase and undercased.
pub fn a_string() -> String {
  "hi"
}

pub type Atom {
  // will be :plainatom (notice that P is captialized only )
  Plainatom
  // pascal case atoms turn to :the_atom (notice both P and A are capitalized)
  PascalAtom


  CustomTuple(#(String, String))


  // {:is_string, "string"}
  IsString(String)

  // A record which will be a tuple of {:person, "joe", 8 } 
  Person(name: String, age: Int)
}

//
pub fn atom() -> List(Atom) {
  let plain_atom: Atom = Plainatom
  let pascal_atom: Atom = PascalAtom
  let is_string: Atom = IsString("is a string")
  let my_tuple: Atom = CustomTuple(#("hi", "mike"))
  let CustomTuple(#(hi, mike)) = my_tuple

  let IsString(get_string) = is_string
  io.debug(get_string)

  [plain_atom, pascal_atom, is_string]
}

// We know bools are atoms
pub fn bool() -> List(Bool) {
  [True, False]
}

// We also know nil is also atom 
pub fn nil() -> Nil {
  Nil
}

// dynamic is used to guard against unexpected parameter types from the outside world
// (Int instead of string, etc) 
pub fn is_string(string_value: String) -> Result(String, String) {
  dynamic.string(dynamic.from(string_value))
  // {:ok, is a string} or {:error, is a int not string}
}

//globals with const
pub const global_value: Int = 0

pub fn global() -> Int {
  global_value + 1
}

pub fn a_float() -> List(Float) {
  //adding floats requires a period after the operator
  [1.00 -. 0.25, 1.00 +. 0.25]
}

pub type ListExamples {

  First(Int)
  Second(Int)
  Rest(List(Int))
}

pub fn list() -> List(ListExamples) {
  let mylist: List(Int) = [1, 2, 3, 4, 5, 6]
  let [first, second, ..rest] = mylist
  [First(first), Second(second), Rest(rest)]
}

// Will not compile
// pub fn list_any() -> List(a) {
//   ["hi", 1, 3, 4, 5]
// }
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

pub fn map_no_key() -> Result(Int, Nil) {
  let my_map: Map(String, Int) = maps()
  map.get(my_map, "million")
}


// pattern matching 
pub fn pattern_matching() -> #(#(Int, String), #(Int, List(Int))) {
  let [head, ..tail]: List(Int) = [1, 2, 3, 4, 5]
  let #(a, b): #(String, Int) = #("one", 1)
      
  //there is no map literal syntax in Gleam, and you cannot pattern match on a map. Maps are generally not used much in Gleam
  #(#(b, a), #(head, tail))
}


// will not compile
// pub fn maps_any() -> Map(String, Int) {
//   let my_map =
//     map.new()
//     |> map.insert("one", 1)
//   let my_map =
//     map.new()
//     |> map.insert(2, "two")
// }

//                                  {:ok, "value"} {:error, "error"}
// pub fn results() -> Result(String, String) {
//   dynamic.string(dynamic.from(value))
//  //   Error()

// }
                                    //  option.s
pub fn options(value: String) -> Option(String) {
  let is_string = dynamic.string(dynamic.from(value))
  case result.is_ok(is_string) {
    True -> {
      let Ok(get_string) = is_string
      option.Some(get_string)
    }
    False -> option.None
  }
}

// After compiled to Erlang, parameters of course aren't 
// going to be type checked to do so use Dynamic
pub fn check_int(value: Int) -> Result(Int, String) {
  // dynamic will return a {:ok, value} or {:error, this is type not an int}
  dynamic.int(dynamic.from(value))
}

pub fn dynamic_list(mylist: List(String)) {
  // dynamic.list(dynamic.from(mylist))
  iter.from_list(mylist)
  |> iter.map
  (fn(value) {
    let dynamic_string: Result(String, String) =
      dynamic.string(dynamic.from(value))
    let dynamic_to_some = option.from_result(dynamic_string)
    option.unwrap(option.Some(dynamic_to_some), option.None)
  })
  |> iter.to_list
  |> option.values
}

pub fn lambda() -> Int {
  let my_first_lambda: Int = fn(x) { x + x }(3)
  my_first_lambda
}

//Example(Int)
// custom types are created by inject a type into them. like Example(Int)<- this produces a tuple {:example, 3}
// - record(meetup, {title, names, date}) 
// Elixir usually is 



//  defmethod Meetup do
//defstruct [:title, :names, :date]


pub type FirstMeet {
  Meetup(title: String, names: List(String), date: String)
//-record(meetup, {title, names, date})
       //  {meetup, title, names, date}
         {meetup, "elixirgroup", ["mike"], "Nov-10th"}


  Title(String)
}

//calling an Erlang or Elixir library in gleam
pub external fn to_json(List(Meetup)) -> Meetup =
  "jsx" "encode"

pub fn meetup(title: String, names: List(String), date: String) {
  let data: FirstMeet = Meetup(title: title, names: names, date: date)

  // %{title: t, names: n, date: d } = %Meetup{} pattern matching
  
    
  let Meetup(t , _n, _d) = data
  let Meetup(title, names, date) = {:meetup, title, names, date}

  [data, Title(t), to_json([Title(t)])]
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







