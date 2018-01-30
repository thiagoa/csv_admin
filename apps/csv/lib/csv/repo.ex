defmodule Csv.Repo do
  @callback insert(record :: struct) :: {:ok, struct} | {:error, struct}
end
