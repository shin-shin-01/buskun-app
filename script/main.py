from __future__ import annotations # 自作クラスで型指定
from typing import Any, Dict, List
import requests
import bs4
import time
import json
# pyright: reportMissingTypeStubs=false
import firebase_admin 
from firebase_admin import credentials
from firebase_admin import firestore


"""
サイトから時刻表の情報をスクレイピング
- ex) [{'departure_at': '07:35', 'arrive_at': '07:44'}, {'departure_at': '07:48', 'arrive_at': '07:57'}
- 路線が存在しない場合などはからのリストを返す
"""
def scraping(departure_busstop_code: str, arrive_busstop_code: str,
             bus_line_code: str, date: str) -> List[Dict[str, str]]:
    url = f"https://www.navitime.co.jp/bus/diagram/timelist?hour=3&departure={departure_busstop_code}&arrival={arrive_busstop_code}&line={bus_line_code}&date={date}"

    site = requests.get(url)
    data = bs4.BeautifulSoup(site.text, "html.parser")
    data_time_details: bs4.element.ResultSet = data.find_all(
        class_="time-detail")

    results: List[Dict[str, str]] = []

    for time_detail in data_time_details:
        time_detail_list: List[str] = time_detail.text.split()

        if time_detail_list[0] == "（始）":
            del time_detail_list[0]  # 始発の場合に削除

        departure_at = time_detail_list[0]
        arrive_at = time_detail_list[1]
        results.append(
            {
                "departure_at": departure_at[:-1],
                "arrive_at": arrive_at[:-1]
            }
        )
    return results

"""
Firebase にデータを保存
"""
cred = credentials.Certificate("./secret-key.json") # ダウンロードした秘密鍵
# pyright: reportUnknownMemberType=false
firebase_admin.initialize_app(cred)    
db: Any = firestore.client()

def save_to_firebase(data: Dict[str, Any], line_key: str, holiday_key: str) -> None:

    print(line_key + holiday_key + " origin: " + data["origin"] + " -> destination: " + data["destination"])

    batch: Any = db.batch()
    for i, timetable in enumerate(data["timetables"]):
        doc_id = line_key + holiday_key + str(i).zfill(3)
        doc_ref = db.collection("buses").document(data["origin"]).collection(data["destination"]).document(doc_id)
        batch.set(doc_ref, timetable.to_dict())

    batch.commit()

def save_to_firebase_bus_pair(data: Dict[str, str], bus_pair_key: str) -> None:
    
    print(bus_pair_key + " : " +  data["name_1"], data["name_2"])

    doc_ref = db.collection("bus_pairs").document(str(bus_pair_key))
    doc_ref.set({"first": data["name_1"], "second": data["name_2"]})

"""
Firebase に登録されているバス停の組み合わせを取得
return [["九大", "産学連携"], ["九大", "理学部"], ..., ]
"""
def get_bus_pair_from_firebase() -> List[List[str]]:
    registerd_bus_pairs = []
    docs = db.collection("bus_pairs").stream()
    for doc in docs:
        data = doc.to_dict()
        registerd_bus_pairs.append([data["first"], data["second"]])

    return registerd_bus_pairs

def is_already_registerd_pair(registerd_bus_pairs: List[List[str]], data: Dict[str, str]):
    return [data["name_1"], data["name_2"]] in registerd_bus_pairs

"""
時刻表クラス
"""
class Timetable:
    def __init__(self, arrive_at: str, departure_at: str, line: str, holiday: bool):
        self.arrive_at = arrive_at
        self.departure_at = departure_at
        self.line = line
        self.holiday = holiday

    def to_dict(self) -> Dict[str, str | bool]:
        return {
            "arriveAt": self.arrive_at,
            "departureAt": self.departure_at,
            "line": self.line,
            "holiday": self.holiday
        }


"""
- bus-data.json から収集するバス停のデータを取得
- バス停の組み合わせ, 路線, 平日/休日, 行き/帰り 全ての組み合わせでデータを取得
- Firebase に保存
"""
if __name__ == "__main__":
    json_open = open('bus-data.json', 'r')
    bus_data = json.load(json_open)

    # 既に登録されているバス停の組み合わせ
    registerd_bus_pairs = get_bus_pair_from_firebase()

    # google.api_core.exceptions.InvalidArgument: 400 maximum 500 writes allowed per request
    # 上記仕様のため, 定期的にFirebaseに反映
    
    for bus_pair_key, bus_pairs in bus_data["bus_pairs"].items(): # バス停組み合わせ一覧
        # 既に登録されている場合にスキップする
        if is_already_registerd_pair(registerd_bus_pairs, bus_pairs): continue

        for line_key, lines in bus_data["lines"].items(): # バス路線一覧
            for holiday_key, holiday in bus_data["holiday"].items(): # 休日 or 平日

                # 行き
                time.sleep(3)
                results: Dict[str, Any] = {"origin": bus_pairs["name_1"], "destination": bus_pairs["name_2"], "timetables": []}
                list_data: List[Dict[str, str]] = scraping(bus_pairs["code_1"], bus_pairs["code_2"], lines["code"], holiday["date"])
                for data in list_data:
                    timetable = Timetable(data["arrive_at"], data["departure_at"], lines["name"], holiday["holiday"])
                    results["timetables"].append(timetable)

                save_to_firebase(results, line_key, holiday_key)

                # 帰り
                time.sleep(3)
                results: Dict[str, Any] = {"origin": bus_pairs["name_2"], "destination": bus_pairs["name_1"], "timetables": []}
                list_data: List[Dict[str, str]] = scraping(bus_pairs["code_2"], bus_pairs["code_1"], lines["code"], holiday["date"])
                for data in list_data:
                    timetable = Timetable(data["arrive_at"], data["departure_at"], lines["name"], holiday["holiday"])
                    results["timetables"].append(timetable)

                save_to_firebase(results, line_key, holiday_key)

        # firebase で get_collections が 使用できないため
        # 別ドキュメント に 組み合わせを保存
        save_to_firebase_bus_pair(bus_pairs, bus_pair_key)


    # ****************************
    # # test 
    # results = scraping("00291944", "00087909", "00053907", "2021-08-02")
    # # [{'departure_at': '07:35', 'arrive_at': '07:44'}, {'departure_at': '07:48', 'arrive_at': '07:57'},
    # print(results)
