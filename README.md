# 4team_BaeminMap

# 규칙
### 공통
    - 의견을 제시, 반박 할때 시작어로 '내 생각에는'을 붙인 후 의견을 말한다.
    - 주 계획은 매주 월요일 12시에 카페테리아에서 진행한다.
    - 계획 된 주 계획은 이슈로 등록하고 담당자를 등록한다.
      등록된 이슈를 projects의 주 계획으로 이동하고 일 단위로 관리, 완료시 Done으로 이동한다.
      완료된 이슈는 commit시에 close 한다.
    - 매일 오전 출근 후 20분(한사람당 5분) 스크럼 진행한다.
    - 스크럼 내용은, 컨디션 공유 및 작업현황 공유, 이슈 공유, 금일 기능 분배 등을 진행한다.
    - 매주 금요일 회고 이후 간단히 전체적인 코드리뷰를 통해 진행 과정을 공유한다.
    - 일정 관리, 이슈등은 백로그를 참고하여 github issues와 projects를 적극 활용한다.
    - commit 메세지는 한글로 자세히 작성한다.
    - commit은 최대한 자주 남긴다.
    - iOS, web 브랜치를 만들어서 develop 브랜치로 사용한다.
    - 개발 전 remote와 working directory 동기화 하고 작업한다.
    - 모든 브랜치의 merge는 pullrequest로 merge한다.
    - 의사결정 과정에서 의견취합이 되지 않을경우 1차적으로 검증을 통해서 더 나은 방법을 모색한다.
      1차에서 해결이 되지 않을 경우 마스터님이나 멘토님등께 더 나은방법에 대한 조언을 구한다.

  ### web
    - UITest는 circle로 자동화한다.
    - web(develop) 브랜치 하위에 기능 단위로 브랜치 관리한다.
    - ES6 기준으로 개발한다.
    - 코딩 스타일은 airbnb 스타일로 작성한다.
    - lodash, less, axios 모듈을 사용하여 개발한다.

  ### iOS
    - 뷰 & 클래스 단위로 브랜치를 나누고 기능 단위로 하위 브랜치를 만든다.
    - 기능이 완료 되면 해당 뷰 브랜치로 pullrequest merge 후 기능 브랜치는 삭제한다.
      기능브랜치의 삭제를 원하지 않는경우 미리 이야기 한다.
    - 코딩 규칙은 K&R스타일로 맞춘다. 탭O 띄어쓰기X, 함수나 클로저의 줄이 긴 경우 줄바꿈하지 않는다.
      dictionary는 ':' 사이를 띄우지 않는다. ex) [String:String]
    - 변수명은 축약형을 사용하지 않는다.
    - 파일명은 클래스 명과 동일하게 한다.
---
# 기획서
- [Google 문서](https://docs.google.com/document/d/1WAT5xkSDr-LvTCLTp7MJRYEJbZgMsyBSzyi07-YOsQA/edit?usp=sharing)

# 스토리보드
- [iOS & Mobile](https://docs.google.com/presentation/d/1Gw1ursfpTca28Ib97MUFmRIOb0I1qBbM5ryuIA9vCiw/edit?usp=sharing)
- [web](https://docs.google.com/presentation/d/1QcIKBtjaqgBzYIcEnxbH3GaTTMNGf6UTu97gnXv6Z28/edit?usp=sharing)

# 백로그
- [iOS_Google 스프레드시트](https://docs.google.com/spreadsheets/d/1cBuBluV8Ds3fE61OSWCZAVAnRzbZtrp6WuZbKUCsLNI/edit?usp=sharing)

- [web_Google 스프레드시트](https://docs.google.com/spreadsheets/d/1QoMUIPgBfG1T5SrNwBYFIXVt6uVZWjoIUOLorSFcvIw/edit?usp=sharing)
