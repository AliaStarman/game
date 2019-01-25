package scripts;

import com.stencyl.graphics.G;
import com.stencyl.graphics.BitmapWrapper;

import com.stencyl.behavior.Script;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.ActorScript;
import com.stencyl.behavior.SceneScript;
import com.stencyl.behavior.TimedTask;

import com.stencyl.models.Actor;
import com.stencyl.models.GameModel;
import com.stencyl.models.actor.Animation;
import com.stencyl.models.actor.ActorType;
import com.stencyl.models.actor.Collision;
import com.stencyl.models.actor.Group;
import com.stencyl.models.Scene;
import com.stencyl.models.Sound;
import com.stencyl.models.Region;
import com.stencyl.models.Font;
import com.stencyl.models.Joystick;

import com.stencyl.Engine;
import com.stencyl.Input;
import com.stencyl.Key;
import com.stencyl.utils.Utils;

import openfl.ui.Mouse;
import openfl.display.Graphics;
import openfl.display.BlendMode;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.events.TouchEvent;
import openfl.net.URLLoader;

import box2D.common.math.B2Vec2;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2Fixture;
import box2D.dynamics.joints.B2Joint;

import motion.Actuate;
import motion.easing.Back;
import motion.easing.Cubic;
import motion.easing.Elastic;
import motion.easing.Expo;
import motion.easing.Linear;
import motion.easing.Quad;
import motion.easing.Quart;
import motion.easing.Quint;
import motion.easing.Sine;

import com.stencyl.graphics.shaders.BasicShader;
import com.stencyl.graphics.shaders.GrayscaleShader;
import com.stencyl.graphics.shaders.SepiaShader;
import com.stencyl.graphics.shaders.InvertShader;
import com.stencyl.graphics.shaders.GrainShader;
import com.stencyl.graphics.shaders.ExternalShader;
import com.stencyl.graphics.shaders.InlineShader;
import com.stencyl.graphics.shaders.BlurShader;
import com.stencyl.graphics.shaders.SharpenShader;
import com.stencyl.graphics.shaders.ScanlineShader;
import com.stencyl.graphics.shaders.CSBShader;
import com.stencyl.graphics.shaders.HueShader;
import com.stencyl.graphics.shaders.TintShader;
import com.stencyl.graphics.shaders.BloomShader;



class ActorEvents_2 extends ActorScript
{
	public var _RunSpeed:Float;
	public var _touchfloor:Bool;
	public var _facingright:Bool;
	public var _protagonistx:Float;
	
	
	public function new(dummy:Int, actor:Actor, dummy2:Engine)
	{
		super(actor);
		nameMap.set("Run Speed", "_RunSpeed");
		_RunSpeed = 20.0;
		nameMap.set("touchfloor", "_touchfloor");
		_touchfloor = false;
		nameMap.set("facingright", "_facingright");
		_facingright = false;
		nameMap.set("protagonist x", "_protagonistx");
		_protagonistx = 0.0;
		
	}
	
	override public function init()
	{
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if(((isKeyDown("up") && (_facingright == true)) && (_touchfloor == true)))
				{
					actor.setAnimation("" + "jump right");
					actor.setYVelocity(-33);
					_touchfloor = false;
					propertyChanged("_touchfloor", _touchfloor);
					_facingright = true;
					propertyChanged("_facingright", _facingright);
					Engine.engine.setGameAttribute("animation number", 5);
				}
				else if(((isKeyDown("up") && (_facingright == false)) && (_touchfloor == true)))
				{
					actor.setAnimation("" + "jump left");
					actor.setYVelocity(-32);
					_touchfloor = false;
					propertyChanged("_touchfloor", _touchfloor);
					_facingright = false;
					propertyChanged("_facingright", _facingright);
					Engine.engine.setGameAttribute("animation number", 6);
				}
				else if((((isKeyDown("up") && isKeyDown("right")) && (_facingright == true)) && (_touchfloor == true)))
				{
					actor.setAnimation("" + "jump right");
					actor.setYVelocity(-32);
					actor.setXVelocity(_RunSpeed);
					_touchfloor = false;
					propertyChanged("_touchfloor", _touchfloor);
					_facingright = true;
					propertyChanged("_facingright", _facingright);
					Engine.engine.setGameAttribute("animation number", 7);
				}
				else if((((isKeyDown("up") && isKeyDown("left")) && (_facingright == false)) && (_touchfloor == true)))
				{
					actor.setAnimation("" + "jump left");
					actor.setYVelocity(-32);
					actor.setXVelocity(-(_RunSpeed));
					_touchfloor = false;
					propertyChanged("_touchfloor", _touchfloor);
					_facingright = false;
					propertyChanged("_facingright", _facingright);
					Engine.engine.setGameAttribute("animation number", 8);
				}
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(10), event.otherActor.getType(),event.otherActor.getGroup()))
			{
				if((((_facingright == true) && (actor.getLastCollidedActor().getAnimation() == "enemy run left")) || ((_facingright == false) && (actor.getAnimation() == "enemy run right"))))
				{
					recycleActor(actor);
				}
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(12), event.otherActor.getType(),event.otherActor.getGroup()))
			{
				if((!(actor.getAnimation() == "kick right") || !(actor.getAnimation() == "kick left")))
				{
					recycleActor(actor);
				}
			}
		});
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if(((isKeyDown("down") && isKeyDown("right")) && ((_facingright == true) && (_touchfloor == true))))
				{
					actor.setAnimation("" + "kick right");
					actor.setXVelocity((_RunSpeed + 5));
					Engine.engine.setGameAttribute("animation number", 9);
				}
				else if(((isKeyDown("down") && isKeyDown("left")) && ((_facingright == false) && (_touchfloor == true))))
				{
					actor.setAnimation("" + "kick left");
					actor.setXVelocity((-(_RunSpeed) - 5));
					Engine.engine.setGameAttribute("animation number", 10);
				}
				else if(((isKeyDown("down") && (_facingright == true)) && !((isKeyDown("left") && isKeyDown("right")))))
				{
					actor.setAnimation("" + "kick right");
					Engine.engine.setGameAttribute("animation number", 11);
				}
				else if(((isKeyDown("down") && (_facingright == false)) && !((isKeyDown("left") && isKeyDown("right")))))
				{
					actor.setAnimation("" + "kick left");
					Engine.engine.setGameAttribute("animation number", 12);
				}
			}
		});
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				engine.cameraFollow(actor);
				if((((isKeyDown("right") && !(isKeyDown("left"))) && (!(isKeyDown("up")) && !(isKeyDown("down")))) && (_touchfloor == true)))
				{
					actor.setXVelocity(_RunSpeed);
					actor.setAnimation("" + "run right");
					_facingright = true;
					propertyChanged("_facingright", _facingright);
					Engine.engine.setGameAttribute("animation number", 1);
				}
				else if((((isKeyDown("left") && !(isKeyDown("right"))) && (!(isKeyDown("up")) && !(isKeyDown("down")))) && (_touchfloor == true)))
				{
					actor.setXVelocity(-(_RunSpeed));
					actor.setAnimation("" + "run left");
					_facingright = false;
					propertyChanged("_facingright", _facingright);
					Engine.engine.setGameAttribute("animation number", 2);
				}
				else if((((!(isKeyDown("right")) && !(isKeyDown("left"))) && (!(isKeyDown("up")) && !(isKeyDown("down")))) && ((_facingright == true) && (_touchfloor == true))))
				{
					actor.setXVelocity(0);
					actor.setAnimation("" + "idle right");
					Engine.engine.setGameAttribute("animation number", 3);
				}
				else if((((!(isKeyDown("right")) && !(isKeyDown("left"))) && (!(isKeyDown("up")) && !(isKeyDown("down")))) && ((_facingright == false) && (_touchfloor == true))))
				{
					actor.setXVelocity(0);
					actor.setAnimation("" + "idle left");
					Engine.engine.setGameAttribute("animation number", 4);
				}
			}
		});
		
		/* ======================= Member of Group ======================== */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorGroup(1),event.otherActor.getType(),event.otherActor.getGroup()))
			{
				_touchfloor = true;
				propertyChanged("_touchfloor", _touchfloor);
			}
		});
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if((actor.getScreenX() < 0))
				{
					actor.setX(1);
				}
				else if((actor.getScreenX() > ((getSceneWidth()) - (actor.getWidth()))))
				{
					actor.setX((((getSceneWidth()) - (actor.getWidth())) - 1));
				}
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}