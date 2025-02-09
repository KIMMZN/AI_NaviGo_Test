from fastapi import FastAPI, HTTPException
import pymysql
import pandas as pd
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity
from rapidfuzz import process

app = FastAPI()

def get_connection():
    return pymysql.connect(
        host="localhost",
        user="root",
        password="11111111",
        database="navi_go",
        charset="utf8mb4",
        cursorclass=pymysql.cursors.DictCursor
    )

def get_user_preference(member_id):
    connection = get_connection()
    cursor = connection.cursor()
    sql = "SELECT prefer_purpose FROM preference WHERE member_id = %s"
    cursor.execute(sql, (member_id,))
    result = cursor.fetchone()
    connection.close()
    return result["prefer_purpose"] if result else None

def get_user_click_history(member_id):
    connection = get_connection()
    cursor = connection.cursor()
    sql = "SELECT contentid, cat1, cat2, cat3 FROM user_activity WHERE member_id = %s"
    cursor.execute(sql, (member_id,))
    result = cursor.fetchall()
    connection.close()
    return result

def load_category_data():
    file_path = "data/한국관광공사_국문_서비스분류코드_v4.2.xlsx"
    xls = pd.ExcelFile(file_path)
    df = pd.read_excel(xls, sheet_name='국문')
    df = df.iloc[4:]
    df.columns = ["contenttypeid", "cat1", "cat2", "cat3", "대분류", "중분류", "소분류"]
    df = df.dropna()
    return df

def map_preference_to_cat2(preference, df):
    choices = df["중분류"].tolist()
    best_match, score, index = process.extractOne(preference, choices)
    if score > 80:
        return df.iloc[index]["cat2"]
    return None

# 추천 로직 수정: 추천 결과 리스트 대신 첫 번째 추천 결과(딕셔너리)를 반환
def recommend_best_cat3(member_id):
    user_clicks = get_user_click_history(member_id)
    user_preference = get_user_preference(member_id)
    category_data = load_category_data()
    
    preference_cat2 = map_preference_to_cat2(user_preference, category_data)
    
    if not user_clicks:
        if preference_cat2:
            best_cat3 = category_data[category_data["cat2"] == preference_cat2].head(3)
            recs = best_cat3[["cat3", "대분류", "중분류"]].to_dict(orient="records")
            return recs[0] if recs else None
        return None
         
    clicked_features = [" ".join([click["cat1"], click["cat2"], click["cat3"]]) for click in user_clicks]
    category_data["features"] = category_data["cat1"] + " " + category_data["cat2"] + " " + category_data["cat3"]
    
    vectorizer = TfidfVectorizer()
    tfidf_matrix = vectorizer.fit_transform(category_data["features"])
    clicked_vector = vectorizer.transform(clicked_features)
    
    similarities = cosine_similarity(tfidf_matrix, clicked_vector).mean(axis=1)
    
    category_data["score"] = similarities
    if preference_cat2:
        category_data.loc[category_data["cat2"] == preference_cat2, "score"] += 0.2
    
    best_cat3 = category_data.sort_values("score", ascending=False).head(3)
    recs = best_cat3[["cat3", "대분류", "중분류"]].to_dict(orient="records")
    return recs[0] if recs else None

@app.get("/recommend/{member_id}")
async def get_recommendations(member_id: str):
    recommendation = recommend_best_cat3(member_id)
    if not recommendation:
        raise HTTPException(status_code=404, detail="No recommendations found")
    return recommendation

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="127.0.0.1", port=5000)
