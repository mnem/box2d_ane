/**
 * (c) Copyright 2011 David Wagner.
 *
 * Complain/commend: http://noiseandheat.com/
 *
 *
 * Licensed under the MIT license:
 *
 *     http://www.opensource.org/licenses/mit-license.php
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package noiseandheat.ane.box2d
{
	import flash.external.ExtensionContext;
	import flash.events.StatusEvent;
	import flash.events.EventDispatcher;

	import noiseandheat.ane.box2d.errors.NullExtensionContextError;
	import noiseandheat.ane.box2d.errors.EntityCreationError;
	import noiseandheat.ane.box2d.events.Box2DExtensionErrorEvent;
    import noiseandheat.ane.box2d.data.Version;

	public final class Box2D
	extends EventDispatcher
	implements Box2DAPI
	{
		private static const INVALID_ENTITY_ID:uint = 0;

		private var context:ExtensionContext;

		public function Box2D()
		{
			context = ExtensionContext.createExtensionContext("noiseandheat.ane.box2d", null);
			if(context != null)
			{
				context.addEventListener(StatusEvent.STATUS, onStatus);

				context.actionScriptData = new Box2DActionScriptData();
			}
		}

		private function onStatus(event:StatusEvent):void
		{
			if(event.code == "INTERNAL_ERROR")
			{
				dispatchEvent(
					new Box2DExtensionErrorEvent(
						Box2DExtensionErrorEvent.INTERNAL_ERROR,
						event.level));
			}
		}

		public function dispose():void
		{
			if(context != null)
			{
				context.dispose();
			}
		}

		/**
		 * Returns the build stamp for the native code library in use.
		 */
        public function getNativeBuildStamp():String
        {
			if(context == null) throw new NullExtensionContextError();

			return context.call("getNativeBuildStamp") as String;
        }

		/**
		 * Returns an object representing the Box2D version in use. This
		 * is represented in the object by int properties named "major",
		 * "minor" and "revision".
		 */
        public function getBox2DVersion():Version
        {
			if(context == null) throw new NullExtensionContextError();

			return Version.create(context.call("getBox2DVersion") as Object);
        }

		/**
		 * Sets the gravity in the world.
		 *
		 * @param b2Vec2 - object containing:
		 *    x:Number
		 *    y:Number
		 */
        public function setWorldGravity(b2Vec2:Object):void
        {
			if(context == null) throw new NullExtensionContextError();

			context.call("setWorldGravity", b2Vec2);
        }

		/**
		 * Creates a new body in the world from the supplied definition. You
		 * must use the returned numeric ID to refer to the body in the
		 * future. If you don't store it somewhere, the poor little body
		 * will be orphaned in the world.
		 *
 		 * @param b2BodyDef - object containing none or more of:
 		 *    angle:Number
		 *    angularVelocity:Number
		 *    linearDamping:Number
		 *    angularDamping:Number
		 *    gravityScale:Number
		 *    allowSleep:Boolean
		 *    awake:Boolean
		 *    fixedRotation:Boolean
		 *    bullet:Boolean
		 *    active:Boolean
		 *    type:int <0 = b2_staticBody, 1 = b2_kinematicBody, 2 = b2_dynamicBody>
		 *    linearVelocity:Object {x:Number, y:Number}
		 *    position:Object {x:Number, y:Number}
		 */
        public function createBody(b2BodyDef:Object = null):uint
        {
			if(context == null) throw new NullExtensionContextError();

			var id:uint = context.call("createBody", b2BodyDef) as uint;
			if(id == INVALID_ENTITY_ID) throw new EntityCreationError();
			return id;
        }

		/**
		 * Creates a new fixture on a body in the world from the supplied
		 * shape and definition. You must use the returned numeric ID to
		 * refer to the fixture in the future.
		 *
		 * @param bodyID - ID of the body that was returned by createBody
		 * @param width - Width of the box
		 * @param height - Height of the box
 		 * @param b2FixtureDef - object containing none or more of:
 		 *    friction:Number
		 *    restitution:Number
		 *    density:Number
		 *    isSensor:Boolean
		 */
        public function createBodyFixtureWithBoxShape(bodyID:uint, width:Number, height:Number, b2FixtureDef:Object = null):uint
        {
			if(context == null) throw new NullExtensionContextError();

			var id:uint = context.call("createBodyFixtureWithBoxShape", bodyID, width, height, b2FixtureDef) as uint;
			if(id == INVALID_ENTITY_ID) throw new EntityCreationError();
			return id;
        }

		/**
		 * Simulates a step in the world. Once you have chosen a timeStep,
		 * don't change it when calling worldStep again - unless you really
		 * really understand the implications...
		 *
		 * @param timeStep - time step to simulate. Don't vary this.
		 * @param velocityIterations - Number of iterations the velocity constraint solver goes through.
		 * @param positionIterations - Number of iterations the position constraint solver goes through.
		 * @param updateBodiesVector - updates the bodies vector after this step. Generally, leave this
		 *                             as true unless you want to call worldStep many times without
		 *							   updating the visual representation of the world. Remember to
		 *							   manually call updateBodiesVector if you set this to false.
		 */
        public function worldStep(timeStep:Number = 1/60, velocityIterations:int = 8, positionIterations:int = 3, alsoUpdateBodiesVector:Boolean = true):void
        {
			if(context == null) throw new NullExtensionContextError();

			context.call("worldStep", timeStep, velocityIterations, positionIterations);

			if(alsoUpdateBodiesVector) updateBodiesVector();
        }

		/**
		 * Returns a vector of information about all the bodies in the world.
		 * Each object contains:
 		 *    id:uint
		 *    position:Object {x:Number, y:Number}
 		 *    angle:Number
		 */
        public function get bodies():Vector.<Object>
//        public function get bodies():Object
        {
        	return Box2DActionScriptData(context.actionScriptData).bodies;
        }

		/**
		 * Updates the bodies vector so that it is an accurate representation
		 * of what is in the world. This is automatically called after
		 * worldStep if updateBodiesVector is true;
		 */
        public function updateBodiesVector():void
        {
			context.call("updateBodiesVector");
        }
	}
}
