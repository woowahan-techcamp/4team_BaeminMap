import axios from 'axios'

export default class ApiData {
    constructor() {
        this.baseURL = "http://baeminmap.testi.kr"
        this.getShopURL = this.baseURL + "/shops"
        this.init()
    }

    init() {
        this.data = null
        this.position = {
            lat: '37.5169697',
            lng: '127.1137412'
        }
        this.getShopData(this.position)
    }

    sleep(ms) {
        return new Promise(resolve => setTimeout(resolve, ms));
    }

    async getShopData(position) {
        this.data = null
        const response = await axios.post(
            this.getShopURL,
            position
        )
        this.data = response.data
    }

    async getShopListAll() {
        while (!this.data) {
            await this.sleep(200)
        }
        console.log(this.data.shopArray)
    }

    async getShopListByCategoryList(categoryList, key, order) {
        while (!this.data) {
            await this.sleep(200)
        }
        const _list = []
        for (const i of categoryList) {
            for (const j of this.data.shops[i]) {
                _list.push(j)
            }
        }
        const result = _list.sort(this.compareValues(key, order))
        console.log(result)
        return result
    }

    compareValues(key, order = 'asc') {
        return function (a, b) {
            if (!a.hasOwnProperty(key) ||
                !b.hasOwnProperty(key)) {
                return 0;
            }

            const varA = a[key]
            const varB = b[key]

            let comparison = 0;
            if (varA > varB) {
                comparison = 1;
            } else if (varA < varB) {
                comparison = -1;
            }
            return (
                (order === 'desc') ?
                    (comparison * -1) : comparison
            );
        };
    }
}
