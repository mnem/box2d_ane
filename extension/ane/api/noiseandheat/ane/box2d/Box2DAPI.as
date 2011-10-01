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
	import flash.events.IEventDispatcher;

	/**
	 * Public API for the Box2D native class.
	 *
	 * At the moment, the extension only allows 1 world to be simulated so
	 * there are no functions to explicitly create a world. It is implicitly
	 * created when you create a new class which implements Box2DAPI.
	 *
	 * See: noiseandheat.ane.box2d.Box2D
	 */
	public interface Box2DAPI
	extends IEventDispatcher
	{
		/**
		 * Disposes of the extension. You cannot use this instance
		 * of the extension after calling this, so do it when you
		 * are finished with it and want to force it to clean up
		 * without waiting for the garbage collector to do it.
		 */
		function dispose():void;

		/**
		 * Returns the build stamp for the native code library in use.
		 */
        function getNativeBuildStamp():String;
		/**
		 * Returns an object representing the Box2D version in use. This
		 * is represented in the object by int properties named "major",
		 * "minor" and "revision".
		 */
        function getBox2DVersion():Object;

		/**
		 * Sets the gravity in the world.
		 *
		 * @param object containing:
		 *    x:Number
		 *    y:Number
		 */
        function setWorldGravity(b2Vec2:Object):void;

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
        function createBody(b2BodyDef:Object):uint;

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
        function createBodyFixtureWithBoxShape(bodyID:uint, width:Number, height:Number, b2FixtureDef:Object = null):uint;
	}
}
