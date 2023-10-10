import requests
from bs4 import BeautifulSoup
import re

URLS = [
    "https://www.esingsing.co.kr/bbs/board.php?bo_table=200&sca=%EC%8B%9C%EA%B8%88%EC%B9%98&pcon=1101",
    "https://www.esingsing.co.kr/bbs/board.php?bo_table=200&sca=%EC%96%91%EB%B0%B0%EC%B6%94&pcon=1101",
    "https://www.esingsing.co.kr/bbs/board.php?bo_table=200&sca=%EC%96%91%ED%8C%8C&pcon=1101",
    "https://www.esingsing.co.kr/bbs/board.php?bo_table=200&sca=%EC%97%B4%EB%AC%B4&pcon=1101",
    "https://www.esingsing.co.kr/bbs/board.php?bo_table=200&sca=%ED%94%BC%EB%A7%9D&pcon=1101",
    "https://www.esingsing.co.kr/bbs/board.php?bo_table=200&sca=%EA%B9%BB%EC%9E%8E&pcon=1101",
    "https://www.esingsing.co.kr/bbs/board.php?bo_table=200&sca=%EB%AF%B8%EB%82%98%EB%A6%AC&pcon=1101",
    "https://www.esingsing.co.kr/bbs/board.php?bo_table=200&sca=%EC%96%BC%EA%B0%88%EC%9D%B4%EB%B0%B0%EC%B6%94&pcon=1101"
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
        price = float(price_element.text.replace(',', '').strip())  # 콤마 제거 후 실수로 변환
        if weight:
            price_per_unit = price / weight  # 단위당 가격 계산
        else:
            price_per_unit = None
    else:
        price_per_unit = "Cannot extract price"

    return veg_name, unit, price_per_unit


for url in URLS:
    veg_name, unit, price_per_unit = extract_info_from_url(url)
    print(f"URL: {url}\nVegetable: {veg_name}, Unit: {unit}, Price per {unit}: {price_per_unit}\n")