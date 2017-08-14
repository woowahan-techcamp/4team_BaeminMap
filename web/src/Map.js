import ShopDetail from './ShopDetail'
import ShopList from './ShopList'

class Map {
    constructor(data, token) {
        this.infowindow;
        this.currentLocation = {lat: 37.5759879, lng: 126.9769229};
        this.map = new google.maps.Map(document.getElementById('map'), {
            zoom: 15,
            center: this.currentLocation
        });
        this.searchPosition();
        this.data = data
        this.token = token
        this.markers = []
    }

    updatePosition(position) {
        this.setUserMarker(position)
        this.map.setCenter(position);
        this.currentLocation = position
    }

    setUserMarker(position) {
        new google.maps.Marker({
            position: position,
            map: this.map,
            title: "my location",
        })
    }

    searchPosition() {
        const map = this.map;
        const input = document.getElementById('pac-input');
        const searchBox = new google.maps.places.SearchBox(input);
        map.controls[google.maps.ControlPosition.TOP_LEFT].push(input);

        // Bias the SearchBox results towards current map's viewport.
        map.addListener('bounds_changed', () => {
            searchBox.setBounds(map.getBounds());
        });

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
                const icon = {
                    url: place.icon,
                    size: new google.maps.Size(71, 71),
                    origin: new google.maps.Point(0, 0),
                    anchor: new google.maps.Point(17, 34),
                    scaledSize: new google.maps.Size(25, 25)
                };

                // Create a marker for each place.
                // this.markers.push(new google.maps.Marker({
                //     map: map,
                //     icon: icon,
                //     title: place.name,
                //     position: place.geometry.location
                // }));

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
            this.reloadMap(pos, this.data, this.token)
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
                map: this.map
            })
            const infowindow = new google.maps.InfoWindow({
                content: '' //new ShopDetail(obj) // TODO: 여기에 template rendering 넣어주기
            });
            marker.addListener('click', () => {
                if (this.infowindow) {
                    this.infowindow.close();
                }
                this.map.setCenter(marker.getPosition());
                infowindow.open(map, marker);
                this.infowindow = infowindow
            });
            this.markers.push(marker)
        });
    }

    reloadMap(pos, data, token) {
        console.log('markers: ',this.markers)
        for (let i of this.markers) {
            i.setMap(null)
        }
        this.markers = []
        this.updatePosition(pos)
        data.getShopList(data.categoryArr, pos, token).then((arr) => {
            //필터 로직 들어갈 부분. 필터 이후 소트를 한다.
            return data.sortList(arr, 0);
        }).then((filteredData) => {
            new ShopList("#shopListTemplate", "#shopList", filteredData)
            this.setShopMarker(filteredData)
        })
    }
}

export default Map