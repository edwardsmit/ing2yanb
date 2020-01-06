use Mix.Config

config :tzdata, :autoupdate, :disabled
config :tzdata, :data_dir, Path.expand("./.tzdata")
