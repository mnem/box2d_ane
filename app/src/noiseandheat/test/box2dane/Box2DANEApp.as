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
package noiseandheat.test.box2dane
{
    import flash.text.TextFormat;

    import noiseandheat.ane.box2d.Box2D;
    import noiseandheat.ane.box2d.Box2DAPI;
    import noiseandheat.ane.box2d.events.Box2DExtensionErrorEvent;

    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.text.TextField;

    public final class Box2DANEApp
    extends Sprite
    {
        private var output:TextField;
        private var b2d:Box2DAPI;
        private var groundID:uint;
        private var groundFixtureID:uint;
        private var dynamicID:uint;
        private var dynamicFixtureID:uint;

        public function Box2DANEApp()
        {
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;

            output = new TextField();
            output.width = stage.stageWidth;
            output.height = stage.stageHeight;
            output.wordWrap = true;
            var tf:TextFormat = output.defaultTextFormat;
            tf.font = "_sans";
            tf.size = 16;
            output.defaultTextFormat = tf;
            addChild(output);

            stage.addEventListener(Event.RESIZE, handleResize);

            try
            {
                initBox2DAPI();
                doSomeStuff();
            }
            catch(e:Error)
            {
                log("ERROR: " + e);
            }
            log("Finished.");
        }

        private function doSomeStuff():void
        {
            log("Build stamp: " + b2d.getNativeBuildStamp());
            log("Box2D version: " + b2d.getBox2DVersion());

            log("Setting gravity to 0, -10");
            b2d.setWorldGravity({x:0, y:-10});

            logBodies();

            log("Creating ground");
            groundID = b2d.createBody({position:{x:0.0, y:-10.0}});
            groundFixtureID = b2d.createBodyFixtureWithBoxShape(groundID, 50.0, 10.0);

            b2d.updateBodiesVector();
            logBodies();

            log("Creating dynamic");
            dynamicID = b2d.createBody({type:2, position:{x:0.0, y:4.0}});
            dynamicFixtureID = b2d.createBodyFixtureWithBoxShape(dynamicID, 1.0, 1.0, {density:1.0, friction:0.3});
            b2d.updateBodiesVector();

            logBodies();

            log("Simulating...");

            for (var i:int = 0; i < 60; ++i)
            {
                b2d.worldStep(1 / 60, 6, 2);
                logBodies();
            }
        }

        private function logBodies():void
        {
            var line:String = "";

            if (b2d.bodies.length == 0)
            {
                line = "NONE";
            }
            else
            {
                // for each (var body:Object in b2d.bodies)
                // {
                // line += "\n" + body["id"] + ", angle:" + body["angle"] + ", position:(" + body["position"]['x'] + ", " + body["position"]['y'] + ")";
                // }
                for (var i:int = 0; i < b2d.bodies.length; i++)
                {
                    var body:Object = b2d.bodies[i];
                    if (body != null)
                        line += "\n" + i + "- id:" + body["id"] + ", angle:" + body["angle"] + ", position:(" + body["position"]['x'] + ", " + body["position"]['y'] + ")";
                }
            }

            log("Bodies (" + b2d.bodies.length + "): " + line);
        }

        private function initBox2DAPI():void
        {
            b2d = new Box2D();
            b2d.addEventListener(Box2DExtensionErrorEvent.INTERNAL_ERROR, handleExtensionError);
        }

        private function handleExtensionError(event:Box2DExtensionErrorEvent):void
        {
            log("EXTENSION ERROR: " + event.message);
        }

        private function handleResize(event:Event):void
        {
            output.width = stage.stageWidth;
            output.height = stage.stageHeight;
        }

        private function log(message:String):void
        {
            output.appendText(message + "\n");
        }
    }
}
