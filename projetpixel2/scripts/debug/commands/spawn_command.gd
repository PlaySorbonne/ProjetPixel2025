extends Command
class_name SpawnCommand

var logger: CommandsLogger

func _init(logger: CommandsLogger):
	var enemies_types: Array = WaveManager.EnemyTypes.keys()
	super("spawn", [
		PositiveIntArgumentType.new(),
		EnumArgumentType.new(enemies_types),
	])
	self.logger = logger
	self.infos = {
		"usage": "spawn <spawner_id> <mob_name>",
		"description": "Fait apparaitre un mob sur le spawner voulu."
	}

func execute(arguments: Array):
	if arguments[1] == "":
		logger.print("Erreur : le mob n'existe pas.", CommandsLogger.log_types.ERROR)
		return
	if GV.spawners == []:
		logger.print("Erreur : impossible de trouver un spawner.", CommandsLogger.log_types.ERROR)
		return
	if len(GV.spawners) <= arguments[0]:
		logger.print("Erreur : le spawner n'existe pas.", CommandsLogger.log_types.ERROR)
		return
	var spawner: EnemySpawner = GV.spawners[0]
	var ennemies: Array[BaseEnemy] = [WaveManager.ENEMY_RES[WaveManager.EnemyTypes.get(arguments[1])].instantiate()]
	spawner.spawn_wave(ennemies)
