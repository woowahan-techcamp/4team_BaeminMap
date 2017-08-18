class ShopDetail {
    asyncRenderTempalte(obj) {
        return axios.get('/src/templates/shop_detail.ejs').then((response) => {
            return _.template(response.data)(obj)
        })
    }
}

export default ShopDetail