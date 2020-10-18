defmodule Ing2ynab do
  @moduledoc """
  A simple converter from ING Bank CSV's to YNAB CSV's
  """

  NimbleCSV.define(CSV_in, separator: ";")
  alias NimbleCSV.RFC4180, as: CSV_out

  defp header() do
    ~w(Date Payee Memo Amount)
  end

  def main(args) do
    options = [switches: [file: :string], aliases: [f: :file]]
    {opts, _, _} = OptionParser.parse(args, options)
    run(opts)
  end

  defp run(file: file) do
    file
    |> File.stream!()
    |> CSV_in.parse_stream()
    |> Stream.map(&convert_ing_line/1)
    |> Stream.transform(:header, fn row, location ->
      if location == :header, do: {[header(), row], :row}, else: {[row], location}
    end)
    |> CSV_out.dump_to_stream()
    |> Stream.into(File.stream!("ynab.csv"))
    |> Stream.run()
  end

  defp convert_ing_line([
         date,
         name,
         _account,
         _counterparty,
         _code,
         debit_credit,
         amount,
         transaction_type,
         notifications,
         _new_balance,
         _tag
       ]) do
    [
      map_date(date),
      name,
      "#{transaction_type} - #{notifications}",
      map_amount(debit_credit, amount)
    ]
  end

  defp map_date(date) do
    date
    |> Timex.parse!("{YYYY}{0M}{0D}")
    |> Timex.format!("{0D}/{0M}/{YYYY}")
  end

  defp map_amount("Af", amount) do
    "-#{amount}"
    |> String.replace(",", ".")
  end

  defp map_amount("Bij", amount) do
    amount
    |> String.replace(",", ".")
  end
end
