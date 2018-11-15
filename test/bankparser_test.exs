defmodule BankparserTest do
  use ExUnit.Case
  doctest Bankparser

  test "line should be parse to a map" do
    line = "01-04-2018	SPEI RECIBIDOBANAMEX/0005323846  002 0000001  		224.57	88,661.03"
    assert Bankparser.parse_line(line) == %{
      date: "01-04-2018",
      reference: "SPEI RECIBIDOBANAMEX/0005323846  002 0000001  ",
      payment: 224.57,
      total: 88661.03
    }
  end

  test "test float transformation" do
    assert Bankparser.process_float("22.4") == 22.4
  end

  test "split lines of file" do
    case File.read("test/files/bank_file.exp") do
      {:ok, content} ->
        assert Bankparser.split_lines(content) == [
          "D�a	Concepto / Referencia	cargo	Abono	Saldo",
          "01-04-2018	SPEI RECIBIDOBANAMEX/0005323846  002 0000001		224.57	88,661.03",
          "02-04-2018	SPEI RECIBIDOBANAMEX/0005315417  002 0000001 		83.52	88,436.46"
        ]
      {:error, _reason} ->
        assert false
    end
  end

  test "remove first line" do
    case File.read("test/files/bank_file.exp") do
      {:ok, content} ->
        list = Bankparser.split_lines(content)
        assert Bankparser.remove_header(list) == [
          "01-04-2018	SPEI RECIBIDOBANAMEX/0005323846  002 0000001		224.57	88,661.03",
          "02-04-2018	SPEI RECIBIDOBANAMEX/0005315417  002 0000001 		83.52	88,436.46"
        ]
      {:error, _reason} ->
        assert false
    end
  end

end
