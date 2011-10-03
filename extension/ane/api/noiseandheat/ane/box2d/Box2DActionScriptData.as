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
    import noiseandheat.ane.box2d.data.b2BodyProxy;

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
    public final class Box2DActionScriptData
    {
        private var _bodies:Dictionary = new Dictionary();

        public function getBody(bodyID:uint, createIfNeeded:Boolean = false):b2BodyProxy
        {
            if(_bodies[bodyID] == null && createIfNeeded)
            {
                _bodies[bodyID] = new b2BodyProxy();
            }

            return _bodies[bodyID];
        }

        public function get bodies():Dictionary
        {
            return _bodies;
        }
    }
}
