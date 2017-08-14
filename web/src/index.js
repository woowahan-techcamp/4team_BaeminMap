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
            redirectPage(tokenUrl);
        } else {
            parseToken();
        }
    }

    function redirectPage(url) {
        if (apiToken === '') {
            location.href = url;
        }
    }

    function parseToken() {
        apiToken = location.href.split("#access_token=")[1].split("&")[0];
        console.log(apiToken);
    }

    checkToken();

    return apiToken;
}

function filterReset(targetArr, filterChecker){
    console.log(filterChecker)
    if (filterChecker) {
        return false
    } else {
        targetArr.forEach((target) => {
            const targetAll = document.querySelectorAll("."+target);
            targetAll.forEach((e)=>{
                e.classList.remove("selected");
            })
            document.querySelector("."+target).classList.add("selected");
        })
    }
}

function categoryFilterEvent(tar){
    const eventHTML = document.querySelector(tar);
    const categoryAll = document.querySelector("#category-all")

    eventHTML.addEventListener("click", function (e) {
        let target = e.target;
        if (target.tagName !== "LI"){
            return false
        }
        if (target.id === "category-all" && target.className === "category"){
            const selectedCategoryArr = document.querySelectorAll(".category.selected");
            selectedCategoryArr.forEach((e)=>{
                e.classList.remove("selected");
            });
            target.classList.add("selected");
        } else if (target.id !== "category-all" && target.classList.contains("selected")){
            target.classList.remove("selected");
        } else if (!target.classList.contains("selected")){
                categoryAll.classList.remove("selected");
                target.classList.add("selected");
        }
    })
}

function filterButtonEvent(tar, filter, layer, option){
    const eventTarget = document.querySelector(tar);
    const filterSection = document.querySelector(filter);
    const overLayer = document.querySelector(layer);
    let filterChecker = false;
    eventTarget.addEventListener("click", function () {
        if (option === "on"){
            filterSection.style.transform = "translateY(calc(100% - 50px))";
            overLayer.style.zIndex = "1";
            filterChecker = true;
        } else if(option ==="cancel"){
            filterSection.style.transform = "translateY(0)";
            overLayer.style.zIndex = "0";
            //필터링 취소버튼을 누르면 필터값이 초기화된다.
            filterReset(["category", "sort-option", "distance-option"], filterChecker);
        } else if(option ==="apply"){
            filterSection.style.transform = "translateY(0)";
            overLayer.style.zIndex = "0";
            //TODO : 여기에 필터 적용해서 소트 요청하는 로직 구현
        }
    })
}

function sortOptionEvent(tar, option){
    const eventTarget = document.querySelector(tar)
    eventTarget.addEventListener("click", function(e){
        let target = e.target;
        if (target.tagName === "LI" && target.className === "sort-option" && option === "sort"){
            document.querySelector(".sort-option.selected").classList.remove("selected");
            target.classList.add("selected");
        } else if (target.tagName === "LI" && target.className === "distance-option" && option === "distance") {
            document.querySelector(".distance-option.selected").classList.remove("selected");
            target.classList.add("selected");
        }
    });
}


document.addEventListener('DOMContentLoaded', () => {
    const token = getToken();
    const map = new Map();
    const data = new Data();

    navigator.geolocation.getCurrentPosition((position) => {
        const pos = {
            lat: position.coords.latitude,
            lng: position.coords.longitude
        };
        map.updatePosition(pos);
        data.getShopList(data.categoryArr, pos, token).then((arr) => {
            //필터 로직 들어갈 부분. 필터 이후 소트를 한다.
            return data.sortList(arr, 0);
        }).then((filteredData) => {
            console.log(filteredData)
            new ShopList("#shopListTemplate", "#shopList", filteredData)
            map.setShopMarker(filteredData);
        })
    })
    categoryFilterEvent(".category-list");
    filterButtonEvent(".filter-button-wrapper", ".filter-controller", ".layer", "on");
    filterButtonEvent(".cancel-filter-button", ".filter-controller", ".layer", "cancel");
    filterButtonEvent(".apply-filter-button", ".filter-controller", ".layer", "apply");
    sortOptionEvent(".sort-option-list", "sort");
    sortOptionEvent(".distance-option-list", "distance");
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