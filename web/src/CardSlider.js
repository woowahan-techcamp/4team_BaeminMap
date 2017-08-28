import ShopList from './ShopList'

class CardSlider {
    constructor(sliderObj) {
        this.card = sliderObj.card
        this.sliderWrapper = sliderObj.sliderWrapper
        this.firstXPosition = 0
        this.currentWrapperPosition = 0
        this.setEventListener()
        this.triggerMarkerEvent = sliderObj.triggerMarkerEvent
        this.markers = sliderObj.markers
        this.dragged = false
        this.showModal = sliderObj.showModal
        this.shopData = sliderObj.shopData
        this.mapInstance = sliderObj.mapInstance
    }

    setFirstXPosition(xPosition) {
        this.firstXPosition = xPosition
    }

    getChangedTouchDistance(xPosition) {
        return xPosition - this.firstXPosition
    }

    moveSliderWrapper(movingPixel) {
        this.sliderWrapper.style.transform = `translateX(${movingPixel}px)`
    }

    addTouchStartEvent(card) {
        card.addEventListener('touchstart', shopData => {
            shopData.preventDefault()
            this.currentWrapperPosition = 0 || Number(this.sliderWrapper.style.transform.replace('translateX(', '').replace('px)', ''))
            const newPosition = shopData.changedTouches[0].screenX
            this.setFirstXPosition(newPosition)
            this.dragged = false
        })
    }

    addTouchMoveEvent(card) {
        card.addEventListener('touchmove', shopData => {
            shopData.preventDefault()
            this.sliderWrapper.style.transition = null
            const newPixel = shopData.changedTouches[0].screenX
            this.moveSliderWrapper(
                this.currentWrapperPosition + this.getChangedTouchDistance(newPixel)
            )
            this.dragged = true
        })
    }

    smoothCardMoveEnding(shopData) {
        // 드래그
        console.log("Touched!")
        const windowWidth = parseInt(window.innerWidth)
        const distance = this.getChangedTouchDistance(shopData.changedTouches[0].screenX)
        const maxPosition = -(window.innerWidth * (this.sliderWrapper.children.length))
        let newWrapperPosition = 0

        this.sliderWrapper.style.transition = 'ease 0.5s'

        if ((Math.abs(distance)) > (windowWidth / 10)) {
            if (distance < 0) {
                newWrapperPosition = this.currentWrapperPosition - windowWidth
            } else if (distance > 0) {
                newWrapperPosition = this.currentWrapperPosition + windowWidth
            }
            if ((newWrapperPosition > 0) || (newWrapperPosition <= maxPosition)) {
                this.sliderWrapper.style.transform = `translateX(${this.currentWrapperPosition}px)`
                return false
            }
            this.sliderWrapper.style.transform = `translateX(${newWrapperPosition}px)`
        } else {
            this.sliderWrapper.style.transform = `translateX(${this.currentWrapperPosition}px)`
        }
        this.dragged = false
    }

    showModalOnClick(shopData) {
        // 클릭
        const shopNumber = shopData.target.dataset.shopnumber;
        this.mapInstance.showModal(shopNumber)
    }

    updateMarkerByCategoryname(shopData) {
        const targetMarker = ShopList.searchTargetMarker(shopData.target.dataset.shopnumber, this.mapInstance.markers)
        // FIXME: 넘겨진 후에 화면에 나오는 타겟...
        const divInCardTransition = parseInt(
            document.querySelector('#card > div').style.transform
                .replace('translateX(', '')
                .replace(')', '')
        )
        const idx = -divInCardTransition / window.innerWidth
        const categoryEnglishName = Array.prototype.slice.call(
            document.querySelectorAll('#card a.shop-layer')
        )[idx].dataset.categoryenglishname
        ShopList.updateMarker(
            targetMarker,
            categoryEnglishName
        )
    }

    addTouchEndEvent(card) {
        card.addEventListener('touchend', shopData => {
            if (this.dragged) {
                this.smoothCardMoveEnding(shopData)
            } else {
                this.showModalOnClick(shopData)
            }
            this.updateMarkerByCategoryname(shopData)
        })
    }

    setEventListener() {
        this.addTouchStartEvent(this.card)
        this.addTouchMoveEvent(this.card)
        this.addTouchEndEvent(this.card)
    }
}

export default CardSlider
