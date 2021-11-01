import gleam/io

pub fn main() -> String {
  io.print("hi")
  "hi"
}

pub external fn elixir_enum_map(a, b) -> List(Int) =
  "Elixir.Enum" "map"

pub fn try_elixir() {
  let m: List(Int) = [1, 2, 3, 4]

  m
  |> elixir_enum_map(fn(x) { x + x })
}
