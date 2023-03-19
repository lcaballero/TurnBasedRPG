package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.math.FlxVelocity;

using flixel.util.FlxSpriteUtil; // for isFlickering on Enemy

enum EnemyType
{
  REGULAR;
  BOSS;
}

class Enemy extends FlxSprite
{
  static inline var WALK_SPEED:Float = 40;
  static inline var CHASE_SPEED:Float = 70;

  public var type:EnemyType;
  var brain:FSM;
  var idleTimer:Float;
  var moveDirection:Float;
  public var seesPlayer:Bool;
  public var playerPosition:FlxPoint;

  public function new(x:Float, y:Float, type:EnemyType)
  {
    super(x, y);
    this.type = type;
    var graphic = if (type == BOSS) AssetPaths.boss__png else AssetPaths.enemy__png;
    loadGraphic(graphic, true, 16, 16);
    setFacingFlip(LEFT, false, false);
    setFacingFlip(RIGHT, true, false);
    animation.add("d_idle", [0]);
    animation.add("lr_idle", [3]);
    animation.add("u_idle", [6]);
    animation.add("d_walk", [0, 1, 0, 2], 6);
    animation.add("l_walk", [3, 4, 3, 5], 6);
    animation.add("r_walk", [3, 4, 3, 5], 6);
    animation.add("u_walk", [6, 7, 6, 8], 6);
    drag.x = drag.y = 10;
    setSize(8, 8);
    offset.x = 4;
    offset.y = 8;

    brain = new FSM(idle);
    idleTimer = 0;
    playerPosition = FlxPoint.get();
  }

  override public function update(elapsed:Float)
  {
    var _up:Int = 1;
    var _down:Int = 2;
    var _left:Int = 3;
    var _right:Int = 4;

    if (this.isFlickering()) {
      return;
    }

    if (velocity.x != 0 || velocity.y != 0) {
      if (Math.abs(velocity.x) > Math.abs(velocity.y)) {
        if (velocity.x < 0) {
          facing = _left;
        } else {
          facing = _right;
        }
      } else {
        if (velocity.y < 0) {
          facing = _up;
        } else {
          facing = _down;
        }
      }
    }
    var action:String = "";
    if (facing == _up) {
      action = "u_walk";
    } else if (facing == _down) {
      action = "d_walk";
    } else if (facing == _left) {
      action = "l_walk";
    } else if (facing == _right) {
      action = "r_walk";
    }
    animation.play(action);
    brain.update(elapsed);
    super.update(elapsed);
  }

  function idle(elapsed:Float)
  {
    if (seesPlayer) {
      brain.activeState = chase;
    } else if (idleTimer <= 0) {
      if (FlxG.random.bool(95)) {
        moveDirection = FlxG.random.int(0, 8) * 45;
        velocity.setPolarDegrees(WALK_SPEED, moveDirection);
      } else {
        moveDirection = -1;
        velocity.x = velocity.y = 0;
      }
      idleTimer = FlxG.random.int(1, 4);
    } else {
      idleTimer -= elapsed;
    }
  }

  function chase(elapsed:Float)
  {
    if (!seesPlayer) {
      brain.activeState = idle;
    } else {
      FlxVelocity.moveTowardsPoint(this, playerPosition, CHASE_SPEED);
    }
  }

  public function changeType(type:EnemyType)
  {
    if (this.type != type) {
      this.type = type;
      var graphic = if (type == BOSS) AssetPaths.boss__png else AssetPaths.enemy__png;
      loadGraphic(graphic, true, 16, 16);
    }
  }
}

