import ShopList from './ShopList'
import Map from './Map'

//Data 클래스 getShopList 프로토타입
axios.get("../data.json")
    .then(function (response) {
        const dummyData = response.data.content;
        newMap.setShopMarker(dummyData);
        return response
    }).then(function (response) {
    new ShopList('#shopListTemplate', '#shopList', response.data)
    })

const newMap = new Map();
