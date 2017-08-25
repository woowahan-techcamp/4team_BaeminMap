import ShopList from './ShopList'
import CardSlider from './CardSlider'
import axios from 'axios'
import * as _ from "lodash";

class Map {
    constructor(apidata) {
        this.currentLocation = {lat: 37.5759879, lng: 126.9769229};
        this.gmap = new google.maps.Map(document.getElementById('map'), {
            zoom: 18,
            center: this.currentLocation,
            minZoom: 14,
            maxZoom: 21,
            mapTypeControl: false,
            streetViewControl: false,
            fullscreenControl: false
        });
        this.searchPosition();
        this.data = apidata
        this.apidata = apidata
        this.markers = []
        this.userMarker = null
        this.shopDetailTemplate = null
        this.shopFoodDetailTemplate = null
        this.getShopDetailTemplate()
    }

    sleep(ms) {
        return new Promise(resolve => setTimeout(resolve, ms));
    }

    async getShopDetailTemplate() {
        if (!this.shopDetailTemplate) {
            await axios.get('/src/templates/shop_detail.ejs')
                .then((response) => {
                    this.shopDetailTemplate = response.data
                })
        }
        if (!this.shopFoodDetailTemplate) {
            await axios.get('/src/templates/shop_detail_foods.ejs')
                .then((response) => {
                    this.shopFoodDetailTemplate = response.data
                })
        }
    }

    updatePosition(position) {
        this.setUserMarker(position)
        this.gmap.panTo(position);
        this.currentLocation = position
    }

    setUserMarker(position) {
        if (this.userMarker) {
            this.userMarker.setMap(null)
        }
        this.userMarker = new google.maps.Marker({
            position: position,
            map: this.gmap,
            title: "my location",
            zIndex: 3,
            icon: {
                url : "./static/currentLocation.png",
                scaledSize: new google.maps.Size(30, 30)
            }
        })
    }

    searchPosition() {
        const map = this.gmap;
        const distanceElement = document.querySelector('.distance-option-list > .selected')
        const distance = parseFloat(distanceElement.dataset['distance'])
        const input = document.getElementById('pac-input');
        const searchBox = new google.maps.places.SearchBox(input);
        map.controls[google.maps.ControlPosition.TOP_LEFT].push(input);

        // Bias the SearchBox results towards current map's viewport.
        map.addListener('bounds_changed', () => {
            searchBox.setBounds(map.getBounds());
        });

        // TODO: on map 'zoom_changed', then change markers!
        map.addListener('zoom_changed', () => {
            this.resetMarkerAndInfo()
            const pinMarkers = this.markers.slice(30)
            if (map.zoom >= 17) {
                // 건물수준(좁게보기)
                pinMarkers.forEach((marker) => {
                    marker.setIcon(marker.categoryIcon)
                })
            } else {
                // 도로 구 수준(넓게보기)
                pinMarkers.forEach((marker) => {
                    marker.setIcon(marker.pinIcon)
                    marker.zIndex = 0;
                })
            }
        })

        // Listen for the event fired when the user selects a prediction and retrieve
        // more details for that place.
        searchBox.addListener('places_changed', () => {
            const filterChecker = document.querySelectorAll(".option.selected");
            const condition = document.querySelector('.sort-option.selected').id.replace('sort-option-', '')
            let categoryList = []
            for (const i of filterChecker) {
                const _categoryId = parseInt(i.id.replace('category-', ''))
                if (typeof _categoryId === 'number' && !isNaN(_categoryId)) {
                    categoryList.push(_categoryId)
                }
            }
            categoryList = (categoryList[0] === undefined) ? null : categoryList
            const distanceElement = document.querySelector('.distance-option-list > .selected')
            const distance = parseFloat(distanceElement.dataset['distance'])
            const places = searchBox.getPlaces();

            if (places.length === 0) {
                return;
            }

            // For each place, get the icon, name and location.
            const bounds = new google.maps.LatLngBounds();
            places.forEach((place) => {
                if (!place.geometry) {
                    console.log("Returned place contains no geometry");
                    return;
                }

                if (place.geometry.viewport) {
                    // Only geocodes have viewport.
                    bounds.union(place.geometry.viewport);
                } else {
                    bounds.extend(place.geometry.location);
                }
            });
            map.fitBounds(bounds);
            const pos = {
                lat: this.gmap.center.lat(),
                lng: this.gmap.center.lng()
            };
            this.reloadMap(distance, pos, this.data, condition, null, categoryList)
        });
    }

    resetMarkerAndInfo() {
        if (this.xMarker) {
            this.xMarker.setIcon(this.xMarkerIcon)
        }
    }

    setShopMarker(arr, apidata, duplicatedCoordinateList) {
        this.markers.forEach((i) => {
            i.setMap(null)
        })
        this.markers = []

        let _marker = {}

        arr.forEach((e) => {
            const shopLocationString = `${e.location.latitude}_${e.location.longitude}`
            let iconImg;
            let SelectedIconImg;
            // TODO: 중복인 아이콘으로 변경할것
            if (duplicatedCoordinateList.includes(shopLocationString)) {
                if (_marker[shopLocationString]) return true
                iconImg = '../static/WebMarker/plusMarker.png'
                SelectedIconImg = '../static/WebMarker/plusMarkerFill.png'
                _marker[shopLocationString] = true
            } else {
                iconImg = '../static/WebMarker/' + e.categoryEnglishName + '.png';
                SelectedIconImg = '../static/WebMarker/' + e.categoryEnglishName + 'Fill.png'
            }
            const position = {"lat": e.location.latitude, "lng": e.location.longitude}

            const SelectedIconImgObject = new Image()
            SelectedIconImgObject.addEventListener('load', (img) => {
                const markerWidth = img.target.naturalWidth / 3
                const markerHeight = img.target.naturalHeight / 3
                addMarkerListener(markerWidth, markerHeight)
            })
            SelectedIconImgObject.src = SelectedIconImg

            const addMarkerListener = (markerWidth, markerHeight) => {
                const marker = new google.maps.Marker({
                    position: position,
                    map: this.gmap,
                    zIndex: 1,
                    category: e.categoryEnglishName,
                    shopNumber: e.shopNumber,
                    categoryIcon: {
                        url: iconImg,
                        scaledSize: new google.maps.Size(markerWidth, markerHeight)
                    },
                    filledIcon: {
                        url: SelectedIconImg,
                        scaledSize: new google.maps.Size(markerWidth, markerHeight)
                    },
                    pinIcon: {
                        url: "./static/pin.png",
                        scaledSize: new google.maps.Size(10, 10)
                    },
                    icon: {
                        url: iconImg,
                        scaledSize: new google.maps.Size(markerWidth, markerHeight)
                    }
                    // TODO: 기본 아이콘 변경
                })
                marker.addListener('click', () => {
                    const resetHiddenList = () => {
                        const shopList = Array.prototype.slice.call(document.querySelectorAll('.shop'))
                        shopList.forEach(shop => shop.style.display = 'block')
                    }
                    const showModalAndMoveMap = () => {
                        // Single
                        this.showModal(e.shopNumber);
                        this.resetMarkerAndInfo()
                        this.gmap.setCenter(marker.getPosition());
                        this.xMarker = marker;
                        this.xMarkerIcon = marker.icon
                        //선택된 마커를 fill 마커로 변경
                        marker.setIcon(marker.filledIcon);
                        // 선택된 마커 z-index 값 부여를 통해 지도 위에서 가시성 확보
                        marker.setZIndex(2);
                        //리스트 연동부분
                        if (document.querySelector(".selected-shop")) {
                            document.querySelector(".selected-shop").classList.remove("selected-shop");
                        }
                        document.querySelector(".shop-list").scrollTop += document.getElementById(e.shopNumber).getBoundingClientRect().top - 50;
                        document.getElementById(e.shopNumber).childNodes[1].classList.add("selected-shop");
                    }
                    if (parseInt(window.innerWidth) <= 480) {
                        // Mobile
                        const card = document.querySelector("#card")
                        const floatButton = document.querySelector('.floating-button')
                        resetHiddenList()
                        if (_marker[shopLocationString]) {
                            // TODO: 카드 여러장 넣어야 함
                            const cardList = Array.prototype.slice.call(document.querySelectorAll('.shop'))
                                .filter(e => e.dataset.coordinates === shopLocationString)
                            const sliderWrapper = document.createElement('div')
                            const sliderNextImage = document.createElement('img')
                            sliderNextImage.src = './static/sliderNext.png'
                            sliderNextImage.className = 'slider-next-img'
                            card.innerHTML = ''
                            for (const _card of cardList) {
                                _card.id = ''
                                const newEl = _card.cloneNode(true)
                                newEl.innerHTML += sliderNextImage.outerHTML
                                newEl.style.display = 'inline-block'
                                sliderWrapper.append(newEl)
                            }
                            card.append(sliderWrapper)
                            // TODO: CardSlider 붙이기
                            const triggerMarker = (shopNumber, markersArr) => ShopList.triggerMarkerEvent(ShopList.searchTargetMarker(shopNumber, markersArr))
                            new CardSlider(card, sliderWrapper, triggerMarker, this.markers, this.showModal, e, this)
                        } else {
                            const html = document.getElementById(marker.shopNumber);
                            card.innerHTML = html.innerHTML
                        }
                        card.style.display = 'block'
                        if (parseInt(window.getComputedStyle(floatButton).bottom) < 140) {
                            floatButton.style.bottom = "140px"
                        }
                        this.resetMarkerAndInfo()
                        this.xMarkerIcon = marker.icon
                        this.xMarker = marker;
                        //선택된 마커를 fill 마커로 변경
                        marker.setIcon(marker.filledIcon);
                        // 선택된 마커 z-index 값 부여를 통해 지도 위에서 가시성 확보
                        marker.setZIndex(2);
                        // 마커 클릭시 모달 보이면 안됨
                        this.gmap.panTo(marker.getPosition())
                    } else {
                        // Desktop
                        if (_marker[shopLocationString]) {
                            // Duplicated 마커 선택시 리스트를 바꿔주자. (이 좌표만 남기고 싹 지우자)
                            resetHiddenList()
                            const shopList = Array.prototype.slice.call(document.querySelectorAll('.shop'))
                            const notDuplicated = shopList
                                .filter(shop => shop.dataset.coordinates !== shopLocationString)
                                .filter(shop => shop.style.display !== 'none') // 만약 다 가려졌으면 length는 0이 된다
                            notDuplicated.forEach(shop => shop.style.display = 'none')
                            if (notDuplicated.length === 0) {
                                // 다 가려진 상태라면...!
                                showModalAndMoveMap()
                            } else {
                                this.resetMarkerAndInfo()
                                this.xMarkerIcon = marker.icon
                                this.xMarker = marker;
                                marker.setIcon(marker.filledIcon);
                                marker.setZIndex(2);
                            }

                            //
                        } else {
                            resetHiddenList()
                            showModalAndMoveMap()
                        }
                    }
                });
                this.markers.push(marker)
            }
        });
    }

    async showModal(shopNumber) {
        // indicator.style.display = 'table'
        const modal = document.querySelector('#modal')
        const shopDetailData = this.filteredData.filter((i) => {
            return i.shopNumber == shopNumber
        })[0]
        modal.innerHTML = _.template(this.shopDetailTemplate)(shopDetailData)
        await this.apidata.getShopFoodData(shopNumber).then((response) => {
            const foodDetails = document.querySelector('#foodDetails')
            foodDetails.innerHTML = _.template(this.shopFoodDetailTemplate)({
                allCategoryFoodList: response.data
            })
        })
        // indicator.style.display = 'none'
        modal.style.display = 'block'
    }

    closeModal() {
        const modal = document.querySelector('#modal')
        modal.style.display = 'none'
    }

    reloadMap(distance, pos, apidata, key, order, categoryList) {
        indicator.style.display = ''
        this.gmap.setZoom(18)
        // Reset markers
        console.time("Marker Reset")
        for (let i of this.markers) {
            i.setMap(null)
        }
        this.markers = []
        console.timeEnd("Marker Reset")


        // if starPointAverage: reverse
        if (key === 'distance') {
            order = 'asc'
        } else {
            order = 'desc'
        }

        console.time("GetData")
        // Get new data from my new position
        const posString = `${pos.lng}_${pos.lat}`
        const currentPositionString = `${this.currentLocation.lng}_${this.currentLocation.lat}`
        if (posString !== currentPositionString) {
            apidata.getShopData(pos)
            this.updatePosition(pos)
        }
        console.time("Update My Position")
        // Update my Position
        console.timeEnd("Update My Position")
        console.timeEnd("GetData")
        let sortedData = null

        console.time("SortData")
        if (categoryList) {
            sortedData = apidata.getShopListByCategoryList(distance, categoryList, key, order)
        } else {
            sortedData = apidata.getShopListAll(distance, key, order)
        }
        sortedData.then((filteredData) => {
            while (!this.data) {
                this.sleep(100)
            }
            this.filteredData = filteredData
            this.duplicatedData = getDuplicatedCoordinateList(makeArrayToSet(filteredData))
            this.setShopMarker(filteredData, apidata, this.duplicatedData)
            new ShopList("#shopList", filteredData, this)
            indicator.style.display = 'none'
            console.timeEnd("SortData")
        })
    }
}

const makeArrayToSet = (shopList) => {
    return [new Set(shopList), shopList]
}

const getDuplicatedCoordinateList = (array) => {
    const shopLocationSet = array[0]
    const shopList = array[1]
    const duplicatedCoordinateList = []
    shopLocationSet.forEach((shop) => {
        const shopLocationString = `${shop.location.latitude}_${shop.location.longitude}`
        const _count = shopList.filter(
            (obj) => {
                return (
                    obj.location.latitude === shop.location.latitude && obj.location.longitude === shop.location.longitude
                )
            }
        ).length
        if (_count > 1) {
            duplicatedCoordinateList.push(shopLocationString)
        }
    })
    return duplicatedCoordinateList
}

export default Map
