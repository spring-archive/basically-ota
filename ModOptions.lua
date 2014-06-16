--  Custom Options Definition Table format

--  NOTES:
--  - using an enumerated table lets you specify the options order

--
--  These keywords must be lowercase for LuaParser to read them.
--
--  key:      the string used in the script.txt
--  name:     the displayed name
--  desc:     the description (could be used as a tooltip)
--  type:     the option type
--  def:      the default value
--  min:      minimum value for number options
--  max:      maximum value for number options
--  step:     quantization step, aligned to the def value
--  maxlen:   the maximum string length for string options
--  items:    array of item strings for list options
--  scope:    'global', 'player', 'team', 'allyteam'
--

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


local options =
{
	{
    key    = 'botagame',
    name   = 'Main options',
    desc   = 'Main game options',
    type   = 'section',
	},

	{
		key="gamemode",
		name="Game End Mode",
		desc="What it takes to eliminate a player or team\nkey: mode",
		type="list",
		section= 'botagame',
		def=2,
		items={
			{key="commander", name="Commander Ends", desc="Player will die if commander is killed"},
			{key="comends", name="Team Commander Ends", desc="Team will die if commanders of all players are killed."},
			{key="killall", name="Kill all enemy players", desc="Kill all enemies. Player will die if they have no units left."},
			{key="team", name="Kill all enemy units", desc="Kill all enemies. Dead players are retained until whole team dies"},
		},
	},

  {
    key    = 'StartingResources',
    name   = 'Starting Resources',
    desc   = 'Sets storage and amount of resources that players will start with',
    type   = 'section',
  },

  {
		key		= "debugmode",
		name	= "Debug Mode",
		desc	= "Enable debugging mode. Will allow /cheat by default, and load gadget profiler.\nkey: debugmode",
		type	= "bool",
		section	= 'botagame',
		def		= false,
	},
  
  {
    key    = 'StartMetal',
    name   = 'Starting metal',
    desc   = 'Determines amount of metal and metal storage that each player will start with',
    type   = 'number',
    section= 'StartingResources',
    def    = 1000,
    min    = 0,
    max    = 10000,
    step   = 1,  -- quantization is aligned to the def value
                    -- (step <= 0) means that there is no quantization
  },
  {
   key    = 'StartMetal',
   scope  = 'team',
   name   = 'Team Starting metal',
   desc   = 'Determines amount of metal and metal storage this team will start with',
   type   = 'number',
   section= 'StartingResources',
   def    = 1000,
   min    = 0,
   max    = 10000,
   step   = 1,  -- quantization is aligned to the def value
   -- (step <= 0) means that there is no quantization
  },
  {
    key    = 'StartEnergy',
    name   = 'Starting energy',
    desc   = 'Determines amount of energy and energy storage that each player will start with',
    type   = 'number',
    section= 'StartingResources',
    def    = 1000,
    min    = 0,
    max    = 10000,
    step   = 1,  -- quantization is aligned to the def value
                    -- (step <= 0) means that there is no quantization
  },
  {
   key    = 'StartEnergy',
   scope  = 'team',
   name   = 'Team Starting energy',
   desc   = 'Determines amount of energy and energy storage that this team will start with',
   type   = 'number',
   section= 'StartingResources',
   def    = 1000,
   min    = 0,
   max    = 10000,
   step   = 1,  -- quantization is aligned to the def value
   -- (step <= 0) means that there is no quantization
  },

  {
    key    = 'MaxUnits',
    name   = 'Max units',
    desc   = 'Maximum number of units (including buildings) for each team allowed at the same time',
    type   = 'number',
    def    = 1000,
    min    = 1,
    max    = 10000, --- engine caps at lower limit if more than 3 team are ingame
    step   = 1,  -- quantization is aligned to the def value
                    -- (step <= 0) means that there is no quantization
  },

  {
    key    = 'LimitDgun',
    name   = 'Limit D-Gun range',
    desc   = "The commander's D-Gun weapon will be usable only close to the player's starting location",
    type   = 'bool',
    def    = false,
  },

  {
    key    = 'GhostedBuildings',
    name   = 'Ghosted buildings',
    desc   = "Once an enemy building will be spotted\na ghost trail will be placed to memorize location even after the loss of the line of sight",
    type   = 'bool',
    def    = true,
  },
  {
    key    = 'DiminishingMMs',
    name   = 'Diminishing metal makers efficiency',
    desc   = "Everytime a new metal maker will be built, the energy/metal efficiency ratio will decrease",
    type   = 'bool',
    def    = false,
  },

  {
    key    = 'FixedAllies',
    name   = 'Fixed ingame alliances',
    desc   = 'Disables the possibility of players to dynamically change alliances ingame',
    type   = 'bool',
    def    = false,
  },

  {
    key    = 'LimitSpeed',
    name   = 'Speed Restriction',
    desc   = 'Limits maximum and minimum speed that the players will be allowed to change to',
    type   = 'section',
  },

  {
    key    = 'MaxSpeed',
    name   = 'Maximum game speed',
    desc   = 'Sets the maximum speed that the players will be allowed to change to',
    type   = 'number',
    section= 'LimitSpeed',
    def    = 3,
    min    = 0.1,
    max    = 100,
    step   = 0.1,  -- quantization is aligned to the def value
                    -- (step <= 0) means that there is no quantization
  },

  {
    key    = 'MinSpeed',
    name   = 'Minimum game speed',
    desc   = 'Sets the minimum speed that the players will be allowed to change to',
    type   = 'number',
    section= 'LimitSpeed',
    def    = 0.3,
    min    = 0.1,
    max    = 100,
    step   = 0.1,  -- quantization is aligned to the def value
                    -- (step <= 0) means that there is no quantization
  },

  {
    key    = 'DisableMapDamage',
    name   = 'Undeformable map',
    desc   = 'Prevents the map shape from being changed by weapons',
    type   = 'bool',
    def    = false,
  },

}

return options
