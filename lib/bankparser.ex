defmodule Bankparser do

  def split_lines(content) do
    { _last, rest } = content
    |> String.split(~r{\n})
    |> List.pop_at(-1)
    rest
  end

  def remove_header([_head | tail]), do: tail

  def process_float(binary) do
    binary
    |> String.replace(",", "")
    |> String.to_float()
  end

  def parse_line(line) do
    [date, reference, _, payment, total] = String.split(line, ~r{\t})
    %{
      date: date,
      reference: reference,
      payment: payment |> process_float,
      total: total |> process_float
    }
  end

  def parse(content) do
    content
    |> split_lines
    |> remove_header
    |> Enum.map(fn(line) -> parse_line(line) end)
  end

end
