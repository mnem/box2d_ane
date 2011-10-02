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
    import noiseandheat.ane.box2d.errors.NullExtensionContextError;

    import flash.events.EventDispatcher;

    public final class Box2D
    extends EventDispatcher
    implements Box2DAPI
    {
        private var context:Box2DActionScriptData;
        private var storedBodies:Vector.<Object>;
        private var nextFreeID:uint = 0;

        public function Box2D()
        {
            trace("Constructing an ActionScript Box2D object");
            context = new Box2DActionScriptData();
            storedBodies = new Vector.<Object>();
        }

        public function dispose():void
        {
            context = null;
        }

        private function claimNextFreeID():uint
        {
            return nextFreeID++;
        }

        public function getNativeBuildStamp():String
        {
            if (context == null) throw new NullExtensionContextError();
            return "Noise & Heat Box2D Air Native Extension pure ActionScript implementation. For more information, see http://noiseandheat.com/";
        }

        public function getBox2DVersion():Version
        {
            if (context == null) throw new NullExtensionContextError();
            return Version.create({major:0, minor:0, revision:0});
        }

        public function setWorldGravity(b2Vec2:Object):void
        {
            if (context == null) throw new NullExtensionContextError();
        }

        public function createBody(b2BodyDef:Object = null):uint
        {
            if (context == null) throw new NullExtensionContextError();
            var o:Object = {id:claimNextFreeID(), angle:0.0, position:{x:0.0, y:0.0}};

            storedBodies.push(o);

            return o['id'];
        }

        public function createBodyFixtureWithBoxShape(bodyID:uint, width:Number, height:Number, b2FixtureDef:Object = null):uint
        {
            if (context == null) throw new NullExtensionContextError();
            return claimNextFreeID();
        }

        public function get bodies():Vector.<Object>
//        public function get bodies():Object//Vector.<Object>
        {
            if (context == null) throw new NullExtensionContextError();
            return context.bodies;
        }

        public function worldStep(timeStep:Number = 1 / 60, velocityIterations:int = 8, positionIterations:int = 3, updateBodiesVector:Boolean = true):void
        {
        }

        public function updateBodiesVector():void
        {
            context.bodies.length = 0;
            for(var i:int = 0; i < storedBodies.length; i++)
            {
                context.bodies.push(storedBodies[i]);
            }
        }
//        public function updateBodiesVector():void
//        {
//            context.bodies = {};//.length = 0;
//            for(var i:int = 0; i < storedBodies.length; i++)
//            {
//
//                context.bodies[storedBodies[i]['id']] = storedBodies[i];//.push(storedBodies[i]);
//            }
//        }
    }
}
