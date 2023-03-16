package;

import flixel.FlxSprite;
import flixel.FlxG;

class Player extends FlxSprite
{
  static inline var SPEED:Float = 50;
  var up:Bool = false;
  var down:Bool = false;
  var left:Bool = false;
  var right:Bool = false;

  public function new(x:Float = 0, y:Float = 0) {
    super(x,y);
    drag.x = drag.y = 800;
    setSize(6, 6);
    offset.set(4, 4);
    loadGraphic(AssetPaths.player__png, true, 16, 16);
    setFacingFlip(LEFT, false, false);
    setFacingFlip(RIGHT, true, false);
    animation.add("d_idle", [0]);
    animation.add("l_idle", [3]);
    animation.add("r_idle", [3]);
    animation.add("u_idle", [6]);
    animation.add("d_walk", [0, 1, 0, 2], 6, true, false);
    animation.add("r_walk", [3, 4, 3, 5], 6, true, true);
    animation.add("l_walk", [3, 4, 3, 5], 6, true, false);
    animation.add("u_walk", [6, 7, 6, 8], 6, true, false);
  }

  public function updateMovement() {
    up = FlxG.keys.anyPressed([UP, I]);
    down = FlxG.keys.anyPressed([DOWN, K]);
    left = FlxG.keys.anyPressed([LEFT, J]);
    right = FlxG.keys.anyPressed([RIGHT, L]);
    if (up && down) {
      up = down = false;
    }
    if (left && right) {
      left = right = false;
    }
    trace("up: " + up + " down: " + down + " left: " + left + " right: " + right);
    var dir:Bool = up || down || left || right;
    if (!dir) {
      return;
    }

    var angle:Float = 60;
    var facing:Int = 0;
    var _up:Int = 1;
    var _down:Int = 2;
    var _left:Int = 3;
    var _right:Int = 4;

    if (left) {
      angle = 180;
      facing = _left;
    }
    if (right) {
      angle = 0;
      facing = _right;
    }
    if (up) {
      angle = -90;
      if (left) {
        angle -= 30;
      }
      if (right) {
        angle += 30;
      }
      facing = _up;
    }
    if (down) {
      angle = 90;
      if (left) {
        angle += 30;
      }
      if (right) {
        angle -= 30;
      }
      facing = _down;
    }
    velocity.setPolarDegrees(SPEED, angle);

    var action = "idle";
    if ((velocity.x != 0 || velocity.y != 0) && touching == NONE) {
      action = "walk";
    }
    if (facing == _left) {
      animation.play("l_" + action);
    }
    if (facing == _right) {
      animation.play("r_" + action);
    }
    if (facing == _up) {
      animation.play("u_" + action);
    }
    if (facing == _down) {
      animation.play("d_" + action);
    }
  }

  override function update(elapsed:Float) {
    updateMovement();
    super.update(elapsed);
  }
}
