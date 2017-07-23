defmodule Csv.RecordStream do
  def new(_device, headers: _headers, schema: _schema) do
    stream = Stream.map([], fn(_) -> nil end)
    {:ok, stream}
  end
end
