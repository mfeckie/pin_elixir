Path.expand(__DIR__)
|> Path.join("fixtures/**/*.exs")
|> Path.wildcard
|> Enum.each(&Code.require_file/1)

ExUnit.start()
