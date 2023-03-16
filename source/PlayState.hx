package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.tile.FlxTilemap;
import flixel.text.FlxText;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;

class PlayState extends FlxState
{
  var player:Player;
  var map:FlxOgmo3Loader;
  var walls:FlxTilemap;

  override public function create() {
    player = new Player();
    map = new FlxOgmo3Loader(AssetPaths.turnBasedRPG__ogmo, AssetPaths.room_001__json);
    walls = map.loadTilemap(AssetPaths.tiles__png, "walls");
    walls.follow();
    walls.setTileProperties(1, NONE);
    walls.setTileProperties(2, ANY);
    add(walls);
    add(player);
    map.loadEntities(placeEntities, "entities");
    FlxG.camera.follow(player, TOPDOWN, 1);
    super.create();
  }

  function placeEntities(entity:EntityData) {
    if (entity.name == "player") {
      player.setPosition(entity.x, entity.y);
    }
  }

  override public function update(elapsed:Float) {
    super.update(elapsed);
    FlxG.collide(walls, player);
  }
}
