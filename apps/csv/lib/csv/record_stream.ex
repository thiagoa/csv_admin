defmodule Csv.RecordStream do
  def new(device, headers: expected_headers, schema: schema) do
    stream = device
    |> IO.stream(:line)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split(&1, ","))

    headers = stream
    |> Enum.fetch!(0)
    |> Enum.map(&String.to_atom/1)

    if Enum.sort(headers) == Enum.sort(expected_headers) do
      structs = stream
      |> Stream.map(fn(row) ->
        contents = headers
        |> Enum.zip(row)
        |> Enum.into(%{})

        struct(schema, contents)
      end)

      {:ok, structs}
    else
      :invalid_csv
    end
  end
end
