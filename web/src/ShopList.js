class ShopList {
    constructor(templateSelector, targetSelector, json) {
        console.log('ShopList init!')
        this.createShopTemplateDOM(templateSelector, targetSelector, json)
    }

    createShopTemplateDOM(templateSelector, targetSelector, json) {
        axios.get('/src/templates/shop_list.ejs').then((response) => {
            const shopTemplate = _.template(response.data)
            this.renderTemplate(shopTemplate, targetSelector, json)
        })
    }

    renderTemplate(shopTemplate, targetSelector, json) {
        document.querySelector(targetSelector).innerHTML = shopTemplate({data: json.content})
    }
}

export default ShopList