// --
// main class

// compile
// go to out folder and type:
// gcc -o main main.c -I ./ /usr/lib/sdl.hdll /usr/lib/ui.hdll /usr/lib/fmt.hdll /usr/lib/openal.hdll /usr/lib/ui.hdll /usr/lib/uv.hdll -lhl -lSDL2 -lm -lopenal -lGL
// reference: https://github.com/HaxeFoundation/hashlink/issues/124


// key
import hxd.Key in K;


class Main extends hxd.App
{
  /**
  Main function
  **/

  // members
  var animal : Animal;
  var bmp : h2d.Bitmap;
  var fps : h2d.Text;
  var sprite : h2d.Anim;
  var time : Float = 0.0;
  var anim_obj : h2d.Object;


  static function main()
  {
    /**
    main function call
    **/

    hxd.Res.initEmbed();
    new Main();
  }


  override private function init():Void
  {
    /**
    init function
    **/

    // parent init
    super.init();

    // font
    var ft = hxd.res.DefaultFont.get();
    ft.resizeTo(20);

    // write hello world
    var tf = new h2d.Text(ft, s2d);
    tf.text = 'hello world';

    // fps text
    fps = new h2d.Text(hxd.res.DefaultFont.get(), s2d);
    fps.x = s2d.width - 200;
    fps.y = 50;
    fps.text = 'fps: []';

    // create animal
    animal = new Animal('alfred');

    // display name
    animal.display_name(s2d);

    // add objects
    var obj = new h2d.Object();
    s2d.addChild(obj);

    obj.x = 100;
    obj.y = 100;
    obj.rotation = Math.PI / 4;

    // image
    //var img_tile = h2d.Tile.fromColor(0xFF0000, 32, 32);
    var img_tile = hxd.Res.img.shovelnaut_spritesheet.toTile();
    img_tile = img_tile.center();

    // bitmap
    bmp = new h2d.Bitmap(img_tile, s2d);
    bmp.scale(2);

    // position
    bmp.x = s2d.width / 2;
    bmp.y = s2d.height / 2;

    // trace
    trace("bitmap type: ", bmp);
    trace(floatToStringDecimal(0.1, 10));

    // animations
    animations();

    // tile groups
    var tile_group = new h2d.TileGroup(img_tile, s2d);

    // front tiles
    var front_tiles = [for (i in 0...4) img_tile.sub(i * 16, 0, 16, 16)];

    anim_obj = new h2d.Object(s2d);

    // front tile anim
    var sprite = new h2d.Anim(front_tiles, anim_obj);
    sprite.scale(3);
    sprite.x = 100;
    sprite.y = 50;
    sprite.speed = 5;
    trace("sprite: ", sprite);

    // events
    var interaction = new h2d.Interactive(16, 16, sprite);
    interaction.onOver = function(event : hxd.Event) { sprite.alpha = 0.5; }
    interaction.onOut = function(event : hxd.Event) { sprite.alpha = 1.0; }
    interaction.onPush = function(event : hxd.Event) { trace("push"); }
    interaction.onClick = function(event : hxd.Event) { trace("click"); }
    interaction.onRelease = function(event : hxd.Event) { trace("release"); }

    // global event
    hxd.Window.getInstance().addEventTarget(onEvent);    
  }


  // global event handling
  function onEvent(event : hxd.Event) 
  { 
    trace("event: " + event.toString()); 
    switch(event.kind)
    {
      case EKeyDown: trace("down");
      case EKeyUp: trace("up");
      case _:
    }
  }


  public function animations()
  {
    /**
    play with animations
    **/

    // animation
    var anim = new h2d.Anim([h2d.Tile.fromColor(0xFF0000, 30, 30), h2d.Tile.fromColor(0x00FF00, 30, 30), h2d.Tile.fromColor(0x0000FF, 30, 30)], s2d);
    anim.speed = 1;
    anim.x = 400;
    anim.onAnimEnd = function(){ trace("end of anim"); }
  }


  public function eval_scene()
  {
    /**
    scenes
    **/

    // create scene
    var scene_test = new h2d.Scene();

    // display name
    animal.display_name(scene_test);

    // set scene (change s2d to actual scene)
    setScene(scene_test);

    // second obj to scene
    var obj2 = new h2d.Object(scene_test);
  }

  
  override function update(dt:Float)
  {
    /**
    update function
    **/

    // rotate
    //bmp.rotation += 1 * dt;

    // fps stuff
    var fps_num = floatToStringDecimal(1 / dt, 2);
    fps.text = 'fps: [$fps_num]';

    time += dt;

    //if (time > 1.0) sprite.x += 0.1;
    bmp.y += 1;
    //bmp.move(1, 0);
    if (sprite != null) sprite.y += 1;
    if (K.isDown(K.UP)) anim_obj.y -= 1;
    if (K.isDown(K.DOWN)) anim_obj.y += 1;
  }


  public function floatToStringDecimal(x:Float, d:Int):String
  {
    /**
    float to string with decimal points
    source: https://stackoverflow.com/questions/23689001/how-to-reliably-format-a-floating-point-number-to-a-specified-number-of-decimal
    does not work for decimals over a specific number
    **/

    // restrict to max 6
    if (d > 6) d = 6;

    x = Math.round(x * Math.pow(10, d));
    var str:String = '' + x;
    var l = str.length;

    // safety
    if (l <= d)
    {
      while (l < d)
      {
        str = '0' + str;
        l++;
      }
      return '0.' + str;
    }

    // actual sub strings
    else {return str.substring(0, str.length - d) + '.' + str.substring(str.length - d);}
  }

}