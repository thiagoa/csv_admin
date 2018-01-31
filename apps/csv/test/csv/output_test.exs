defmodule Csv.OutputTest do
  use ExUnit.Case

  defmodule FakeFile do
    def open(device, [:write]), do: {:ok, device}
    def close(device), do: send self(), {:close, device}
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

    {:ok, handle} = Csv.Output.open(fake_path, headers, FakeFile)
    Csv.Output.close(handle, FakeFile)

    assert fake_file_contents(fake_path) == "name,url,errors\n"
    assert_received {:close, ^handle}
  end

  defmodule BadFakeFile do
    def open("output.csv", [:write]), do: {:error, "failed to write csv"}
  end

  test "returns an error when the file can't be opened" do
    output = Csv.Output.open "output.csv", ~w(name url), BadFakeFile

    assert {:error, "failed to write csv"} = output
  end
end
