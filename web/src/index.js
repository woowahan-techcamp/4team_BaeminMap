import ShopList from './ShopList'
import Map from './Map'
import Data from './Data'


// const myData = new Data();
// const myMap = new Map();
// myData.getShopList([1], myMap.currentLocation)
// myMap.setShopMarker(myData.shopListObj);

``

function getToken() {
    const baseUrl = "http://localhost:8080/";
    const tokenUrl = "http://auth-beta.baemin.com/oauth/authorize?response_type=token&redirect_uri=http://localhost:8080&client_id=techCampTeamB&scope=read";
    let apiToken = "";

    function checkToken() {
        console.log("checkToken")
        if (document.location.href === baseUrl) {
            redirectPage(tokenUrl)
        } else {
            parseToken()
        }
    }

    function redirectPage(url) {
        if (apiToken === '') {
            location.href = url
        }
    }

    function parseToken() {
        apiToken = location.href.split("#access_token=")[1].split("&")[0];
        console.log(apiToken)
    }

    checkToken()

    return apiToken
}


document.addEventListener('DOMContentLoaded', () => {
    const token = getToken()
    const map = new Map();
    const data = new Data();
    navigator.geolocation.getCurrentPosition((position) => {
        const pos = {
            lat: position.coords.latitude,
            lng: position.coords.longitude
        };
        map.updatePosition(pos)
        data.getShopList([1], pos, token).then((obj) => {
            console.log(obj)
            const obj2 = obj * 2
            return obj
            //필터 로직 들어갈 부분
        }).then((filteredData) => {
            map.setShopMarker(filteredData)
        })
    })
})


//     // 위치 가져오기(geoloaction)
//     getlocation().then(
//         axios.get(
//             // 위치 받고 위치 근처 업소 넘기고
//             // 위치 받아서 지도 위치 변경
//         ).then(
//             // TODO: 업소 목록을 필터링해서 넘겨주기
//         ).then(
//             // 업소 리스트를 업데이트
//             // map 마커 업데이트
//         ).then(
//             // TODO: 위에 두개 관계 연결
//         )
//     )
//
// })
//
// 도큐먼트.이벤트(폼(조건)
// 변경시
// )
// {
//     // 업소 목록을 필터링해서 넘겨주기
// )
// .
// then(
//     // 위치기반 업소 리스트를 업데이트
//     // map 마커 업데이트
// ).then(
//     // 위에 두개 관계 연결
// )
// }
//
// 위치
// 변경시(검색시)
// {
//     // 위치 가져오기(검색한 결과)
//     getlocation().then(
//         axios.get(
//             // 위치 받고 위치 근처 업소 넘기고
//             // 위치 받아서 지도 위치 변경
//         ).then(
//             // 업소 목록을 필터링해서 넘겨주기
//         ).then(
//             // 위치기반 업소 리스트를 업데이트
//             // map 마커 업데이트
//         ).then(
//             // 위에 두개 관계 연결
//         )
//     )
// }