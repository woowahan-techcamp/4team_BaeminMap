import axios from 'axios'
import * as _ from "lodash";


class ShopList {
    constructor(targetSelector, arr, markersArr) {
        console.log('ShopList init!')
        this.createShopTemplateDOM(targetSelector, arr, markersArr)
    }

    createShopTemplateDOM(targetSelector, arr, markersArr) {
        axios.get('/src/templates/shop_list.ejs').then((response) => {
            const shopTemplate = _.template(response.data)
            this.renderTemplate(shopTemplate, targetSelector, arr, markersArr)
        })
    }

    renderTemplate(shopTemplate, targetSelector, arr, markersArr) {
        const targetElement = document.querySelector(targetSelector)
        targetElement.innerHTML = shopTemplate({data: arr})
        targetElement.addEventListener('click', (e) => {
            e.preventDefault()
            const target = e.target;
            if (!target.matches('a.shop-layer')) {
                return false
            } else if (document.querySelector(".selected-shop")) {
                //기존 선택된 shop의 포커싱을 초기화
                document.querySelector(".selected-shop").classList.remove("selected-shop")
            }
            //마커에 입력된 shopNumber 속성을 찾는다
            const targetMarkerArr = markersArr.filter(function (obj) {
                return obj.shopNumber.toString() === target.parentNode.id
            })
            const targetMarker = targetMarkerArr[0];
            //선택한 shop 과 연동된 마커 클릭 이벤트를 발생시킨다
            new google.maps.event.trigger(targetMarker, 'click');
            target.classList.add(".selected-shop");
            //targetPosition은 선택한 target의 위치를 구한다. 이후 50을 빼주는건 버튼 영역때문에 하드코딩한것
            targetElement.scrollTop += target.getBoundingClientRect().top - 50;
            // TODO: 상점 리스트 클릭시 마커 띄워주기
        })
        //스크롤 및 선택된 리스트 초기화
        targetElement.scrollTop = 0;
    }
}

export default ShopList