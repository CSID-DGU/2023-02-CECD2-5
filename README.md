# 2023-02-CECD2-5
23-02, 컴퓨터공학종합설계2, 정준호 교수님, 남기운 팀

## VeggieHunter
![image](https://github.com/user-attachments/assets/f08a1428-be42-4736-9733-52af8d6a79be)


---

## 개발팀

|      윤대현       |          하경한         |                                                                                                              
| :------------------------------------------------------------------------------: | :---------------------------------------------------------------------------------------------------------------------------------------------------: |
|   <img src="https://github.com/CSID-DGU/2023-02-CECD2-5/assets/71585151/48d6532d-b6ce-4647-a59f-50b6cc13f442" width="150">    |                      <img src="https://github.com/CSID-DGU/2023-02-CECD2-5/assets/71585151/b4b05178-1680-4407-97ff-57c11009a36f" width="150">    |
|   [@DaehyunYun](https://github.com/eogus0512)   |    [@KyeonghanHa](https://github.com/khanz0613)  |
| 동국대학교 컴퓨터공학과 4학년 | 동국대학교 컴퓨터공학과 4학년 |
| Back-End | Front-End |

---

## 프로젝트 소개
채소의 최저가 및 레시피 정보를 활용하여 사용자에게 가치 있는 서비스를 제공하는 모바일 어플리케이션을 개발한다. 사용자는 모바일 앱을 통해 다양한 채소의 최저가 정보를 실시간으로 확인할 수 있으며, 최근 거래의 최저가 추이도 파악할 수 있다. 이를 통해 사용자는 저렴한 가격으로 채소를 구매할 수 있어 경제적인 이점을 얻을 수 있다. 또한, 다양한 채소를 활용한 레시피도 제공되어 사용자는 다양한 요리를 즐기며 건강한 식단을 구성할 수 있다. 이를 통해 사용자들은 경제적인 소비를 할 수 있으며, 채소의 최저가 정보를 더 쉽게 접근할 수 있게 된다. 또한, 식사의 다양성을 증가시키고 건강한 식습관을 형성할 수 있는 도움을 받을 수 있다. 더불어 최저가 하락 시 알림 서비스를 제공하여 사용자는 시간을 절약하고 적정한 시점에 구매할 수 있다. 이 프로젝트는 사용자들이 경제적으로 효율적인 소비를 할 수 있도록 도와주고, 건강한 식습관을 유지하며, 시장 정보를 제공하여 소비자들에게 알 권리를 보장하는 것을 목표로 한다.

---

## 시스템 구성도
![image](https://github.com/CSID-DGU/2023-02-CECD2-5/assets/71585151/6c2d681e-9812-49f0-bd98-2c35001308f5)

---
## 기술 스택

### Front-End
<img src="https://img.shields.io/badge/flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white">           

### Back-End
<p>
  <img src="https://img.shields.io/badge/spring-6DB33F?style=for-the-badge&logo=spring&logoColor=white"> 
<img src="https://img.shields.io/badge/mysql-4479A1?style=for-the-badge&logo=mysql&logoColor=white"> 
<img src="https://img.shields.io/badge/JPA-6DB33F?style=for-the-badge&logo=spring&logoColor=white">
<img src="https://img.shields.io/badge/QueryDSL-FF6200?style=for-the-badge&logo=java&logoColor=white">
<img src="https://img.shields.io/badge/amazonaws-232F3E?style=for-the-badge&logo=amazonaws&logoColor=white">     
</p>

---

## 화면 구성

| 최저가 정보 |  레시피 공유 |
| :-------------------------------------------: | :-------------------------------------------: |
| <img width="329" src="https://github.com/CSID-DGU/2023-02-CECD2-5/assets/71585151/18fc39b6-62bb-4aeb-915c-c77bd38be0b7"/> |  <img width="329" src="https://github.com/CSID-DGU/2023-02-CECD2-5/assets/71585151/d3cfdd1c-7f85-4caf-b951-c2a42daca33d"/> |  
| 좋아요 및 알림   |
| <img width="329" src="https://github.com/CSID-DGU/2023-02-CECD2-5/assets/71585151/cc216670-d650-45e9-9e30-e67c5c716607"/>   |

---
## 주요 기능 

### ⭐️ 데이터 수집
- OpenAPI, 웹 크롤링을 통해 채소 최저가 정보를 하루에 한 번 수집하여 최저가 정보가 최신화 되도록 함
- 여러 방식의 데이터 수집으로 데이터의 객관성을 확보
- 비정형화된 웹사이트에서도 데이터를 수집 가능하게 하여 추후 데이터셋의 용이한 확장 가능

### ⭐️ 최저가 정보 제공 기능
- 사용자는 채소 가격과 관련된 정보와 채소에 대한 정보를 제공받아 적절한 가격과 품질의 채소를 선택하여 구매
- 최저가 추이 그래프를 시각화하여 제공함으로써 사용자는 최저가의 변동성을 파악하고, 가격의 추이를 분석하여 현재 가격대의 정보를 파악

### ⭐️ 레시피 공유 기능
- 다양한 채소를 활용한 레시피를 공유함으로써 다양한 식습관을 형성시키고, 여러가지 레시피를 제공

### ⭐️ 좋아요 및 알림 기능
- 사용자가 관심있는 채소의 최저가 하락 시 알림 생성을 통해 정보를 제공하여 보다 저렴한 가겨으로 채소를 구매
