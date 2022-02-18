// --
// animal class (for evaluating classes in haxe)

class Animal
{
  var name:String;

  public function new(name)
  { 
    /**
    constructor
    **/

    this.name = name;
  }


  public function display_name(screen)
  {
    /**
    display name of animal
    **/

    var tf = new h2d.Text(hxd.res.DefaultFont.get(), screen);
    tf.text = this.name;
    tf.x = 100;
    tf.y = 100;
  }
}