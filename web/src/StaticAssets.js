export default class StaticAssets {
    constructor() {
        this.urls = {
            chicken: "/static/WebMarker/chicken.png",
            chickenFill: "/static/WebMarker/chickenFill.png",
            Chinese: "/static/WebMarker/Chinese.png",
            ChineseFill: "/static/WebMarker/ChineseFill.png",
            Dosirak: "/static/WebMarker/Dosirak.png",
            DosirakFill: "/static/WebMarker/DosirakFill.png",
            fastFood: "/static/WebMarker/fastFood.png",
            fastFoodFill: "/static/WebMarker/fastFoodFill.png",
            Japanese: "/static/WebMarker/Japanese.png",
            JapaneseFill: "/static/WebMarker/JapaneseFill.png",
            Jokbal: "/static/WebMarker/Jokbal.png",
            JokbalFill: "/static/WebMarker/JokbalFill.png",
            Korean: "/static/WebMarker/Korean.png",
            KoreanFill: "/static/WebMarker/KoreanFill.png",
            NightSnack: "/static/WebMarker/NightSnack.png",
            NightSnackFill: "/static/WebMarker/NightSnackFill.png",
            pizza: "/static/WebMarker/pizza.png",
            pizzaFill: "/static/WebMarker/pizzaFill.png",
            plusMarker: "/static/WebMarker/plusMarker.png",
            plusMarkerFill: "/static/WebMarker/plusMarkerFill.png",
            Snack: "/static/WebMarker/Snack.png",
            SnackFill: "/static/WebMarker/SnackFill.png",
            Zzim_Tang: "/static/WebMarker/Zzim_Tang.png",
            Zzim_TangFill: "/static/WebMarker/Zzim_TangFill.png"
        }
        this.makeImgObject(this, this.urls)
    }

    makeImgObject(instance, urls) {
        // get urls and add Image object to instance
        Object.entries(urls)
            .forEach(([key, value]) => {
                instance['img' + key] = new Image().src = value
            })
    }
}