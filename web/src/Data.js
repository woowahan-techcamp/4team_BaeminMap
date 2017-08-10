import ShopList from "./ShopList"

class Data {
    constructor() {
        this.apiBaseUrl = "http://baemin-front-api.ap-northeast-2.elasticbeanstalk.com/"
        this.categoryArr = [1, 2, 3, 4, 5, 6, 7, 9, 10, 32, 33];
        this.shopListObj = {content: []};
    }

    getShopList(arr, loc, token) {
        const location = loc;
        let countNo = 0;
        const iterCall = []
        for (const e of arr) {
            iterCall.push(
                axios({
                    method: 'post',
                    url: this.apiBaseUrl + "v2/shops",
                    headers: {
                        'Authorization': "Bearer " + token,
                        'Content-Type': 'application/json; charset=utf-8'
                    },
                    params: {
                        size: '10'
                    },
                    data: {
                        "lat": location.lat,
                        "lng": location.lng,
                        "category": e
                    }
                })
            )
        }
        return axios.all(iterCall).then(axios.spread(function (...resultList) {
            const someList = []
            for (const i of resultList) {
                console.log(i.data.content)
                someList.push(i.data.content)
            }
            return someList
        }))
    }
}

export default Data