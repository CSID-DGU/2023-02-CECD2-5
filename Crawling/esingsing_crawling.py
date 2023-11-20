import requests
import xml.etree.ElementTree as ET
from bs4 import BeautifulSoup
import re
import pymysql

# RDS 연결 정보
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

# aoi_key 정보
api_key = "02772220-1fcb-42a8-9829-dcd685ab3972"
api_endpoint = "API_ENDPOINT_URL"

# Kamis OpenAPI 키
api_key = "02772220-1fcb-42a8-9829-dcd685ab3972"

# Kamis OpenAPI URL
url = "http://www.kamis.co.kr/service/price/xml.do?action=dailySalesList&p_cert_key=test&p_cert_id=test&p_returntype=xml"

# OpenAPI 호출
response = requests.get(url)
xml_data = response.text

# XML 파싱
root = ET.fromstring(xml_data)

# url 목록
URLS = [
    "https://www.esingsing.co.kr/bbs/board.php?bo_table=200&sca=%EB%B0%B0%EC%B6%94&pcon=1101",
    "https://www.esingsing.co.kr/bbs/board.php?bo_table=200&sca=%EC%96%91%EB%B0%B0%EC%B6%94&pcon=1101",
    "https://www.esingsing.co.kr/bbs/board.php?bo_table=200&sca=%EC%96%91%ED%8C%8C&pcon=1101",
    "https://www.esingsing.co.kr/bbs/board.php?bo_table=200&sca=%EB%AC%B4&pcon=1101",
    "https://www.esingsing.co.kr/bbs/board.php?bo_table=200&sca=%EC%8B%9C%EA%B8%88%EC%B9%98&pcon=1101",
    "https://www.esingsing.co.kr/bbs/board.php?bo_table=200&sca=%EC%98%A4%EC%9D%B4&pcon=1101",
    "https://www.esingsing.co.kr/bbs/board.php?bo_table=200&sca=%EB%8B%B9%EA%B7%BC&pcon=1101",
    "https://www.esingsing.co.kr/bbs/board.php?bo_table=200&sca=%ED%8C%8C&pcon=1101",
    "https://www.esingsing.co.kr/bbs/board.php?bo_table=200&sca=%EC%97%B4%EB%AC%B4&pcon=1101",
    "https://www.esingsing.co.kr/bbs/board.php?bo_table=200&sca=%ED%8C%8C%ED%94%84%EB%A6%AC%EC%B9%B4&pcon=1101",
    "https://www.esingsing.co.kr/bbs/board.php?bo_table=200&sca=%ED%92%8B%EA%B3%A0%EC%B6%94&pcon=1101",
    "https://www.esingsing.co.kr/bbs/board.php?bo_table=200&sca=%EC%83%9D%EA%B0%95&pcon=1101",
    "https://www.esingsing.co.kr/bbs/board.php?bo_table=200&sca=%ED%94%BC%EB%A7%9D&pcon=1101",
    "https://www.esingsing.co.kr/bbs/board.php?bo_table=200&sca=%EC%83%81%EC%B6%94&pcon=1101",
    "https://www.esingsing.co.kr/bbs/board.php?bo_table=200&sca=%EA%B9%BB%EC%9E%8E&pcon=1101",
    "https://www.esingsing.co.kr/bbs/board.php?bo_table=200&sca=%EB%AF%B8%EB%82%98%EB%A6%AC&pcon=1101",
    "https://www.esingsing.co.kr/bbs/board.php?bo_table=200&sca=%ED%94%BC%EB%A7%88%EB%8A%98&pcon=1101"
]

# 채소 목록
veg_units = {
    "배추": ["10kg", "1포기"],
    "양배추": ["1포기", "8kg"],
    "양파": ["1kg"],
    "무": ["1개", "20kg"],
    "시금치": ["100g", "4kg"],
    "오이": ["10개", "100개"],
    "당근": ["1kg", "20kg"],
    "파": ["1kg"],
    "열무": ["1kg", "4kg"],
    "파프리카": ["200g", "5kg"],
    "풋고추": ["100g", "10kg"],
    "생강": ["1kg", "10kg"],
    "피망": ["100g", "10kg"],
    "상추": ["100g", "4kg"],
    "깻잎": ["100g", "2kg"],
    "미나리": ["100g", "7.5kg"],
    "피마늘": ["10kg"]
}


def extract_info_from_url(url):
    response = requests.get(url)
    response.raise_for_status()
    soup = BeautifulSoup(response.text, 'html.parser')

    item_element = soup.select_one('item_name')
    full_item = item_element.text
    veg_name = re.match(r"(\w+)", full_item)[0]

    unit_element = soup.select_one('kind_name')
    if unit_element:
        full_unit = unit_element.text
        match = re.search(r"([0-9.]+\w+)", full_unit)
        if match:
            unit = match.group(1)
        else:
            unit = None
    else:
        veg_name, unit = "Cannot extract name", None

    price_element = soup.select_one('dpr1')
    if price_element:
        price_text = price_element.text.replace(',', '').strip()

        if price_text == '-':
            price = None  # 또는 다른 기본값 설정
        else:
            try:
                price = float(price_text)
            except ValueError:
                print(f"가격 정보를 부동 소수점으로 변환할 수 없습니다: {price_text}")
                price = None
    else:
        price = "Cannot extract price"

    return veg_name, unit, price

try:
    for url in URLS:
        try:
            veg_name, unit, price = extract_info_from_url(url)
            print(f"Vegetable: {veg_name}, Unit: {unit}, Price: {price}\n")

            if price is not None:
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
                        (id, veg_name, price, unit))
        except Exception as e:
            print(f"An error occurred while processing URL {url}: {e}")

    for item in root.iter('item'):
        product_name_element = item.find('productName')
        day1_price_element = item.find('dpr1')
        unit_element = item.find('unit')

        if product_name_element is not None and \
                day1_price_element is not None and \
                unit_element is not None:

            product_name = product_name_element.text.split('/')[0].strip()
            day1_price = float(day1_price_element.text.replace(',', ''))
            unit = unit_element.text

            if product_name in veg_units.keys() and unit in veg_units[product_name]:
                # 연결이 성공한 경우, 쿼리를 실행하거나 다른 작업 수행
                with connection.cursor() as cursor:
                    print(f"Vegetable: {product_name}, Unit: Price: {unit}, Price: {day1_price}\n")
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
                        (id, product_name, day1_price, unit))
finally:
    connection.commit()
    connection.close()
