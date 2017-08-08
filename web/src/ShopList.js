class ShopList {
    constructor(templateSelector, targetSelector, json) {
        this.templateElement = document.querySelector(templateSelector) // #shopListTemplate
        this.targetElement = document.querySelector(targetSelector) // #shopList

        this.createShopTemplateDOM(this.templateElement)

        this.template = _.template(this.templateElement.innerHTML)
        this.renderTemplate(this.template, this.targetElement, json)
    }

    createShopTemplateDOM(templateElement) {
        axios.get('/src/templates/shop_list.ejs').then((response) => {
            templateElement.innerHTML = response.data
        })
    }

    renderTemplate(template, targetElement, json) {
        console.log('wowwowowowowowowowowowo')
        console.log(template(json))
        targetElement.innerHTML = template(json)
    }
}

export default ShopList