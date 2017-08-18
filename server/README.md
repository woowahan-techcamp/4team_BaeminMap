# 배민여지도 Server
1. 모든 업소 조회
```
URL: http://baeminmap.testi.kr/shops
HTTP 메소드: POST
body: { lat: 위도좌표,
        lng: 경도좌표 }
응답결과: { shops: { 카테고리Id: [업소목록] },
          shopArray: [전체카테고리 업소목록] }
```

2. 업소 메뉴 조회
```
URL: http://baeminmap.testi.kr/menu/:shopNo
HTTP 메소드: GET
응답결과: { 메뉴이름: [음식정보] }
```
