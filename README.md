# chatgpt_project

>요즘 핫한 ChatGPT를 가지고 나만의 어플을 만들어 보았다. <br>
현재 구글플레이스토어에 있는 ChatGPT 어플들은 이용시 추가 요금이나 질문마다 광고를 보게 만들어 불편하여<br>
직접 API 키를 발급받아 Flutter 어플에 HTTP통신으로 ChatGPT를 사용해 보았다.

# Flutter 사용한 라이브러리
- [http](https://pub.dev/packages/http)
- [cp949](https://pub.dev/packages/cp949)
- [cupertino_icons](https://pub.dev/packages/cupertino_icons)
- [flutter_share](https://pub.dev/packages/flutter_share)
- [sqflite](https://pub.dev/packages/sqflite)
- [path_provider](https://pub.dev/packages/path_provider)
- [intl](https://pub.dev/packages/intl)

# 결과물 및 내용
- HTTP통신을 사용하여 ChatGPT와 요청 응답을 받았다.
- 한국어가 깨짐으로 인해 cp949를 이용하여 한국어 깨짐 문제를 해결하였다.
- sqlfilte를 사용하여 내부에 DB를 구축해 CRUD를 만들어 사용자와 ChatGPT의 대화내용을 저장하도록 하였다.
- flutter_share를 사용해 ChatGPT의 내용을 외부로 공유할 수 있도록 만들었다.

<img src="https://user-images.githubusercontent.com/91882939/224811523-170e8710-e9fa-4459-a44b-a7ad44b33143.png" width="40%" height="30%" title="px(픽셀) 크기 설정" alt="RubberDuck"></img>
<img src="https://user-images.githubusercontent.com/91882939/224811528-5d5082d9-f3c3-4aee-8917-16d062a8bc8d.png" width="40%" height="30%" title="px(픽셀) 크기 설정" alt="RubberDuck"></img>
<img src="https://user-images.githubusercontent.com/91882939/224811531-1852aa21-afbb-4530-974e-43bf9f372855.png" width="40%" height="30%" title="px(픽셀) 크기 설정" alt="RubberDuck"></img>
<img src="https://user-images.githubusercontent.com/91882939/224812243-1f52a781-b75e-461e-b007-89eafe72c68b.png" width="40%" height="30%" title="px(픽셀) 크기 설정" alt="RubberDuck"></img>
<img src="https://user-images.githubusercontent.com/91882939/224812247-5e13e554-ba5a-4f26-8c4e-83b13127cddb.png" width="40%" height="30%" title="px(픽셀) 크기 설정" alt="RubberDuck"></img>
<img src="https://user-images.githubusercontent.com/91882939/224812249-99db7916-e2d6-4334-90f0-1dda48de7169.png" width="40%" height="30%" title="px(픽셀) 크기 설정" alt="RubberDuck"></img>
