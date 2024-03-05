defmodule Excribe do
  @moduledoc """
  Excribe - A simple text formatting utility for Elixir.

  Excribe helps you format the text in paragraph-like form. It supports word
  wrapping, indentation and text alignment.
  """

  @type options :: %{
    width: pos_integer,
    indent: non_neg_integer,
    hanging: non_neg_integer,
    align: align_option
  }

  @type align_option :: :left | :right | :center | :justify

  @doc """
  Formats the text with given options.

  It takes a string and a map containing valid options, transforms the given
  string according to the options, and returns a new string.

  **NOTE 1:** You may get an unintended result if the original string contains
  non-latin characters, such as CJK characters and emojis, as they usually
  occupy two character cells.

  **NOTE 2:** You may also get an unintended result if the original string
  contains ANSI escape characters (color, intensity, etc.). Support for ANSI
  strings will be added in future releases, with the help of `IO.ANSI` module.

  ## Options

  * `:width` - Sets the maximum number of characters per line, including
    indentations.
  * `:align` - See the "Text Alignment" section below.
  * `:indent` and `:hanging` - See the "Indentation" section below.

  The default option object is
  `%{width: 80, align: :left, indent: 0, hanging: 0}`.

  ## Text Alignment

  Excribe supports four text alignment options:

  * `:left` - Aligns the text to the left. Only one space is inserted between
    words, resulting in jagged right edge.
  * `:right` - Aligns the text to the right. Only one space is inserted between
    words.
  * `:center` - Centers the text. Only one space is inserted between words.
  * `:justify` - Similar to `:left`, but one or more spaces may be placed
    between words so that each line has equal width (except the last line).

  ## Indentation

  You can specify two indentation options. These options are only valid when
  `:align` is set to `:left` or `:justify`. Otherwise, they are ignored and set
  to zeros.

  * `indent`: Sets the number of spaces inserted at the beginning of the first
    line.
  * `hanging`: Sets the number of spaces inserted at the beginning of all lines
    except the first line. This value is relative to the left end of the screen.
  """

  @spec format(binary, options) :: binary

  def format(str, opts \\ %{})

  def format(str, opts) do
    width = opts[:width] || 80
    align = opts[:align] || :left
    indent = (align in [:left, :justify]) && opts[:indent] || 0
    hanging = (align in [:left, :justify]) && opts[:hanging] || 0
    opts = %{width: width, align: align, indent: indent, hanging: hanging}
    str
    |> String.split(~r/\s+/, trim: true)
    |> make_paragraph(opts)
    |> render_lines(opts)
    |> Enum.join("\n")
  end

  #
  # PRIVATE FUNCTIONS
  #

  @spec make_paragraph([binary], options, [binary]) :: [[binary]]

  defp make_paragraph(words, opts, acc \\ [])

  defp make_paragraph([], _opts, acc) do
    Enum.reverse acc
  end

  defp make_paragraph(words, opts, acc) do
    width = opts.width - if acc == [], do: opts.indent, else: opts.hanging
    {line, rest} = make_line words, width
    make_paragraph rest, opts, [line|acc]
  end

  @spec make_line([binary], non_neg_integer, [binary]) :: {[binary], [binary]}

  defp make_line(words, width, acc \\ [])

  defp make_line([], _width, acc) do
    {Enum.reverse(acc), []}
  end

  defp make_line([word|rest], width, acc) do
    word_len = String.length word
    cond do
      acc == [] and word_len > width ->
        {[word], rest}
      word_len > width ->
        {Enum.reverse(acc), [word|rest]}
      :otherwise ->
        make_line rest, width - word_len - 1, [word|acc]
    end
  end

  @spec render_lines([[binary]], options, [binary]) :: :any # TODO

  defp render_lines(lines, opts, acc \\ [])

  defp render_lines([], _opts, acc) do
    Enum.reverse acc
  end

  defp render_lines([line|rest], opts, acc) do
    first? = acc == []
    last? = rest == []
    render_lines rest, opts, [render_line(line, opts, first?, last?)|acc]
  end

  @spec render_line([binary], options, boolean, boolean) :: binary

  defp render_line(line, opts, first_line?, last_line?)

  defp render_line(line, %{align: :left} = opts, first_line?, _) do
    n = first_line? && opts.indent || opts.hanging
    leading = String.duplicate " ", n
    leading <> Enum.join(line, " ")
  end

  defp render_line(line, %{align: :right} = opts, _, _) do
    joined = Enum.join line, " "
    String.pad_leading joined, opts.width, " "
  end

  defp render_line(line, %{align: :center} = opts, _, _) do
    joined = Enum.join line, " "
    len = div opts.width - String.length(joined), 2
    String.pad_leading joined, opts.width - len, " "
  end

  defp render_line(line, %{align: :justify} = opts, first_line?, false) do
    n = first_line? && opts.indent || opts.hanging
    leading = String.duplicate " ", n
    nfree = opts.width - n - Enum.reduce(line, 0, & &2 + String.length(&1))
    nspaces = Enum.count(line) - 1
    {min_space, remainder} =
      if nspaces == 0,
        do: {0, 0},
        else: {div(nfree, nspaces), rem(nfree, nspaces)}
    sp1 = String.duplicate " ", min_space
    sp2 = sp1 <> " "
    sp1_list = List.duplicate sp1, nspaces - remainder
    sp2_list = List.duplicate sp2, remainder
    spaces = sp1_list ++ sp2_list ++ [""]
    joined =
      [line, spaces]
      |> Enum.zip
      |> Enum.map(fn {x, y} -> x <> y end)
      |> Enum.join
    leading <> joined
  end

  defp render_line(line, %{align: :justify} = opts, _, true) do
    render_line line, %{opts|align: :left}, false, false
  end
end
