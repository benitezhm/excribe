# Excribe

Excribe is a simple text formatting utility for Elixir.

Excribe helps you format the text in paragraph-like form. It supports word
wrapping, indentation and text alignment.

## Installation

This package is available in [Hex](https://hex.pm/packages/excribe). Simply add
`:excribe` to your list of deps in `mix.exs`.

```elixir
def deps do
  [{:excribe, git: "git@github.com:benitezhm/excribe.git"}]
end
```

## Examples

Read the [documentation](https://hexdocs.pm/excribe) for detailed explanation
of functions provided by Excribe.

### Simple Word Wrapping

```
# lipsum = "Lorem ipsum dolor ..."

iex> lipsum |> Excribe.format(width: 60) |> IO.puts
Lorem ipsum dolor sit amet, consectetur adipiscing elit.
Mauris id eleifend risus. Aenean ut vestibulum velit.
Pellentesque habitant morbi tristique senectus et netus et
malesuada fames ac turpis egestas. Maecenas a suscipit
purus, in tincidunt nisl. Proin dignissim ligula sit amet
felis ultricies, nec accumsan orci convallis.
:ok
```

### Indentation

```
iex> lipsum |> Excribe.format(width: 60, indent: 4, hanging: 8) |> IO.puts
    Lorem ipsum dolor sit amet, consectetur adipiscing elit.
        Mauris id eleifend risus. Aenean ut vestibulum
        velit. Pellentesque habitant morbi tristique
        senectus et netus et malesuada fames ac turpis
        egestas. Maecenas a suscipit purus, in tincidunt
        nisl. Proin dignissim ligula sit amet felis
        ultricies, nec accumsan orci convallis.
:ok
```

### Text Alignment

```
iex> lipsum |> Excribe.format(width: 60, align: :right) |> IO.puts
    Lorem ipsum dolor sit amet, consectetur adipiscing elit.
       Mauris id eleifend risus. Aenean ut vestibulum velit.
  Pellentesque habitant morbi tristique senectus et netus et
      malesuada fames ac turpis egestas. Maecenas a suscipit
   purus, in tincidunt nisl. Proin dignissim ligula sit amet
               felis ultricies, nec accumsan orci convallis.
:ok

iex> lipsum |> Excribe.format(width: 60, align: :justify) |> IO.puts
Lorem ipsum dolor sit  amet,  consectetur  adipiscing  elit.
Mauris  id  eleifend  risus.  Aenean  ut  vestibulum  velit.
Pellentesque habitant morbi tristique senectus et  netus  et
malesuada fames  ac  turpis  egestas.  Maecenas  a  suscipit
purus, in tincidunt nisl. Proin dignissim  ligula  sit  amet
felis ultricies, nec accumsan orci convallis.
:ok
```

## TODO

* Support multi-line texts
* Support `ansilist` (from `IO.ANSI`)

## LICENSE

Excribe is licensed under the terms of The MIT License. Check `LICENSE` file for
the full text of The MIT License.
