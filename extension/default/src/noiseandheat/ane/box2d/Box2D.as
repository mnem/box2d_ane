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
    import Box2D.Collision.Shapes.b2PolygonShape;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2BodyDef;
    import Box2D.Dynamics.b2Fixture;
    import Box2D.Dynamics.b2FixtureDef;
    import Box2D.Dynamics.b2World;

    import noiseandheat.ane.box2d.data.Version;
    import noiseandheat.ane.box2d.data.b2BodyProxy;
    import noiseandheat.ane.box2d.errors.NullExtensionContextError;

    import flash.events.EventDispatcher;
    import flash.utils.Dictionary;

    public final class Box2D
    extends EventDispatcher
    implements Box2DAPI
    {
        private var context:Box2DActionScriptData;
        private var nextFreeID:uint = 0;
        private var world:b2World;

        private var proxyToBodyMap:Dictionary = new Dictionary(true);

        public function Box2D()
        {
            context = new Box2DActionScriptData();
            world = new b2World(new b2Vec2(0, -10), true);
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

            return Version.create({major:2, minor:1, revision:0});
        }

        public function setWorldGravity(g:Object):void
        {
            if (context == null) throw new NullExtensionContextError();
            world.SetGravity(new b2Vec2(g['x'], g['y']));
        }

        public function createBody(def:Object = null):b2BodyProxy
        {
            if (context == null) throw new NullExtensionContextError();

            var bodyID:uint = claimNextFreeID();
            var bodyProxy:b2BodyProxy = context.getBody(bodyID, true);


            var bodyDef:b2BodyDef = new b2BodyDef();
            if(def)
            {
                if(def["position"])
                {
                    bodyDef.position.Set(def["position"]['x'], def["position"]['y']);
                }
                if(def['type']) bodyDef.type = def['type'];
            }

            var body:b2Body = world.CreateBody(bodyDef);
            body.SetUserData(bodyProxy);
            proxyToBodyMap[bodyProxy] = body;

            bodyProxy.id = bodyID;
            bodyProxy.angle = body.GetAngle();
            bodyProxy.position.x = body.GetPosition().x;
            bodyProxy.position.y = body.GetPosition().y;
            bodyProxy.notifyUpdated();

            return bodyProxy;
        }

        public function createBodyFixtureWithBoxShape(bodyID:uint, halfW:Number, halfH:Number, def:Object = null):uint
        {
            if (context == null) throw new NullExtensionContextError();

            var fixtureID:uint = claimNextFreeID();
            var bodyProxy:b2BodyProxy = context.getBody(bodyID, true);
            var body:b2Body = proxyToBodyMap[bodyProxy];

            if(body == null) return 0;

            var fixtureDef:b2FixtureDef = new b2FixtureDef();
            if(def != null)
            {
                if(def['friction']) fixtureDef.friction = def['friction'];
                if(def['density']) fixtureDef.density = def['density'];
                if(def['restitution']) fixtureDef.restitution = def['restitution'];
            }

            var shape:b2PolygonShape = new b2PolygonShape();
            shape.SetAsBox(halfW, halfH);
            fixtureDef.shape = shape;

            var fixture:b2Fixture;

            if(def != null)
            {
                fixture = body.CreateFixture(fixtureDef);
            }
            else
            {
                fixture = body.CreateFixture2(shape, 0);
            }

            fixture.SetUserData(fixtureID);

            return fixtureID;
        }

        public function get bodies():Dictionary
        {
            if (context == null) throw new NullExtensionContextError();
            return context.bodies;
        }

        public function worldStep(timeStep:Number = 1 / 60, velocityIterations:int = 8, positionIterations:int = 3, updateBodiesVector:Boolean = true):void
        {
            world.Step(timeStep, velocityIterations, positionIterations);

            if(updateBodiesVector) updateBodyStore();
        }

        public function updateBodyStore():void
        {
            for (var b:b2Body = world.GetBodyList(); b; b = b.GetNext())
            {
                var proxy:b2BodyProxy = b.GetUserData() as b2BodyProxy;
                if(proxy != null)
                {
                    proxy.angle = b.GetAngle();
                    proxy.position.x = b.GetPosition().x;
                    proxy.position.y = b.GetPosition().y;

                    proxy.notifyUpdated();
                }
            }
        }
    }
}
