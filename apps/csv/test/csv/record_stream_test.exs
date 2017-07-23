defmodule RecordStreamTest do
  use ExUnit.Case

  test "streams an empty list when csv has no rows" do
    {:ok, device} = StringIO.open("name,url\n")
    {:ok, stream} = Csv.RecordStream.new(device, headers: ~w(name url)a, schema: Site)

    assert [] == Enum.to_list(stream)
  end
end
