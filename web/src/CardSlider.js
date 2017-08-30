import ShopList from './ShopList'

class CardSlider {
    constructor(card, sliderWrapper, triggerMarkerEvent, markers, showModal, e, map) {
        this.card = card
        this.sliderWrapper = sliderWrapper
        this.firstXPosition = 0
        this.currentWrapperPosition = 0
        this.setEventListener()
        this.triggerMarkerEvent = triggerMarkerEvent
        this.markers = markers
        this.dragged = false
        this.showModal = showModal
        this.e = e
        this.map = map
    }

    setFirstXPosition(xPosition) {
        this.firstXPosition = xPosition
    }

    getDistance(xPosition) {
        return xPosition - this.firstXPosition
    }

    moveSliderWrapper(movingPixel) {
        this.sliderWrapper.style.transform = `translateX(${movingPixel}px)`
    }

    setEventListener() {
        this.card.addEventListener('touchstart', e => {
            e.preventDefault()
            this.currentWrapperPosition = 0 || Number(this.sliderWrapper.style.transform.replace('translateX(', '').replace('px)', ''))
            const newPosition = e.changedTouches[0].screenX
            this.setFirstXPosition(newPosition)
            this.dragged = false
        })
        this.card.addEventListener('touchmove', e => {
            e.preventDefault()
            this.sliderWrapper.style.transition = null
            const newPixel = e.changedTouches[0].screenX
            this.moveSliderWrapper(
                this.currentWrapperPosition + this.getDistance(newPixel)
            )
            this.dragged = true
        })
        this.card.addEventListener('touchend', e => {
            if (this.dragged) {
                // 드래그
                console.log("Touched!")
                const windowWidth = parseInt(window.innerWidth)
                const distance = this.getDistance(e.changedTouches[0].screenX)
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
            } else {
                // 클릭
                const shopNumber = e.target.dataset.shopnumber;
                this.map.showModal(shopNumber)
            }
            const targetMarker = ShopList.searchTargetMarker(e.target.dataset.shopnumber, this.map.markers)
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
            console.log(categoryEnglishName)
        })
    }
}

export default CardSlider
