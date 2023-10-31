import requests
from bs4 import BeautifulSoup
import re
import pymysql

host = "veggiehunter-springboot-webservice.cnrhvv9ptkr7.ap-northeast-2.rds.amazonaws.com"
database = "veggiehunter"
username = "veggiehunter"
password = "veggiehunter5"

# RDS에 연결
connection = pymysql.connect(host=host,
                             user=username,
                             password=password,
                             database=database,
                             charset='utf8mb4',
                             cursorclass=pymysql.cursors.DictCursor)

URLS = [
    "https://www.esingsing.co.kr/bbs/board.php?bo_table=200&sca=%EC%8B%9C%EA%B8%88%EC%B9%98&pcon=1101",
    "https://www.esingsing.co.kr/bbs/board.php?bo_table=200&sca=%EC%96%91%EB%B0%B0%EC%B6%94&pcon=1101",
    "https://www.esingsing.co.kr/bbs/board.php?bo_table=200&sca=%EC%96%91%ED%8C%8C&pcon=1101",
    "https://www.esingsing.co.kr/bbs/board.php?bo_table=200&sca=%EC%97%B4%EB%AC%B4&pcon=1101",
    "https://www.esingsing.co.kr/bbs/board.php?bo_table=200&sca=%ED%94%BC%EB%A7%9D&pcon=1101",
    "https://www.esingsing.co.kr/bbs/board.php?bo_table=200&sca=%EA%B9%BB%EC%9E%8E&pcon=1101",
    "https://www.esingsing.co.kr/bbs/board.php?bo_table=200&sca=%EB%AF%B8%EB%82%98%EB%A6%AC&pcon=1101",
    "https://www.esingsing.co.kr/bbs/board.php?bo_table=200&sca=%EC%96%BC%EA%B0%88%EC%9D%B4%EB%B0%B0%EC%B6%94&pcon=1101",
    "https://www.esingsing.co.kr/bbs/board.php?bo_table=100&sca=%EA%B3%A0%EA%B5%AC%EB%A7%88&pcon=1101"
    "https://www.esingsing.co.kr/bbs/board.php?bo_table=100&sca=%EB%A9%94%EB%B0%80&pcon=1101",
    "https://www.esingsing.co.kr/bbs/board.php?bo_table=200s&sca=%EC%88%98%EB%B0%95&pcon=1101",
    "https://www.esingsing.co.kr/bbs/board.php?bo_table=200s&sca=%EB%A9%9C%EB%A1%A0&pcon=1101",
    "https://www.esingsing.co.kr/bbs/board.php?bo_table=200s&sca=%ED%86%A0%EB%A7%88%ED%86%A0&pcon=1101",
    "https://www.esingsing.co.kr/bbs/board.php?bo_table=200s&sca=%EB%B0%A9%EC%9A%B8%ED%86%A0%EB%A7%88%ED%86%A0&pcon=1101",
    "https://www.esingsing.co.kr/bbs/board.php?bo_table=400&sca=%EB%8B%A8%EA%B0%90&pcon=1101",
    "https://www.esingsing.co.kr/bbs/board.php?bo_table=300&sca=%ED%8C%BD%EC%9D%B4%EB%B2%84%EC%84%AF&pcon=1101",
    "https://www.esingsing.co.kr/bbs/board.php?bo_table=300&sca=%EC%83%88%EC%86%A1%EC%9D%B4%EB%B2%84%EC%84%AF&pcon=1101",

]


def extract_info_from_url(url):
    response = requests.get(url)
    response.raise_for_status()
    soup = BeautifulSoup(response.text, 'html.parser')

    name_element = soup.select_one('kind_name')
    if name_element:
        full_name = name_element.text
        match = re.match(r"(\w+)\s*\(([0-9.]+)(\w+)\)", full_name)

        if match:
            veg_name, weight, unit = match.groups()
            weight = float(weight)  # 문자열을 실수로 변환
        else:
            veg_name, weight, unit = full_name, None, None
    else:
        veg_name, weight, unit = "Cannot extract name", None, None

    price_element = soup.select_one('dpr1')
    if price_element:
        price_text = price_element.text.replace(',', '').strip()

        if price_text == '-':
            price = None  # 또는 다른 기본값 설정
            price_per_unit = None
        else:
            try:
                price = float(price_text)
                if weight:
                    price_per_unit = price / weight  # 단위당 가격 계산
                else:
                    price_per_unit = None
            except ValueError:
                print(f"가격 정보를 부동 소수점으로 변환할 수 없습니다: {price_text}")
                price = None
                price_per_unit = None
    else:
        price = price_per_unit = "Cannot extract price"

    return veg_name, unit, price_per_unit

try:
    for url in URLS:
        veg_name, unit, price_per_unit = extract_info_from_url(url)
        print(f"URL: {url}\nVegetable: {veg_name}, Unit: {unit}, Price per {unit}: {price_per_unit}\n")

        if price_per_unit == None or price_per_unit != None:
            with connection.cursor() as cursor:
                cursor.execute("SELECT MAX(id) FROM price;")
                max_id_result = cursor.fetchone()
                if max_id_result and 'MAX(id)' in max_id_result:
                    max_id = max_id_result['MAX(id)']
                    # 만약 max_id가 None이라면 0으로 초기화
                    max_id = max_id if max_id is not None else 0
                    id = max_id + 1
                else:
                    # 테이블에 레코드가 없는 경우, id를 1로 설정
                    id = 1

                cursor.execute(
                    "INSERT INTO price (id, name, price, unit, created_date, updated_date) VALUES (%s, %s, %s, %s, now(), now())",
                    (id, veg_name, price_per_unit, unit))
    cursor.close()
finally:
    connection.commit()
    connection.close()