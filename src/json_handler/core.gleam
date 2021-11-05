import gleam/bit_string
import gleam/io
import gleam/map.{Map}
import gleam/result
import gleam/option.{Option}
import gleam/dynamic.{Dynamic}

pub opaque type Json {
  Person(name: String, age: Int)
}

//"encode" or "decode" as input
pub external fn exjson(input: String, b: Map(String, Int)) -> Result(a, String) =
  "Elixir.Exgleam" "to_json"

pub external fn record_to_json(
  input: String,
  b: List(#(String, Int)),
) -> Result(a, String) =
  "Elixir.Exgleam" "to_json"

pub fn make_json_rec(value: Json) {
  case value {
    Person(name: name, age: age) -> {
      let json = [#(name, age)]
      Ok(record_to_json("encode", json))
    }

    _ -> Error("error")
  }
}

pub fn make_json(mapvalue: Map(String, Int)) {
  let check_map = dynamic.map(dynamic.from(mapvalue))
  let check_size =
    result.unwrap(check_map, map.new())
    |> map.size
  let check_size = check_size > 0

  io.debug(check_size)

  case check_map, check_size {
    Ok(_), True -> Ok(exjson("encode", mapvalue))
    _, False -> Error("empty list")
    Error(e), _ -> Error(e)
  }
}
