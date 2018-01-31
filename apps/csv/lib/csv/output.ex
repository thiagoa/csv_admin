defmodule Csv.Output do
  def open(path, headers, file_mod \\ File) do
    {:ok, device} = file_mod.open(path, [:write])
    headers = (headers ++ ["errors"]) |> Enum.join(",")

    IO.binwrite(device, headers <> "\n")
  end
end
