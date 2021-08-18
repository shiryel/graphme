# Graphmex

Generates a relationship graph of your project modules using the DOT language

    mix graphme

## Command line options

  * `-f` `--filter` - One part of a module name, eg: from A.B.C you can filter the B [default: nil]
  * `-F` `--filter_at` - The index of a module name part, eg: from A.B.C you can use `1` to filter B [default: 0]
  * `-S` `--subgraph_at` - The index of a module name part that will be used to clusterize the graph [default: nil]
  * `-o` `--output` - The output file name [default: graph]
  * `-O` `--output_format` - The output file format, eg: svg, png [default: png]

## Examples
Filter the modules using the first (0) module name and output as "my_graph.svg"

    mix graphme -f "YourModulePart" -F 0 -S "AnotherModulePart" -o "my_graph" -O "svg"

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `graphmex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:graphmex, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/graphmex](https://hexdocs.pm/graphmex).
