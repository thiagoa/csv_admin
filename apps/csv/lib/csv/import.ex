defmodule Csv.Import do
  def call(input_path, options) do
    input_path
    |> File.read!
    |> String.split("\n")
    |> Enum.drop(1)
    |> Enum.reject(&(String.trim(&1) == ""))
    |> Enum.map(&String.split(&1, ","))
    |> Enum.map(fn([name, url]) ->
      struct(options[:schema], %{name: name, url: url})
    end)
    |> Enum.each(&Csv.Repo.insert/1)
  end
end
