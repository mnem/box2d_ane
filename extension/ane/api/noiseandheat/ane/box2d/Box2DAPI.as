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
    import noiseandheat.ane.box2d.data.Version;
    import noiseandheat.ane.box2d.data.b2BodyProxy;

    import flash.events.IEventDispatcher;
    import flash.utils.Dictionary;

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
        function getBox2DVersion():Version;

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
        function createBody(b2BodyDef:Object = null):b2BodyProxy;

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

        /**
         * Simulates a step in the world. Once you have chosen a timeStep,
         * don't change it when calling worldStep again - unless you really
         * really understand the implications...
         *
         * @param timeStep - time step to simulate. Don't vary this.
         * @param velocityIterations - Number of iterations the velocity constraint solver goes through.
         * @param positionIterations - Number of iterations the position constraint solver goes through.
         * @param alsoUpdateBodiesVector - updates the bodies vector after this step. Generally, leave this
         *                             as true unless you want to call worldStep many times without
         *                             updating the visual representation of the world. Remember to
         *                             manually call updateBodiesVector if you set this to false.
         */
        function worldStep(timeStep:Number = 1 / 60, velocityIterations:int = 8, positionIterations:int = 3, alsoUpdateBodiesVector:Boolean = true):void;

        /**
         * Returns a vector of information about all the bodies in the world.
         * Each object contains:
         *    position:Object {x:Number, y:Number}
         *    angle:Number
         */
        function get bodies():Dictionary;

        /**
         * Updates the bodies vector so that it is an accurate representation
         * of what is in the world. This is automatically called after
         * worldStep if updateBodiesVector is true;
         */
        function updateBodyStore():void;
    }
}
