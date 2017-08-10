class ShopList {
    constructor(templateSelector, targetSelector, arr) {
        console.log('ShopList init!')
        this.createShopTemplateDOM(templateSelector, targetSelector, arr)
    }

    createShopTemplateDOM(templateSelector, targetSelector, arr) {
        axios.get('/src/templates/shop_list.ejs').then((response) => {
            const shopTemplate = _.template(response.data)
            this.renderTemplate(shopTemplate, targetSelector, arr)
        })
    }

    renderTemplate(shopTemplate, targetSelector, arr) {
        document.querySelector(targetSelector).innerHTML = shopTemplate({data: arr})
    }
}

export default ShopList