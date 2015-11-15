Path.expand(__DIR__)
|> Path.join("fixtures/**/*.exs")
|> Path.wildcard
|> Enum.each(&Code.require_file/1)

Code.require_file(Path.expand(Path.join(__DIR__, "test_utils/test_utils.exs")))

ExUnit.start()
