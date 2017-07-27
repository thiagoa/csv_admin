defmodule Csv.Import do
  alias Csv.RecordStream

  def call(input_path, schema: schema, headers: headers) do
    {:ok, device} = File.open(input_path)
    {:ok, stream} = RecordStream.new(device, headers: headers, schema: schema)

    stream
    |> Task.async_stream(Csv.Repo, :insert, [], max_concurrency: 10)
    |> Enum.to_list
  end
end
