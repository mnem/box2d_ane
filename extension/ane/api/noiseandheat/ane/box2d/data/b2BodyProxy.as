package noiseandheat.ane.box2d.data
{
    /**
     * @author mnem
     */
    public class b2BodyProxy
    {
        public var id:uint = 0;
        public var angle:Number = 0.0;
        public var position:b2Vec = new b2Vec();
        private var _updateCallback:Function;

        public function notifyUpdated():void
        {
            if (_updateCallback != null)
            {
                try
                {
                    _updateCallback(this);
                }
                catch(e:Error)
                {
                    trace("Error calling b2BodyProxy update callback: " + e);
                }
            }
        }

        public function toString():String
        {
            return "[b2BodyProxy id:" + id + ", angle:" + angle.toFixed(2) + ", position:" + position + "]";
        }

        public function set updateCallback(updateCallback:Function):void
        {
            _updateCallback = updateCallback;
            notifyUpdated();
        }
    }
}
