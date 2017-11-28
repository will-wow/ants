alias Ants.Worlds
alias Ants.WorldsMock

alias Ants.Worlds.TileSupervisor
alias Ants.Worlds.TileSupervisorMock

alias Ants.Worlds.TileLookup
alias Ants.Worlds.TileLookupMock

Mox.defmock(WorldsMock, for: Worlds)
Mox.defmock(TileLookupMock, for: TileLookup)
Mox.defmock(TileSupervisorMock, for: TileSupervisor)
