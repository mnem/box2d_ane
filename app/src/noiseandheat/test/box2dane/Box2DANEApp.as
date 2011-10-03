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
    import flash.utils.getTimer;
    import noiseandheat.ane.box2d.Box2D;
    import noiseandheat.ane.box2d.Box2DAPI;
    import noiseandheat.ane.box2d.data.b2BodyProxy;
    import noiseandheat.ane.box2d.data.b2VecProxy;
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
        private static const TEXT_OUT:Boolean = true;

        private static const PIXELS_PER_M:int = 42;
//        private static const PIXELS_PER_M:int = 10;

        private var output:TextField;
        private var b2d:Box2DAPI;
//        private var groundBody:b2BodyProxy;
//        private var groundFixtureID:uint;
//        private var dynamicBody:b2BodyProxy;
//        private var dynamicFixtureID:uint;

        private var canvas:Sprite;

        private static const SAMPLE_SIZE:int = 100;
        private var physicsTimings:Vector.<int> = new Vector.<int>(SAMPLE_SIZE, true);
        private var renderTimings:Vector.<int> = new Vector.<int>(SAMPLE_SIZE, true);
        private var currentSample:uint = 0;

        public function Box2DANEApp()
        {
            for(var i:int; i < SAMPLE_SIZE; i++)
            {
                physicsTimings[i] = -1;
                renderTimings[i] = -1;
            }

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
            var physicsTime:int = getTimer();
            b2d.worldStep(1 / 60, 6, 2, false);
            physicsTimings[currentSample] = getTimer() - physicsTime;

            var renderTime:int = getTimer();
            canvas.graphics.clear();
            b2d.updateBodyStore();
            renderTimings[currentSample] = getTimer() - renderTime;

            currentSample++;
            if(currentSample >= SAMPLE_SIZE) currentSample = 0;

            var physicsAverage:Number = 0;
            var renderAverage:Number = 0;
            var validSamples:int = 0;

            for(var i:int; i < SAMPLE_SIZE; i++)
            {
                var p:int = physicsTimings[i];
                var r:int = renderTimings[i];
                if(p > 0 && r > 0)
                {
                    physicsAverage += p;
                    renderAverage += r;
                    validSamples++;
                }
            }

            if(validSamples > 0)
            {
                physicsAverage /= validSamples;
                renderAverage /= validSamples;

                log("physics ms: " + physicsAverage.toFixed(2), true);
                log("render ms: " + renderAverage.toFixed(2));
            }
        }

        private function doSomeStuff():void
        {
            log("Build stamp: " + b2d.getNativeBuildStamp());
            log("Box2D version: " + b2d.getBox2DVersion());

            log("Setting gravity to 0, -10");
            b2d.setWorldGravity({x:0, y:-10});

            log("Creating ground");
            var groundBody:b2BodyProxy = b2d.createBody({position:{x:0.0, y:0.0}});
            groundBody.updateCallback = groundUpdated;
            b2d.createBodyFixtureWithBoxShape(groundBody.id, 10.0, 0.5);

            log("Creating dynamic");
            var i:int;
            var j:int;
            var iMax:int = 10;
            var jMax:int = 5;
            var cubeEdge:Number = 0.5;
            var currentX:Number = -cubeEdge * jMax / 2;
            var dynamicBody:b2BodyProxy;
            for(j = 0; j < jMax; j++)
            {
                for(i = 0; i < iMax; i++)
                {
                    dynamicBody = b2d.createBody({type:2, position:{x:currentX, y:9 + (cubeEdge*i)}});
                    dynamicBody.updateCallback = bodyUpdated;
                    b2d.createBodyFixtureWithBoxShape(dynamicBody.id, cubeEdge/2, cubeEdge/2, {restitution:0.5, density:1.0, friction:0.3});
                }

                currentX += cubeEdge;
            }
        }

        private function drawCenteredBox(position:b2VecProxy, width:Number, height:Number, colour:uint):void
        {
            var pixelsW:Number = width * PIXELS_PER_M;
            var pixelsH:Number = height * PIXELS_PER_M;
            var pixelsX:Number = (position.x * PIXELS_PER_M) - (pixelsW/2);
            var pixelsY:Number = (position.y * PIXELS_PER_M) + (pixelsH/2);

            var g:Graphics = canvas.graphics;
            g.beginFill(colour);
            g.drawRect(pixelsX, -pixelsY, pixelsW, pixelsH);
            g.endFill();
        }

        private function bodyUpdated(body:b2BodyProxy):void
        {
            //log("Updated: " + body);
            drawCenteredBox(body.position, 0.5, 0.5, 0xA51B26);
        }


        private function groundUpdated(body:b2BodyProxy):void
        {
            //log("Updated: " + body);
            drawCenteredBox(body.position, 20, 1, 0x929292);
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

        private function log(message:String, clear:Boolean = false):void
        {
            if(TEXT_OUT)
            {
                if(clear) output.text = "";
                output.appendText(message + "\n");
            }
        }
    }
}
