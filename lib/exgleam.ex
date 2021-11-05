defmodule Exgleam do
alias :json_handler@core, as: Json
alias :main, as: Main


def meetup() do
  names = ["Joe", "Kaylee", "and so on..."]
  data = "Nov 10, 2021"
  title= "Beginners thinking on Gleam"

  Main.meetup(title, names, data)

end

def basics do
  Main.basics()
end

def map_example() do
  Main.map_example()
end

def list_example() do
  Main.list_example()
end










def make_json(mymap) do
  Json.make_json(mymap)
end


  def to_json("encode", value) do
     :jsx.encode(value)
    end

    def to_json("decode", value) do
      :jsx.decode(value)
     end


end
