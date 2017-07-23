defmodule RecordStreamTest do
  use ExUnit.Case
  alias Csv.Schemas.Site

  test "streams an empty list when csv has no rows" do
    {:ok, device} = StringIO.open("name,url\n")
    {:ok, stream} = Csv.RecordStream.new(device, headers: ~w(name url)a, schema: Site)

    assert [] == Enum.to_list(stream)
  end

  test "streams csv rows as structs" do
    {:ok, device} = StringIO.open """
    name,url
    Elixir Language,https://elixir-lang.org
    Semaphore Blog,https://semaphoreci.com/blog
    """
    {:ok, stream} = Csv.RecordStream.new(device, headers: ~w(name url)a, schema: Site)

    assert [
      %Site{name: "Elixir Language", url: "https://elixir-lang.org"},
      %Site{name: "Semaphore Blog", url: "https://semaphoreci.com/blog"}
    ] = Enum.to_list(stream)
  end

  test "streams correctly when headers are shuffled" do
    {:ok, device} = StringIO.open """
    url,name
    https://elixir-lang.org,Elixir Language
    """
    {:ok, stream} = Csv.RecordStream.new(device, headers: ~w(name url)a, schema: Site)

    assert [
      %Site{name: "Elixir Language", url: "https://elixir-lang.org"},
    ] = Enum.to_list(stream)
  end

  test "returns :invalid_csv when missing required columns" do
    {:ok, device} = StringIO.open """
    name
    Elixir Language
    """

    assert :invalid_csv == Csv.RecordStream.new(device, headers: ~w(name url)a, schema: Site)
  end
end
