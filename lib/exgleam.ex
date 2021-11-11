defmodule Exgleam do
alias :main, as: Main
# while you can add subdirectory modules to Elixir,
# It would be probably better to import via Gleam.
alias :json_handler@core, as: Json



def atom() do
Main.atom
end





def meetup() do
  names = ["Joe", "Kaylee", "and so on..."]
  data = "Nov 10, 2021"
  title= "Beginners thinking on Gleam"

  Main.meetup(title, names, data)

end

def maps() do
  Main.maps()
end

def tuples() do
  Main.tuples
end

def pattern_matching() do
  Main.pattern_matching()
end

def error_handling() do
  Main.error_handling
end

def iterate() do
  Main.iterate()
end






def a_string(),do: Main.a_string()






def make_json(mymap) do
  Json.make_json(mymap)
end


  def to_json("encode", value) do
     :jsx.encode(value)
    end

    def to_json("decode", value) do
      :jsx.decode(value)
     end



     def options(value), do: Main.options(value)

     def is_string(value), do: Main.is_string(value)

     def check_int(value), do: Main.check_int(value)

     def dynamic_list(value), do: Main.dynamic_list(value)

end
