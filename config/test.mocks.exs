use Mix.Config

config :ants, :worlds, Ants.WorldsMock
config :ants, :tile_supervisor, Ants.Worlds.TileSupervisorMock
config :ants, :tile_lookup, Ants.Worlds.TileLookupMock
