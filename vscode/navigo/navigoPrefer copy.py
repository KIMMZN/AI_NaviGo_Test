# from fastapi import FastAPI, HTTPException
# import pymysql
# import pandas as pd
# from rapidfuzz import process
# import unicodedata
# import os

# app = FastAPI(docs_url="/docs", openapi_url="/openapi.json")  # ✅ FastAPI 문서 URL 명시적 설정

# # 📂 최신 엑셀 파일 경로
# EXCEL_FILE_PATH = "data/한국관광공사_국문_서비스분류코드_v4.2_gs.xlsx"

# # ✅ 캐시 변수 (엑셀 데이터를 미리 로드하여 재사용)
# category_data_cache = None

# # ✅ 기본 API (FastAPI 정상 실행 여부 확인)
# @app.get("/")
# async def root():
#     return {"message": "NaviGo API is running!"}

# # ✅ MySQL 연결 함수
# def get_connection():
#     return pymysql.connect(
#         host="192.168.0.6",
#         user="sion",
#         password="00000000",
#         database="navi_go",
#         charset="utf8mb4",
#         cursorclass=pymysql.cursors.DictCursor
#     )

# # ✅ 사용자 선호도 조회
# async def get_user_preference(member_id):
#     connection = get_connection()
#     cursor = connection.cursor()
#     sql = "SELECT prefer_purpose FROM preference WHERE member_id = %s"
#     cursor.execute(sql, (member_id,))
#     result = cursor.fetchone()
#     connection.close()
#     return result["prefer_purpose"] if result else None

# # ✅ 사용자 클릭 기록 조회
# async def get_user_click_history(member_id):
#     connection = get_connection()
#     cursor = connection.cursor()
#     sql = "SELECT contentid, cat1, cat2, cat3 FROM user_activity WHERE member_id = %s"
#     cursor.execute(sql, (member_id,))
#     result = cursor.fetchall()
#     connection.close()
#     return result

# # ✅ 엑셀 데이터 로딩 함수 (캐싱 적용)
# def load_category_data():
#     global category_data_cache
#     if category_data_cache is not None:
#         return category_data_cache

#     if not os.path.exists(EXCEL_FILE_PATH):
#         raise FileNotFoundError(f"❌ 엑셀 파일이 존재하지 않습니다: {EXCEL_FILE_PATH}")

#     print("🔄 엑셀 파일 로딩 중...")
#     try:
#         xls = pd.ExcelFile(EXCEL_FILE_PATH, engine="openpyxl")
#         available_sheets = xls.sheet_names
#         sheet_name = "시트1" if "시트1" in available_sheets else available_sheets[0]
        
#         df = pd.read_excel(xls, sheet_name=sheet_name, skiprows=0, dtype=str)  # 모든 데이터를 문자열로 변환

#         expected_columns = ["contenttypeid", "cat1", "cat2", "cat3", "대분류", "중분류", "소분류"]
#         df.columns = expected_columns[:len(df.columns)]  # 컬럼 개수가 다르면 자동 조정

#         df = df.dropna(how="all").reset_index(drop=True)
#         df["중분류"] = df["중분류"].astype(str).str.strip()

#         print("✅ [엑셀 로딩 완료] 데이터 개수:", df.shape[0])
#         category_data_cache = df
#         return df

#     except Exception as e:
#         raise Exception(f"❌ 엑셀 로드 중 오류 발생: {e}")

# # ✅ 추천 시스템 함수 (비동기)
# async def recommend_best_cat3(member_id):
#     print(f"\n\n✅ 추천 요청된 member_id: {member_id}")

#     user_clicks = await get_user_click_history(member_id)
#     print(f"🟡 user_clicks: {user_clicks}")

#     user_preference = await get_user_preference(member_id)
#     print(f"🟢 user_preference: {user_preference}")

#     category_data = load_category_data()

#     matched_middle = user_preference  # 정확한 매칭만 시도
#     print(f"🔵 matched_middle: {matched_middle}")

#     if not user_clicks:
#         print("⚠️ 사용자 클릭 이력이 없습니다. preference 기반 추천을 진행합니다.")
        
#         if matched_middle:
#             category_data["중분류"] = category_data["중분류"].astype(str).str.strip()

#             matched_df = category_data[category_data["중분류"].str.contains(matched_middle, na=False, regex=False)]
#             print("🔎 [matched_df] 필터링된 데이터 개수:", matched_df.shape[0])

#             if not matched_df.empty:
#                 best_cat3 = matched_df.head(3)
#                 recs = best_cat3[["cat3", "대분류", "중분류", "소분류"]].to_dict(orient="records")
#                 print(f"🟣 최종 추천 결과(중분류={matched_middle}): {recs}")
#                 return recs[0]

#         print("🟣 preference 매칭 실패 → fallback 추천 실행")
#         fallback = category_data.sample(n=min(3, len(category_data)))[["cat3", "대분류", "중분류", "소분류"]].to_dict(orient="records")
#         return fallback[0] if fallback else None

#     return None

# # ✅ FastAPI 추천 시스템 라우터
# @app.get("/recommend/{member_id}")
# async def get_recommendations(member_id: str):
#     recommendation = await recommend_best_cat3(member_id)
#     if not recommendation:
#         raise HTTPException(status_code=404, detail="No recommendations found")
#     return recommendation

# # ✅ FastAPI 실행
# if __name__ == "__main__":
#     import uvicorn
#     uvicorn.run(app, host="127.0.0.1", port=5000, reload=True)
