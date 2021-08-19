# Graphme

Generates a relationship graph of your project modules using the DOT language

## How to run

You need the following deps installed on your system:
* elixir
* dot (graphviz)

Now you can run:
```bash
  mix graphme
```

## Installation

The package can be installed by adding `graphme` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:graphme, "~> 0.1.0", only: :dev, runtime: false}
  ]
end
```

The docs can be found at [https://hexdocs.pm/graphme](https://hexdocs.pm/graphme).

## Command line options

  * `-f` `--filter` - One part of a module name, eg: from A.B.C you can filter the B [default: nil]
  * `-F` `--filter_at` - The index of a module name part, eg: from A.B.C you can use `1` to filter B [default: 0]
  * `-S` `--subgraph_at` - The index of a module name part that will be used to clusterize the graph [default: nil]
  * `-o` `--output` - The output file name [default: graph]
  * `-O` `--output_format` - The output file format, eg: svg, png [default: png]

## Examples
Filter the modules using the first (0) module name and output as "my_graph.svg"

    mix graphme -f "YourModulePart" -F 0 -S "AnotherModulePart" -o "my_graph" -O "svg"

## License

   Copyright 2021 Shiryel

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
