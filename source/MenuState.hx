package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

class MenuState extends FlxState
{
  var playButton:FlxButton;

  override public function create()
  {
    super.create();
    bgColor = FlxColor.WHITE;
    playButton = new FlxButton(0, 0, "Play", clickPlay);
    playButton.screenCenter();
    add(playButton);
  }

  function clickPlay() {
    FlxG.switchState(new PlayState());
  }
}
