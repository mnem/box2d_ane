package noiseandheat.ane.box2d.data
{
    /**
     * @author mnem
     */
    public class b2VecProxy
    {
        public var x:Number = 0;
        public var y:Number = 0;

        public function toString():String
        {
            return "[b2Vec x:" + x.toFixed(2) + ", y:" + y.toFixed(2) + "]";
        }
    }
}
