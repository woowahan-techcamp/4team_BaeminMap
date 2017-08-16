class ShopDetail {
    constructor(obj) {
        console.log('ShopDetail init!')
        return this.asyncRenderTempalte(obj)
    }

    asyncRenderTempalte(obj) {
        return axios.get('/src/templates/shop_detail.ejs').then((response) => {
            return _.template(response.data)(obj)
        })
    }
}

export default ShopDetail