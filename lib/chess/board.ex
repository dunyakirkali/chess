defmodule Chess.Board do
  defstruct grid: %{}

  def new do
    %Chess.Board{}
    |> setup(:black)
    |> setup(:white)
  end

  def new(grid) do
    %Chess.Board{grid: grid}
  end

  defp setup(%Chess.Board{grid: grid}, :black) do
    grid =
      grid
      |> Map.put({0, 0}, "♜")
      |> Map.put({1, 0}, "♞")
      |> Map.put({2, 0}, "♝")
      |> Map.put({3, 0}, "♛")
      |> Map.put({4, 0}, "♚")
      |> Map.put({5, 0}, "♝")
      |> Map.put({6, 0}, "♞")
      |> Map.put({7, 0}, "♜")
      |> Map.put({0, 1}, "♟︎")
      |> Map.put({1, 1}, "♟︎")
      |> Map.put({2, 1}, "♟︎")
      |> Map.put({3, 1}, "♟︎")
      |> Map.put({4, 1}, "♟︎")
      |> Map.put({5, 1}, "♟︎")
      |> Map.put({6, 1}, "♟︎")
      |> Map.put({7, 1}, "♟︎")

    %Chess.Board{grid: grid}
  end

  defp setup(%Chess.Board{grid: grid}, :white) do
    grid =
      grid
      |> Map.put({0, 7}, "♖")
      |> Map.put({1, 7}, "︎♘")
      |> Map.put({2, 7}, "︎♗")
      |> Map.put({3, 7}, "︎♕")
      |> Map.put({4, 7}, "︎♔")
      |> Map.put({5, 7}, "︎♗")
      |> Map.put({6, 7}, "︎♘")
      |> Map.put({7, 7}, "♖︎")
      |> Map.put({0, 6}, "♙︎")
      |> Map.put({1, 6}, "♙︎")
      |> Map.put({2, 6}, "♙︎")
      |> Map.put({3, 6}, "♙︎")
      |> Map.put({4, 6}, "♙︎")
      |> Map.put({5, 6}, "♙︎")
      |> Map.put({6, 6}, "♙︎")
      |> Map.put({7, 6}, "♙︎")

    %Chess.Board{grid: grid}
  end
end

defmodule Chess.Board.Sigils do
  defmacro sigil_B({:<<>>, _, [grid]}, []) do
    grid
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {cols, row}, acc ->
      cols
      |> String.split(" ")
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {cell, col}, acc ->
        piece = String.replace(cell, ~r/(\[|\])/, "")
        case piece do
          "" -> acc
          _  -> Map.put(acc, {col, row}, piece)
        end
      end)
    end)
    |> Chess.Board.new()
    |> Macro.escape()
  end
end

defimpl Inspect, for: Chess.Board do
  import Inspect.Algebra

  def inspect(%Chess.Board{grid: grid}, _opts) do
    contents =
      for row <- 0..7 do
        for col <- 0..7 do
          {col, row}
          |> square_color()
          |> color(Map.get(grid, {col, row}, " "))
        end
        |> IO.iodata_to_binary()
      end
      |> Enum.intersperse(line())
      |> concat()

    concat([
      line(),
      contents,
      line()
    ])
  end

  defp color(color, string) do
    [:white, color, string]
    |> IO.ANSI.format()
    |> IO.iodata_to_binary()
  end

  defp square_color({x, y}) do
    case rem(x + y, 2) do
      0 -> :light_white_background
      1 -> :light_black_background
    end
  end
end
