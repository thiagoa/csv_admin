defmodule Csv.Output do
  def open(path, headers, file_mod \\ File) do
    case file_mod.open(path, [:write]) do
      {:ok, handle} ->
        headers = headers ++ ["errors"] |> Enum.join(",")
        IO.binwrite(handle, headers <> "\n")
        {:ok, handle}

      {:error, reason} ->
        {:error, reason}
    end
  end

  def close(handle, file_mod \\ File) do
    file_mod.close(handle)
  end
end
