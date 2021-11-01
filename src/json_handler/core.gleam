import gleam/bit_string
import orlando.{MyOption}

pub fn foo() -> MyOption {
  MyOption(first: bit_string.from_string("hi"), second: "hi")
}
