defmodule Csv.RecordStream do
  def new(device, headers: expected_headers, schema: schema) do
    stream = device |> to_stream
    headers = stream |> extract_headers

    if valid_headers?(headers, expected_headers) do
      {:ok, Stream.map(stream, &to_struct(&1, schema, headers))}
    else
      :invalid_csv
    end
  end

  def valid_headers?(headers, valid_headers) do
    Enum.sort(headers) == Enum.sort(valid_headers)
  end

  defp to_stream(device) do
    device
    |> IO.stream(:line)
    |> NimbleCSV.RFC4180.parse_stream(headers: false)
  end

  defp extract_headers(stream) do
    stream
    |> Enum.fetch!(0)
    |> Enum.map(&String.to_atom/1)
  end

  defp to_struct(row, schema, headers) do
    headers
    |> Enum.zip(row)
    |> Enum.into(%{})
    |> (fn(contents) -> struct(schema, contents) end).()
  end
end
