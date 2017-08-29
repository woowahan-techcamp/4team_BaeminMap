import axios from 'axios'
import * as _ from "lodash";


class ShopList {
    constructor(targetSelector, arr, mapInstance) {
        console.log('ShopList init!')
        const markersArr = mapInstance.markers
        this.map = mapInstance
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
            if (window.innerWidth <= 480) {
                this.map.showModal(e.target.dataset.shopnumber)
            } else {
                e.preventDefault()
                ShopList.triggerChecker = true;
                const target = e.target;
                if (!target.matches('a.shop-layer')) {
                    return false
                } else if (document.querySelector(".selected-shop")) {
                    //기존 선택된 shop의 포커싱을 초기화
                    document.querySelector(".selected-shop").classList.remove("selected-shop")
                }
                ShopList.triggerMarkerEvent(ShopList.searchTargetMarker(target.dataset.shopnumber, markersArr))
                target.classList.add(".selected-shop");
                //targetPosition은 선택한 target의 위치를 구한다. 이후 40을 빼주는건 버튼 영역때문에 하드코딩한것
                targetElement.scrollTop += target.getBoundingClientRect().top - 40;
                // TODO: 상점 리스트 클릭시 마커 띄워주기
                this.map.showModal(target.dataset.shopnumber)
            }
        })
        //스크롤 및 선택된 리스트 초기화
        targetElement.scrollTop = 0;
    }

    static searchTargetMarker(shopNumber, markersArr) {
        const targetMarkerArr = markersArr.filter((e) => {
            return e.shopNumber == shopNumber
        })
        if (targetMarkerArr.length != []) {
            console.log(targetMarkerArr[0])
            return targetMarkerArr[0]
        } else {
            return markersArr.filter((e) => {
                const el = Array.prototype.slice.call(document.querySelectorAll('.shop')).filter(
                    (i) => {
                        return i.dataset.shopnumber === shopNumber
                    }
                )[0]
                const coordinates = el.dataset.coordinates
                const markerCoordinates = `${e.position.lat()}_${e.position.lng().toFixed(5)}`
                return markerCoordinates === coordinates
            })[0]
        }
    }

    static triggerMarkerEvent(targetMarker) {
        if (targetMarker) {
            new google.maps.event.trigger(targetMarker, 'click');
        }
    }

    static updateMarker(targetMarker, categoryEnglishName) {
        if (targetMarker) {
            const SelectedIconImgObject = new Image()
            SelectedIconImgObject.addEventListener('load', (img) => {
                const markerWidth = img.target.naturalWidth / 3
                const markerHeight = img.target.naturalHeight / 3
                targetMarker.setIcon({
                    url: SelectedIconImgObject.src,
                    scaledSize: new google.maps.Size(markerWidth, markerHeight)
                })
            })
            SelectedIconImgObject.src = '../static/WebMarker/' + categoryEnglishName + 'Fill.png'
        }
    }

    static showModalfromShopNumber(shopNumber) {
        this.map.showModal(shopNumber)
    }

}

export default ShopList
