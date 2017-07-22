defmodule Csv.Repo do
  @me __MODULE__

  def start_link do
    Agent.start_link(fn -> [] end, name: @me)
  end

  def insert(record) do
    Agent.update @me, fn(collection) -> collection ++ [record] end
    {:ok, record}
  end

  def all do
    Agent.get(@me, fn(collection) -> collection end)
  end
end
