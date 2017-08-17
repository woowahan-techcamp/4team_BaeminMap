import ShopList from './ShopList'
import * as _ from "lodash";

class Map {
    constructor(data) {
        this.infowindow;
        this.currentLocation = {lat: 37.5759879, lng: 126.9769229};
        this.map = new google.maps.Map(document.getElementById('map'), {
            zoom: 17,
            center: this.currentLocation,
            minZoom: 14,
            maxZoom: 19
        });
        this.searchPosition();
        this.data = data
        this.markers = []
        this.userMarker = null
        this.shopDetailTemplate = null
        this.getShopDetailTemplate()
    }

    sleep(ms) {
        return new Promise(resolve => setTimeout(resolve, ms));
    }

    async getShopData(position) {
        this.data = null
        const body = Object.assign(position, {type: 1})
        const response = await axios.post(
            this.getShopURL,
            body
        )
        this.data = response.data
    }

    async getShopDetailTemplate() {
        if (!this.shopDetailTemplate) {
            await axios.get('/src/templates/shop_detail.ejs').then((response) => {
                this.shopDetailTemplate = response.data
            })
            return this.shopDetailTemplate
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
        })
    }

    searchPosition() {
        const map = this.map;
        const distanceElement = document.querySelector('.distance-option-list > .selected')
        const distance = distanceElement
        const input = document.getElementById('pac-input');
        const searchBox = new google.maps.places.SearchBox(input);
        map.controls[google.maps.ControlPosition.TOP_LEFT].push(input);

        // Bias the SearchBox results towards current map's viewport.
        map.addListener('bounds_changed', () => {
            searchBox.setBounds(map.getBounds());
        });

        // TODO: on map 'zoom_changed', then change markers!
        map.addListener('zoom_changed', () => {
            if (map.zoom > 16) {
                // 건물수준(좁게보기)
                this.markers.forEach((marker) => {
                    marker.setIcon('https://maps.google.com/mapfiles/kml/shapes/parking_lot_maps.png')
                    // TODO: 아이콘 업데이트
                })
            } else {
                // 도로 구 수준(넓게보기)
                this.markers.forEach((marker) => {
                    marker.setIcon('https://maps.google.com/mapfiles/kml/shapes/info-i_maps.png')
                })
            }
        })

        // Listen for the event fired when the user selects a prediction and retrieve
        // more details for that place.
        searchBox.addListener('places_changed', () => {
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
            this.reloadMap(distance, pos, this.data, 'distance')
        });
    }

    setShopMarker(arr) {
        this.markers.forEach((i) => {
            i.setMap(null)
        })
        this.markers = []

        arr.forEach((e) => {
            const position = {"lat": e.location.latitude, "lng": e.location.longitude}
            const marker = new google.maps.Marker({
                position: position,
                map: this.map,
                shopNumber: e.shopNumber,
                icon: 'https://maps.google.com/mapfiles/kml/shapes/info-i_maps.png'
                // TODO: 기본 아이콘 변경
            })
            marker.addListener('click', async () => {
                while (!this.shopDetailTemplate) {
                    await this.sleep(200)
                }
                const infowindow = new google.maps.InfoWindow({
                    content: _.template(this.shopDetailTemplate)(e) // TODO: 여기에 template rendering 넣어주기
                });
                if (this.infowindow) {
                    this.infowindow.close();
                }
                this.map.setCenter(marker.getPosition());
                infowindow.open(map, marker);
                this.infowindow = infowindow;
                //리스트 연동부분
                if (document.querySelector(".selected-shop")){
                    document.querySelector(".selected-shop").classList.remove("selected-shop");
                }
                document.querySelector(".shop-list").scrollTop += document.getElementById(e.shopNumber).getBoundingClientRect().top - 50;
                document.getElementById(e.shopNumber).childNodes[1].classList.add("selected-shop");
            });
            this.markers.push(marker)
        });
    }

    reloadMap(distance, pos, apidata, key, order, categoryList) {
        // Reset markers
        for (let i of this.markers) {
            i.setMap(null)
        }
        this.markers = []

        // Update my Position
        this.updatePosition(pos)

        // if starPointAverage: reverse
        if (key === 'distance') {
            order = 'asc'
        } else {
            order = 'desc'
        }

        // Get new data from my new position
        apidata.getShopData(pos)
        let sortedData = null
        if (categoryList) {
            sortedData = apidata.getShopListByCategoryList(distance, categoryList, key, order)
        } else {
            sortedData = apidata.getShopListAll(distance, key, order)
        }
        sortedData.then((filteredData) => {
            new ShopList("#shopList", filteredData)
            this.setShopMarker(filteredData)
        })
    }
}

export default Map
