<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="org.json.JSONObject" %>
<html>
<head>
    <title>여행지 상세 정보</title>
    <style>
        body {
            font-family: Arial, sans-serif;
        }
        .container {
            width: 80%;
            margin: auto;
        }
        .title {
            font-size: 24px;
            font-weight: bold;
            margin-top: 20px;
        }
        .image-container img {
            width: 100%;
            max-height: 400px;
            object-fit: cover;
        }
        .details {
            margin-top: 20px;
        }
        .info-box {
            padding: 10px;
            border: 1px solid #ddd;
            margin-top: 10px;
        }
    </style>
</head>
<body>
<div class="container">
    <h1 class="title">여행지 상세 정보</h1>

    <%
        JSONArray items = (JSONArray) request.getAttribute("items");
        if (items != null && items.length() > 0) {
            JSONObject item = items.getJSONObject(0); // 첫 번째 데이터만 표시

            // 기본 정보
            String title = item.optString("title", "제목 없음");
            String firstImage = item.optString("firstimage", "default.jpg");
            String address = item.optString("addr1", "주소 정보 없음");
            String overview = item.optString("overview", "상세 정보 없음");

            // 추가 정보 (홈페이지 & 전화번호)
            String homepage = item.optString("homepage", "").trim();
            if (homepage.isEmpty()) {
                homepage = "정보 없음";
            }
            String tel = item.optString("tel", "").trim();
            if (tel.isEmpty()) {
                tel = "정보 없음";
            }

            // 지도 좌표
            String mapX = item.has("mapx") ? item.get("mapx").toString() : "정보 없음";
            String mapY = item.has("mapy") ? item.get("mapy").toString() : "정보 없음";
    %>

    <!-- 제목 -->
    <h2><%= title %></h2>

    <!-- 이미지 영역 (오직 firstImage만 표시) -->
    <div class="image-container">
        <img src="<%= firstImage %>" alt="여행지 이미지">
    </div>

    <!-- 상세 정보 -->
    <div class="details">
        <div class="info-box">
            <h3>주소</h3>
            <p><%= address %></p>
        </div>

        <div class="info-box">
            <h3>상세 설명</h3>
            <p><%= overview %></p>
        </div>

        <div class="info-box">
            <h3>홈페이지</h3>
            <p><%= homepage %></p>
        </div>

        <div class="info-box">
            <h3>전화번호</h3>
            <p><%= tel %></p>
        </div>

        <div class="info-box">
            <h3>지도 좌표</h3>
            <p>X: <%= mapX %>, Y: <%= mapY %></p>
        </div>
    </div>

    <%
    } else {
    %>
    <p>데이터를 불러오지 못했습니다.</p>
    <%
        }
    %>
</div>
</body>
</html>
