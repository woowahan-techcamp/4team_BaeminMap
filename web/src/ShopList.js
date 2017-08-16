class ShopList {
    constructor(targetSelector, arr) {
        console.log('ShopList init!')
        this.createShopTemplateDOM(targetSelector, arr)
    }

    createShopTemplateDOM(targetSelector, arr) {
        axios.get('/src/templates/shop_list.ejs').then((response) => {
            const shopTemplate = _.template(response.data)
            this.renderTemplate(shopTemplate, targetSelector, arr)
        })
    }

    renderTemplate(shopTemplate, targetSelector, arr) {
        const targetElement = document.querySelector(targetSelector)
        targetElement.innerHTML = shopTemplate({data: arr})
        targetElement.addEventListener('click', (e) => {
            e.preventDefault()
            if (!e.target.matches('div.shop')) {
                return false
            }
            // TODO: 상점 리스트 클릭시 마커 띄워주기
        })
    }
}

export default ShopList