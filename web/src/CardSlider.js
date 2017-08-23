class CardSlider {
    constructor (viewPort, sliderWrapper) {
        this.viewPort = viewPort
        this.sliderWrapper = sliderWrapper
        this.firstXPosition = 0
        this.currentWrapperPosition = 0
        this.setEventListener()
    }

    setFirstXPosition (xPosition) {
        this.firstXPosition = xPosition
    }

    getDistance(xPosition) {
        return xPosition - this.firstXPosition
    }

    moveSliderWrapper(movingPixel) {
        this.sliderWrapper.style.transform = `translateX(${movingPixel}px)`
    }

    setEventListener() {
        this.viewPort.addEventListener('touchstart', e => {
            e.preventDefault()
            this.currentWrapperPosition = 0 || Number(this.sliderWrapper.style.transform.replace('translateX(', '').replace('px)', ''))
            const newPosition = e.changedTouches[0].screenX
            this.setFirstXPosition(newPosition)
        })
        this.viewPort.addEventListener('touchmove', e => {
            e.preventDefault()
            this.sliderWrapper.style.transition = null
            const newPixel = e.changedTouches[0].screenX
            this.moveSliderWrapper(
                this.currentWrapperPosition + this.getDistance(newPixel)
            )
        })
        this.viewPort.addEventListener('touchend', e => {
            const windowWidth = parseInt(window.innerWidth)
            const distance = this.getDistance(e.changedTouches[0].screenX)
            const maxPosition = -(window.innerWidth * (this.sliderWrapper.children.length))
            console.log(maxPosition)
            let newWrapperPosition = 0

            this.sliderWrapper.style.transition = 'ease 0.5s'

            if ((Math.abs(distance)) > (windowWidth / 10)){
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
        })
    }
}

export default CardSlider

//const slider = new CardSlider(document.querySelector('#viewPort'), document.querySelector('#sliderWrapper'))