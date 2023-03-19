package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import flixel.text.FlxText;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.util.FlxSpriteUtil;

using flixel.util.FlxSpriteUtil;

class PlayState extends FlxState
{
  var player:Player;
  var map:FlxOgmo3Loader;
  var walls:FlxTilemap;
  var coins:FlxTypedGroup<Coin>;
  var enemies:FlxTypedGroup<Enemy>;
  var hud:HUD;
  var money:Int = 0;
  var health:Int = 3;
  var inCombat:Bool = false;
  var combatHud:CombatHUD;

  override public function create() {
    player = new Player();
    map = new FlxOgmo3Loader(AssetPaths.turnBasedRPG__ogmo, AssetPaths.room_001__json);
    walls = map.loadTilemap(AssetPaths.tiles__png, "walls");
    walls.follow();
    walls.setTileProperties(1, NONE);
    walls.setTileProperties(2, ANY);
    add(walls);
    add(player);
    coins = new FlxTypedGroup<Coin>();
    add(coins);
    enemies = new FlxTypedGroup<Enemy>();
    add(enemies);
    hud = new HUD();
    add(hud);
    combatHud = new CombatHUD();
    add(combatHud);
    map.loadEntities(placeEntities, "entities");
    FlxG.camera.follow(player, TOPDOWN, 1);
    super.create();
  }

  function placeEntities(entity:EntityData) {
    if (entity.name == "player") {
      player.setPosition(entity.x, entity.y);
    } else if (entity.name == "coin") {
      coins.add(new Coin(entity.x + 4, entity.y + 4));
    } else if (entity.name == "enemy") {
      enemies.add(new Enemy(entity.x + 4, entity.y, REGULAR));
    } else if (entity.name == "boss") {
      enemies.add(new Enemy(entity.x + 4, entity.y, BOSS));
    }
  }

  override public function update(elapsed:Float) {
    super.update(elapsed);
    if (inCombat) {
      if (!combatHud.visible) {
        health = combatHud.playerHealth;
        hud.updateHUD(health, money);
        if (combatHud.outcome == VICTORY) {
          combatHud.enemy.kill();
        } else {
          combatHud.enemy.flicker();
        }
        inCombat = false;
        player.active = true;
        enemies.active = true;
      }
    } else {
      FlxG.collide(player, walls);
      FlxG.overlap(player, coins, playerTouchCoin);
      FlxG.collide(enemies, walls);
      enemies.forEachAlive(checkEnemyVision);
      FlxG.overlap(player, enemies, playerTouchEnemy);
    }
  }

  function checkEnemyVision(enemy:Enemy)
  {
    if (walls.ray(enemy.getMidpoint(), player.getMidpoint())) {
      enemy.seesPlayer = true;
      enemy.playerPosition = player.getMidpoint();
    } else {
      enemy.seesPlayer = false;
    }
  }

  function playerTouchCoin(player:Player, coin:Coin) {
    if (player.alive && player.exists && coin.alive && coin.exists) {
      coin.kill();
      money++;
      hud.updateHUD(health, money);
    }
  }

  function playerTouchEnemy(player:Player, enemy:Enemy)
  {
    if (player.alive && player.exists && enemy.alive && enemy.exists && !enemy.isFlickering()) {
      startCombat(enemy);
    }
  }

  function startCombat(enemy:Enemy)
  {
    inCombat = true;
    player.active = false;
    enemies.active = false;
    combatHud.initCombat(health, enemy);
  }
}
