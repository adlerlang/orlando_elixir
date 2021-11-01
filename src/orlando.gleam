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
import gleam/atom.{Atom}
//import gleam/otp/process.{Pid, Receiver, Sender}
import gleam/int
import gleam/bit_string
import gleam/map.{Map}
import gleam/list
import gleam/iterator
import gleam/dynamic
import gleam/option.{Option}
import gleam/queue.{Queue}
import gleam/dynamic.{Dynamic}
import gleam/should
import gleam/result
import second

// Simple record 
// in Erlang record are tuples 
// so in Elixir we tend to use structs which are map based. 
pub type Person {
  Person(name: String)
}

pub type MyOption {
  MyOption(first: BitString, second: String)
}

// Global more or less like Elixir
// Once compiled to Erlang if you are looking for the global. We can't use @ though here. 
// It just became a copy within the functions boundary. 
pub const global: Int = 3

// As I defined a record above as tuples it is exactly that.
// This function returns a tuple and uses the element method
// to get value.
// Elixir  
//defmodule Person do 
//  defstruct [:name]
//  end
// m = %Person{name: "mike"}
//m.name 
pub fn rec_tutorial() -> String {
  let mike: Person = Person(name: "mike")
  mike.name
}

pub fn recur_tut(insert: List(Int), value: Int) {
  case insert {
    [head, ..tail] -> {
      io.debug(value)
      io.print("\n")
      recur_tut(tail, head + 1)
    }
    [] -> {
      io.print("done \n")
      value
    }
  }
}

//example of lambda functions
//Elixir 
//  fun = fn(a)-> a + a end .(1)
pub fn lambda() -> Int {
  let fun = fn(a: Int) { a + a }(1)

  fun
  |> fn(a: Int) { a + a }
}

pub fn patternmatch() -> Result(#(String, Int, Int, List(Int)), Nil) {
  // list pattern match
  let [head, ..tail] = [1, 2, 3, 4]
  // tuple pattern match
  let #(k, v) = #("k", 5)

  let Ok(three) = Ok(3)
  let option.Some(four) = option.Some(4)
  io.print("patternmatch Ok tuple and Some \n")
  io.print(int.to_string(three))
  io.print(int.to_string(four))
  io.print("checking ok error")
  io.print("\n")

  case #(v, head) {
    #(4, 1) -> Ok(#(k, v, head, tail))
    _ -> Error(Nil)
  }
}

// pipeline pretty much from Elixir.
pub fn pipeline() -> String {
  "orlando Elixir"
  |> string.uppercase()
  |> string.lowercase()
}

// maps are technically written like proplists in erlang here. It then uses gleam library
// which in return transform it using "from_list" method in Erlang. Nothing different here.
// this function prints the an {ok, int} tuple
pub fn map_tutorial() -> Result(Int, Nil) {
  // Elixir
  // full_map = [{1,2}, {3,5}] |> Enum.into(%{})
  let full_map: Map(String, Int) = map.from_list([#("two", 2), #("one", 3)])

  //Elixir
  // map = Map.new()
  let new_map = map.new()

  // Elixir
  // full_map = fullmap  |> Map.pop(%{"three" => 3}) 
  let full_map: Map(String, Int) =
    full_map
    |> map.insert("three", 3)

  // full_map = fullmap  |>Map.pop(%{"four" => 44}) 
  let new_map =
    new_map
    |> map.insert("four", 4)

  // merge_map = Map.merge(full_map, new_map)
  let merge_map = map.merge(full_map, new_map)

  // IO.inspect(merge_map)
  io.debug(merge_map)

  //Map.get(i, "five")
  //What error do we get here?  Well in Elixir we would get Nil but this compiles to Erlang So we need to get an {ok, nil} Result because
  // Erlang has no nil, it will result in a bad key exception
  map.get(merge_map, "five")
}

pub fn map_tutorial_two() {
  let new_map =
    map.new()
    |> map.insert("first", 1)

  io.debug(new_map)
  let dy = dynamic.map(dynamic.from(new_map))
  io.debug(dy)
  dy
}

pub fn queue_tut() -> Result(#(Int, Queue(Int)), Nil) {
  let new_queue =
    queue.new()
    |> queue.push_back(1)
    |> queue.push_front(2)
    |> queue.push_back(3)

  let l = queue.length(new_queue)
  io.print(int.to_string(l))
  new_queue
  |> queue.pop_back
}

// {some, value} 
pub fn some_none() -> Result(String, Int) {
  let some: Option(Result(String, Int)) = option.Some(Ok("hi"))
  io.debug(some)
  option.unwrap(some, Error(3))
}

pub fn some_none_two() {
  [option.Some(2), option.None, option.Some(3)]
}

pub fn iterator_tut() -> List(Int) {
  [1, 2, 3, 4]
  |> iterator.from_list
  |> iterator.map(fn(x) { x + x })
  |> iterator.to_list
}

pub fn astry() {
  let m = {
    let x = 32
    x + x
  }
}

pub fn reduceexample() -> Result(Int, Nil) {
  let list_example: List(Int) = [1, 2, 3, 4, 5, 6]

  iterator.from_list(list_example)
  |> iterator.reduce(fn(x, y) { x + y })
}

pub fn mapexample() -> List(String) {
  iterator.range(from: 0, to: 100)
  |> iterator.map(fn(x) {
    case x % 2 {
      0 -> "even"
      1 -> "odd"
    }
  })
  |> iterator.to_list
}

pub fn int_string() -> String {
  let a: String = int.to_string(3)
  let v: String = string.append("hi ", a)
  case v {
    "hi 3" -> {
      let a = v
      io.print(a)
    }
    _ -> io.print("none")
  }

  let from_global = global - 1
  let final = int.to_string(from_global)

  final
}

pub fn go() -> Result(MyOption, Nil) {
  string_result()
}

fn string_result() -> Result(MyOption, Nil) {
  // Just slicing string from index 0 to index 1
  let slice_hi = string.slice("hi", 0, 1)

  //showcase Elixir like piping
  let uplo =
    string.uppercase("hi")
    |> string.lowercase()

  let v: BitString =
    string.append(slice_hi, uplo)
    |> bit_string.from_string()
  let d: MyOption = MyOption(first: v, second: "second")

  case uplo {
    "h" -> Ok(d)
    _ -> Error(Nil)
  }
}

pub fn printsecond() {
  second.go()
}

pub fn atomtut() -> Atom {
  atom.create_from_string("hi")
}
// pub fn main() {
//   list.range(0, 1000)
//   |> list.each(start_process)
// }
// fn start_process(i) {
//   process.start(fn() {
//     let message = string.append("Hello world: ", int.to_string(i))
//     io.println(message)
//   })
// }
// pub fn pro() {
//   let #(sender, receiver) = process.new_channel()
//   process.start(fn() { process.send(sender, "no") })
//   process.receive(receiver, 2)
//   |> should.equal(Ok("hi"))
// }
// fn call_message(value) {
//   fn(reply_channel) {
//     io.debug(reply_channel)
//     #(value, reply_channel)
//   }
// }
// pub fn send_message() {
//   let #(parent_send, parent_receive) = process.new_channel()
//   receive_message(parent_send, parent_receive, [])
//   |> process.try_call(call_message(50), 50)
//   |> should.equal(Ok(50))
// }
// pub fn receive_message(parent_sender, parent_receiver, _value) {
//   process.start(fn() {
//     let #(child_send, child_receive) = process.new_channel()
//     process.send(parent_sender, child_send)
//     assert Ok(#(x, callit)) = process.receive(child_receive, 50)
//     process.send(callit, x)
//   })
//   assert Ok(callsender) = process.receive(parent_receiver, 50)
//   callsender
// }
