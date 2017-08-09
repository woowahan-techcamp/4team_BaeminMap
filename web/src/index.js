import ShopList from './ShopList'
import Map from './Map'
import Data from './Data'

//Data 클래스 getShopList 프로토타입
// axios.get("../data.json")
//     .then(function (response) {
//         const dummyData = response.data.content;
//         newMap.setShopMarker(dummyData);
//         return response
//     }).then(function (response) {
//     new ShopList('#shopListTemplate', '#shopList', response.data)
//     })

const myData = new Data();
myData.getShopList(myData.categoryArr, function(jsonData){
    new ShopList('#shopListTemplate', '#shopList', jsonData)
})

const newMap = new Map();