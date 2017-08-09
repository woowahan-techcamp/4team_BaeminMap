import ShopList from "./ShopList"

class Data {
    constructor(){
        this.baseUrl = "http://localhost:8080/";
        this.tokenUrl = "http://auth-beta.baemin.com/oauth/authorize?response_type=token&redirect_uri=http://localhost:8080&client_id=techCampTeamB&scope=read";
        this.apiToken = "";
        this.checkToken();
        this.apiBaseUrl="http://baemin-front-api.ap-northeast-2.elasticbeanstalk.com/"
        this.categoryArr = [1, 2, 3, 4, 5, 6, 7, 9, 10, 32, 33];
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
        const location = {"lat": 37.500465,"lng": 127.1165};
        arr.forEach((e)=>{
            console.log(e)
            console.log()
            axios({
                method: 'post',
                url: this.apiBaseUrl + "v2/shops",
                headers: {
                    'Authorization': "Bearer " + this.apiToken,
                    'Content-Type':'application/json; charset=utf-8'
                },
                params: {
                    size: '50'
                },
                data: {
                    "lat": 37.500465,"lng": 127.1165,
                    "category": e
                }
            })
                .then(function(response){
                    console.log("주변 배달업소를 조회한다(v2/shops)")
                    console.log(response)
                    const shopArr = response.data;
                    new ShopList('#shopListTemplate', '#shopList', shopArr);
                })
        })
    }
}

export default Data