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
    import noiseandheat.ane.box2d.Box2D;
    import noiseandheat.ane.box2d.Box2DAPI;
    import noiseandheat.ane.box2d.data.b2BodyProxy;
    import noiseandheat.ane.box2d.events.Box2DExtensionErrorEvent;

    import flash.display.Graphics;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageQuality;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.text.TextField;
    import flash.text.TextFormat;

    [SWF(backgroundColor="#FFFFFF", frameRate="61", width="480", height="320")]
    public final class Box2DANEApp
    extends Sprite
    {
        private static const TEXT_OUT:Boolean = false;

        private static const PIXELS_PER_M:int = 42;

        private var output:TextField;
        private var b2d:Box2DAPI;
        private var groundBody:b2BodyProxy;
        private var groundFixtureID:uint;
        private var dynamicBody:b2BodyProxy;
        private var dynamicFixtureID:uint;

        private var canvas:Sprite;

        public function Box2DANEApp()
        {
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
            stage.quality = StageQuality.LOW;

            if(TEXT_OUT)
            {
                output = new TextField();
                output.width = stage.stageWidth;
                output.height = stage.stageHeight;
                output.wordWrap = true;
                var tf:TextFormat = output.defaultTextFormat;
                tf.font = "_sans";
                tf.size = 16;
                output.defaultTextFormat = tf;
                addChild(output);
            }

            canvas = new Sprite();
            canvas.x = stage.stageWidth / 2;
            canvas.y = stage.stageHeight;
            addChild(canvas);

            try
            {
                initBox2DAPI();
                doSomeStuff();
            }
            catch(e:Error)
            {
                log("ERROR: " + e);
            }

            stage.addEventListener(Event.RESIZE, handleResize);
            stage.addEventListener(Event.ENTER_FRAME, handleEnterFrame);
        }

        private function handleEnterFrame(event:Event):void
        {
            canvas.graphics.clear();

            b2d.worldStep(1 / 60, 6, 2);
        }

        private function doSomeStuff():void
        {
            log("Build stamp: " + b2d.getNativeBuildStamp());
            log("Box2D version: " + b2d.getBox2DVersion());

            log("Setting gravity to 0, -10");
            b2d.setWorldGravity({x:0, y:-10});

            log("Creating ground");
            groundBody = b2d.createBody({position:{x:0.0, y:0.0}});
            groundBody.updateCallback = groundUpdated;
            groundFixtureID = b2d.createBodyFixtureWithBoxShape(groundBody.id, 5.0, 1.0);

            log("Creating dynamic");
            dynamicBody = b2d.createBody({type:2, position:{x:0.0, y:9}});
            dynamicBody.updateCallback = bodyUpdated;
            dynamicFixtureID = b2d.createBodyFixtureWithBoxShape(dynamicBody.id, 1.0, 1.0, {density:1.0, friction:0.3});
        }

        private function bodyUpdated(body:b2BodyProxy):void
        {
            //log("Updated: " + body);

            var x_px:Number = body.position.x * PIXELS_PER_M;
            var y_px:Number = body.position.y * PIXELS_PER_M;

            var g:Graphics = canvas.graphics;
            g.beginFill(0xA51B26);
            g.drawRect(x_px - (0.5 * PIXELS_PER_M), -(y_px - (0.5 * PIXELS_PER_M)), 1*PIXELS_PER_M, 1*PIXELS_PER_M);
            g.endFill();
        }


        private function groundUpdated(body:b2BodyProxy):void
        {
            //log("Updated: " + body);
            var g:Graphics = canvas.graphics;
            g.beginFill(0x929292);

            var x_px:Number = body.position.x * PIXELS_PER_M;
            var y_px:Number = body.position.y * PIXELS_PER_M;

            g.drawRect(x_px - (2.5 * PIXELS_PER_M), -(y_px - (0.5 * PIXELS_PER_M)), 5*PIXELS_PER_M, 1*PIXELS_PER_M);
            g.endFill();
        }

        private function logBodies():void
        {
            var line:String = "";

            for each (var body:b2BodyProxy in b2d.bodies)
            {
                line += "\n" + body.toString();
            }
//                for (var i:int = 0; i < b2d.bodies.length; i++)
//                {
//                    var body:Object = b2d.bodies[i];
//                    if (body != null)
//                        line += "\n" + i + "- id:" + body["id"] + ", angle:" + body["angle"] + ", position:(" + body["position"]['x'] + ", " + body["position"]['y'] + ")";
//                }

            log("Bodies: " + line);
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
            if(TEXT_OUT)
            {
                output.width = stage.stageWidth;
                output.height = stage.stageHeight;
            }
            canvas.x = stage.stageWidth / 2;
            canvas.y = stage.stageHeight;
        }

        private function log(message:String):void
        {
            if(TEXT_OUT) output.appendText(message + "\n");
        }
    }
}
