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
  import noiseandheat.ane.box2d.data.b2Vec;
  import noiseandheat.ane.box2d.errors.NullExtensionContextError;
  import flash.events.EventDispatcher;
  import flash.utils.Dictionary;

    public final class Box2D
    extends EventDispatcher
    implements Box2DAPI
    {
        private var context:Box2DActionScriptData;
        private var nextFreeID:uint = 0;

        public function Box2D()
        {
            context = new Box2DActionScriptData();
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

        public function createBody(b2BodyDef:Object = null):b2BodyProxy
        {
            if (context == null) throw new NullExtensionContextError();

            var bodyID:uint = claimNextFreeID();
            var body:b2BodyProxy = context.getBody(bodyID, true);

            body.id = bodyID;

            if(b2BodyDef)
            {
                if(b2BodyDef["position"])
                {
                    body.position.x = b2BodyDef["position"]['x'];
                    body.position.y = b2BodyDef["position"]['y'];
                }
            }

            return body;
        }

        public function createBodyFixtureWithBoxShape(bodyID:uint, width:Number, height:Number, b2FixtureDef:Object = null):uint
        {
            if (context == null) throw new NullExtensionContextError();
            return claimNextFreeID();
        }

        public function get bodies():Dictionary
        {
            if (context == null) throw new NullExtensionContextError();
            return context.bodies;
        }

        public function worldStep(timeStep:Number = 1 / 60, velocityIterations:int = 8, positionIterations:int = 3, updateBodiesVector:Boolean = true):void
        {
            if(updateBodiesVector) updateBodyStore();
        }

        public function updateBodyStore():void
        {
            for each (var body:b2BodyProxy in context.bodies)
            {
                body.notifyUpdated();
            }
        }
    }
}
