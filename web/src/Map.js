import ShopList from './ShopList'
import axios from 'axios'
import * as _ from "lodash";

class Map {
    constructor(data) {
        this.currentLocation = {lat: 37.5759879, lng: 126.9769229};
        this.map = new google.maps.Map(document.getElementById('map'), {
            zoom: 18,
            center: this.currentLocation,
            minZoom: 14,
            maxZoom: 21,
            mapTypeControl: false,
            streetViewControl: false,
            fullscreenControl: false
        });
        this.searchPosition();
        this.data = data
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
        this.map.setCenter(position);
        this.currentLocation = position
    }

    setUserMarker(position) {
        if (this.userMarker) {
            this.userMarker.setMap(null)
        }
        this.userMarker = new google.maps.Marker({
            position: position,
            map: this.map,
            title: "my location",
            zIndex: 0
        })
    }

    searchPosition() {
        const map = this.map;
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
                lat: this.map.center.lat(),
                lng: this.map.center.lng()
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
            // TODO: 중복인 아이콘으로 변경할것
            if (duplicatedCoordinateList.includes(shopLocationString)) {
                if (_marker[shopLocationString]) return true
                iconImg = './static/pin.png'
                _marker[shopLocationString] = true
            } else {
                iconImg = '../static/WebMarker/' + e.categoryEnglishName + '.png';
            }
            const position = {"lat": e.location.latitude, "lng": e.location.longitude}
            const SelectedIconImg = '../static/WebMarker/' + e.categoryEnglishName + 'Fill.png'
            const marker = new google.maps.Marker({
                position: position,
                map: this.map,
                zIndex: 1,
                category: e.categoryEnglishName,
                shopNumber: e.shopNumber,
                categoryIcon: {
                    url: iconImg,
                    scaledSize: new google.maps.Size(40, 35)
                },
                filledIcon: {
                    url: SelectedIconImg,
                    scaledSize: new google.maps.Size(40, 35)
                },
                pinIcon: {
                    url: "./static/pin.png",
                    scaledSize: new google.maps.Size(10, 10)
                },
                icon: {
                    url: iconImg,
                    scaledSize: new google.maps.Size(40, 35)
                }
                // TODO: 기본 아이콘 변경
            })
            marker.addListener('click', () => {
                if (parseInt(window.innerWidth) <= 480) {
                    const html = document.getElementById(marker.shopNumber);
                    const card = document.querySelector("#card")
                    const floatButton = document.querySelector('.floating-button')
                    card.innerHTML = html.innerHTML
                    card.style.display = 'block'
                    if (parseInt(window.getComputedStyle(floatButton).bottom) === 60) {
                        floatButton.style.bottom = "140px"
                    }
                    // floatButton.style.bottom = ((parseInt(window.getComputedStyle(floatButton).bottom)) + 130) + 'px';
                    this.resetMarkerAndInfo()
                    this.xMarkerIcon = marker.icon
                    this.xMarker = marker;
                    //선택된 마커를 fill 마커로 변경
                    marker.setIcon(marker.filledIcon);
                    // 선택된 마커 z-index 값 부여를 통해 지도 위에서 가시성 확보
                    marker.setZIndex(2);
                } else {
                    this.showModal(e.shopNumber, e, apidata);
                    this.resetMarkerAndInfo()
                    this.map.setCenter(marker.getPosition());
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
            });
            this.markers.push(marker)
        });
    }

    showModal(shopNumber, e, apidata) {
        const modal = document.querySelector('#modal')
        modal.innerHTML = _.template(this.shopDetailTemplate)(e)
        // infowindow.open(map, marker);
        // TODO: shop_detail_foods.ejs 렌더링 & innerHTML
        apidata.getShopFoodData(shopNumber).then((response) => {
            const foodDetails = document.querySelector('#foodDetails')
            const foodDetailsContent = _.template(this.shopFoodDetailTemplate)({
                allCategoryFoodList: response.data
            })
            foodDetails.innerHTML = foodDetailsContent
        })
        modal.style.display = 'block'
    }

    reloadMap(distance, pos, apidata, key, order, categoryList) {
        indicator.style.display = ''
        this.map.setZoom(18)
        // Reset markers
        console.time("Marker Reset")
        for (let i of this.markers) {
            i.setMap(null)
        }
        this.markers = []
        console.timeEnd("Marker Reset")

        console.time("Update My Position")
        // Update my Position
        this.updatePosition(pos)
        console.timeEnd("Update My Position")
        // if starPointAverage: reverse
        if (key === 'distance') {
            order = 'asc'
        } else {
            order = 'desc'
        }

        console.time("GetData")
        // Get new data from my new position
        apidata.getShopData(pos)
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
            new ShopList("#shopList", filteredData, this.markers)
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
