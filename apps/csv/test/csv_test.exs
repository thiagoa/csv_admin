defmodule CsvTest do
  use ExUnit.Case
  doctest Csv

  test "greets the world" do
    assert Csv.hello() == :world
  end
end
