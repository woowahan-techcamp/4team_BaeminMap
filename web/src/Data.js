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
            console.log(e)
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

    //op는 정렬 조건
    sortList(arr, op) {
        let listArr = [];

        //조건을 담은 오브젝트 선언한 후 파라미터로 받은 op 값으로 조건방식을 결정
        const sortOptionObj = {0: "distance", 1: "oderCount", 2: "starPointAverage", 3: "viewCount", 4: "favoriteCount"}
        const sortOption = sortOptionObj[op]

        //필터링하여 받아온 어레이를 요소로 가진 어레이들을 우선 합침
        arr.forEach((e) => {
            listArr = listArr.concat(e)
        })

        //distance의 경우는 낮은 것이 먼저, 나머지는 높은 것이 먼저 정렬되야하기 때문에 각각의 함수 선언
        function sortDownTop(arr) {
            arr.sort((a, b) => {
                if (a[sortOption] > b[sortOption]) {
                    return 1;
                }
                if (a[sortOption] < b[sortOption]) {
                    return -1;
                }
                return 0;
            })
        }

        function sortTopDown(arr) {
            arr.sort((a, b) => {
                if (a[sortOption] < b[sortOption]) {
                    return 1;
                }
                if (a[sortOption] > b[sortOption]) {
                    return -1;
                }
                return 0;
            })
        }

        //top to down, down to top 방식에 따라서 다르게 함수 호출하는 분기문
        if (op === 0) {
            sortDownTop(listArr)
        } else {
            sortTopDown(listArr)
        }

        return listArr;

    }
}

export default Data