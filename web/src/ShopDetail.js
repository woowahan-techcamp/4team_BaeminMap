class ShopDetail {
    constructor(targetSelector, arr) {
        console.log('ShopDetail init!')
        this.createShopTemplateDOM(targetSelector, arr)
    }

    createShopTemplateDOM(targetSelector, arr) {
        axios.get('/src/templates/shop_detail.ejs').then((response) => {
            const shopTemplate = _.template(response.data)
            this.renderTemplate(shopTemplate, targetSelector, arr)
        })
    }

    renderTemplate(shopTemplate, targetSelector, arr) {
        document.querySelector(targetSelector).innerHTML = shopTemplate({data: arr})
    }
}

export default ShopDetail