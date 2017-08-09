import ShopList from './ShopList'
//
// axios.get("../data.json")
//     .then(function (response) {
//         new ShopList('#shopListTemplate', '#shopList', response.data)
//     })

//Data 클래스 getShopList 프로토타입
axios.get("../data.json")
    .then(function (response) {
        const dummyData = response.data.content;
        newMap.setShopMarker(dummyData);
        return response
    }).then(function (response) {
    new ShopList('#shopListTemplate', '#shopList', response.data)
    })

class Map {
    constructor() {
        this.map;
        this.currentLocation = {lat: 37.5759879, lng: 126.9769229};
        this.loadPosition();
        this.initMap();
        this.searchPosition();
    }

    loadPosition() {
        navigator.geolocation.getCurrentPosition((position) => {
            const pos = {
                lat: position.coords.latitude,
                lng: position.coords.longitude
            };

            this.currentLocation = pos;

            this.setUserMarker();

            // infoWindow.setPosition(pos);
            // infoWindow.setContent('Location found.');
            this.map.setCenter(pos);
        }, () => {
            handleLocationError(true, infoWindow, this.map.getCenter());
        });
    }

    initMap() {
        this.map = new google.maps.Map(document.getElementById('map'), {
            zoom: 15,
            center: this.currentLocation
        });
    }

    setUserMarker() {
        new google.maps.Marker({
            position: this.currentLocation,
            map: this.map,
            title: "my location",
        })
    }

    searchPosition() {
        const map = this.map;
        const input = document.getElementById('pac-input');
        const searchBox = new google.maps.places.SearchBox(input);
        this.map.controls[google.maps.ControlPosition.TOP_LEFT].push(input);

        // Bias the SearchBox results towards current map's viewport.
        this.map.addListener('bounds_changed', () => {
            searchBox.setBounds(this.map.getBounds());
        });

        let markers = [];
        // Listen for the event fired when the user selects a prediction and retrieve
        // more details for that place.
        searchBox.addListener('places_changed', function () {
            const places = searchBox.getPlaces();

            if (places.length === 0) {
                return;
            }

            // Clear out the old markers.
            markers.forEach(function (marker) {
                marker.setMap(null);
            });
            markers = [];

            // For each place, get the icon, name and location.
            const bounds = new google.maps.LatLngBounds();
            places.forEach(function (place) {
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
                markers.push(new google.maps.Marker({
                    map: map,
                    icon: icon,
                    title: place.name,
                    position: place.geometry.location
                }));

                if (place.geometry.viewport) {
                    // Only geocodes have viewport.
                    bounds.union(place.geometry.viewport);
                } else {
                    bounds.extend(place.geometry.location);
                }
            });
            map.fitBounds(bounds);
        });
    }

    setShopMarker(arr) {
        arr.forEach((e) => {
            new google.maps.Marker({
                position: {"lat": e.location.latitude, "lng": e.location.longitude},
                map: this.map
            });
        });
    }
}

const newMap = new Map();
