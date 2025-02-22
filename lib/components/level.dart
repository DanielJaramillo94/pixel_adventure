import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:pixel_adventure/components/player.dart';

class Level extends World {
  Level({
    required this.levelName,
    required this.player,
  });
  final Player player;
  String levelName;
  late TiledComponent level;

  @override
  Future<void> onLoad() async {
    level = await TiledComponent.load('$levelName.tmx', Vector2.all(16));
    add(level);
    final spawnPointLayer = level.tileMap.getLayer<ObjectGroup>('SpawnPoints');

    for (final spawnPoint in spawnPointLayer!.objects) {
      switch (spawnPoint.class_) {
        case 'Player':
          player.position = Vector2(spawnPoint.x, spawnPoint.y);
          add(player);
          break;
        default:
          break;
      }
    }

    return super.onLoad();
  }
}
