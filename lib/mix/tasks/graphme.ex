defmodule Mix.Tasks.Graphme do
  @moduledoc """
    Generates a relationship graph of your modules using the DOT language

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
  """
  @shortdoc "Generates a relationship graph of your modules"

  use Mix.Task

  alias Mix.Tasks.Xref

  @joiner "\n"

  @impl true
  def run(params) do
    # OPTIONS
    {options, _, _} =
      OptionParser.parse(params,
        aliases: [f: :filter, F: :filter_at, S: :subgraph_at, o: :output, O: :output_format],
        strict: [
          filter: :string,
          filter_at: :integer,
          subgraph_at: :integer,
          output: :string,
          output_format: :string
        ]
      )

    filter = Keyword.get(options, :filter, nil)
    filter_at = Keyword.get(options, :filter_at, 0)
    subgraph_at = Keyword.get(options, :subgraph_at, nil)
    out = Keyword.get(options, :output, "graph")
    format = Keyword.get(options, :output_format, "png")

    # MODULES
    {:ok, mods} = :application.get_key(:izacore, :modules)
    mods = (not is_nil(filter) && filter_mods(mods, filter, filter_at)) || mods
    # relations, we get those outside because its very slow
    calls = Xref.calls()

    # GRAPHS
    subgraphs = (subgraph_at && subgraphs(mods, subgraph_at)) || []

    mods
    |> Enum.map(&{&1, find_caller_modules(&1, calls)})
    |> Enum.map(&stringfy/1)
    |> List.flatten()
    |> print(subgraphs, out)

    # DOT COMMANDS
    System.cmd("dot", ["-T#{format}", "#{out}.gv", "-o", "#{out}.#{format}"])
  end

  defp find_caller_modules(module, calls) do
    calls
    |> Enum.filter(&(elem(&1.callee, 0) == module))
    |> Enum.map(& &1.caller_module)
  end

  defp filter_mods(mods, filter, at) do
    Enum.map(mods, &Module.split/1)
    |> Enum.filter(&(Enum.at(&1, at) == filter))
    |> Enum.map(&Module.concat/1)
  end

  # Parse Relations

  defp stringfy({caller, callees}) do
    Enum.map(callees, fn x ->
      ~s|"#{stringfy_module(x)}" -> "#{stringfy_module(caller)}"|
    end)
    |> Enum.dedup()
  end

  defp stringfy_module(module) do
    Module.split(module)
    |> Enum.join(@joiner)
  end

  # Parse Clusters

  defp subgraphs(mods, deph) do
    mods
    |> Enum.map(&Module.split/1)
    |> Enum.map(&List.pop_at(&1, deph))
    |> Enum.chunk_by(&elem(&1, 0))
    |> Enum.reject(&Enum.any?(&1, fn x -> elem(x, 0) == nil end))
    |> Enum.map(fn x ->
      result =
        Enum.map(x, fn {first, list} ->
          List.insert_at(list, deph, first)
        end)

      if length(x) > 1 do
        names =
          Enum.map(result, &Enum.join(&1, @joiner))
          |> Enum.join(~s|" "|)

        """
          subgraph "cluster_#{List.first(x) |> elem(0)}" {
            "#{names}"
          }
        """

        # the sub-subgraphs usualy dont end good
        # but you can test with:
        # {subgraphs(mods, deph + 1)}
      else
        ""
      end
    end)
  end

  # Print to file

  defp print(lines, subgraphs, out) do
    body = Enum.join(lines, "\n  ")

    graph = """
    digraph G{
      rankdir=LR
      graph [splines=true overlap=false model="subset" mindist=2 style=dotted];
      node [shape=ellipse];
      nodesep=0.7

      #{subgraphs}

      #{body}
    }
    """

    File.write("#{out}.gv", graph)
  end
end
