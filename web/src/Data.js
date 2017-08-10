import ShopList from "./ShopList"

class Data {
    constructor(){
        this.baseUrl = "http://localhost:8080/";
        this.tokenUrl = "http://auth-beta.baemin.com/oauth/authorize?response_type=token&redirect_uri=http://localhost:8080&client_id=techCampTeamB&scope=read";
        this.apiToken = "";
        this.checkToken();
        this.apiBaseUrl="http://baemin-front-api.ap-northeast-2.elasticbeanstalk.com/"
        this.categoryArr = [1, 2, 3, 4, 5, 6, 7, 9, 10, 32, 33];
        this.shopListObj = {content: []};
    }
    checkToken(){
        console.log("checkToken")
        if (document.location.href === this.baseUrl){
            this.redirectPage(this.tokenUrl)
        }else{
            this.getToken()
        }
    }
    redirectPage(url){
        if(this.apiToken == '') {
            location.href = url
        }
    }
    getToken(){
        this.apiToken = location.href.split("#access_token=")[1].split("&")[0];
        console.log(this.apiToken)
    }
    getShopList(arr, loc){
        const location = loc;
        let countNo = 0;
        arr.forEach((e)=>{
            console.log(e);
            axios({
                method: 'post',
                url: this.apiBaseUrl + "v2/shops",
                headers: {
                    'Authorization': "Bearer " + this.apiToken,
                    'Content-Type':'application/json; charset=utf-8'
                },
                params: {
                    size: '10'
                },
                data: {
                    "lat": location.lat,
                    "lng": location.lng,
                    "category": e
                }
            })
                .then((response)=>{
                    countNo += 1;
                    this.shopListObj.content = this.shopListObj.content.concat(response.data.content);
                    if (countNo === arr.length){
                        new ShopList('#shopListTemplate', '#shopList', this.shopListObj);
                    }
                })
        })
    }
}

export default Data