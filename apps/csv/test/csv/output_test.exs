defmodule Csv.OutputTest do
  use ExUnit.Case

  defmodule FakeFile do
    def open(device, [:write]), do: {:ok, device}
  end

  def new_fake_path do
    {:ok, fake_path} = StringIO.open("")
    fake_path
  end

  def fake_file_contents(fake_path) do
    {_, file_contents} = StringIO.contents(fake_path)
    file_contents
  end

  test "creates an output csv with the given headers" do
    fake_path = new_fake_path()
    headers = ~w(name url)

    Csv.Output.open(fake_path, headers, FakeFile)

    assert fake_file_contents(fake_path) == "name,url,errors\n"
  end
end
