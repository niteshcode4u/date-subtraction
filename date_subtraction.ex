defmodule DateSubtract do
  @doc """
    This module will give exactly earlier date you want from asking date. Eg:
    iex> DateSubtract.date_subtract("2018-05-28", 10)
      #Ecto.Date<2018-05-18>
    iex> DateSubtract.date_subtract("2018-05-28", 10) |> to_string()
      "2018-05-18"
    iex> DateSubtract.date_subtract("2018-05-28", 100) |> to_string()
      "2018-02-17"
  """
  def date_subtract(date, no_of_days, type \\ :date) do
    date = Helper.convert_date_to_datetime(date)
      if is_integer(no_of_days) do
        case Ecto.DateTime.cast(date) do
          {:ok, valid_date} ->
            {:ok, result} = valid_date |> Ecto.DateTime.to_erl |> Calendar.DateTime.from_erl!("Etc/UTC") |> Calendar.DateTime.subtract(no_of_days * 60 * 60 * 24)
            {:ok, final_date} = if type == :date do
              Ecto.Date.cast({result.year, result.month, result.day})
            else
              case Ecto.DateTime.cast({{result.year, result.month, result.day}, {result.hour, result.min, result.sec}}) do
                {:ok, date} -> {:ok, Ecto.DateTime.to_iso8601(date)}
                :error -> :error
              end
            end
            final_date
          _ ->
            :error
        end
      else
        :error
      end
  end
end
