defmodule Excribe.Mixfile do
  use Mix.Project

  def project do
    [app: :excribe,
     description: "Simple text formatting utility for Elixir.",
     package: package(),
     version: "0.1.1",
     elixir: "~> 1.4",
     name: "Excribe",
     source_url: "https://github.com/Dalgona/excribe",
     docs: [main: "Excribe"],
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def package do
    [name: :excribe,
     licenses: ["MIT"],
     maintainers: ["dalgona@hontou.moe"],
     links: %{"GitHub" => "https://github.com/Dalgona/excribe"}]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [{:ex_doc, "~> 0.16.2", only: :dev, runtime: false}]
  end
end
