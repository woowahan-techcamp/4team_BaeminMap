import ShopList from './ShopList'
import Map from './Map'
import Data from './Data'



const myData = new Data();
const myMap = new Map();
myData.getShopList([1], myMap.currentLocation)
myMap.setShopMarker(myData.shopListObj);