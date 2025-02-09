<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.net.*, java.io.*, org.json.JSONArray, org.json.JSONObject" %>
<%
    // ------------------------------
    // 1. API 호출 및 JSON 문자열 저장 (pageNo=1)
    // ------------------------------
    String serviceKey = "zEp9kLeLZiXElh6mddTl2DXHIl44C4brxSyQojUBO6zjiy25apv9Dvh00sygk%2BKzMuXzMv3zKpoylWiGbVlCLA%3D%3D";
    StringBuilder urlBuilder = new StringBuilder();
    // 엔드포인트: searchFestival1 (행사 및 축제 정보 조회)
    urlBuilder.append("http://apis.data.go.kr/B551011/KorService1/searchFestival1?");
    urlBuilder.append("serviceKey=").append(serviceKey);
    urlBuilder.append("&numOfRows=40");
    urlBuilder.append("&pageNo=1");
    urlBuilder.append("&MobileOS=ETC");
    urlBuilder.append("&MobileApp=AINaviGo");
    urlBuilder.append("&_type=json");
    urlBuilder.append("&listYN=Y");
    urlBuilder.append("&arrange=R");
    urlBuilder.append("&eventStartDate=20250206");
    urlBuilder.append("&eventEndDate=");
    urlBuilder.append("&areaCode=");
    urlBuilder.append("&sigunguCode=");
    urlBuilder.append("&modifiedtime=");
    //

    URL url = new URL(urlBuilder.toString());
    HttpURLConnection conn = (HttpURLConnection) url.openConnection();
    conn.setRequestMethod("GET");
    conn.setRequestProperty("Accept", "application/json");

    int responseCode = conn.getResponseCode();
    String jsonResponse = "";
    if(responseCode == 200) {
        BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
        StringBuilder sb = new StringBuilder();
        String line;
        while((line = br.readLine()) != null) {
            sb.append(line);
        }
        br.close();
        jsonResponse = sb.toString();
    } else {
        jsonResponse = "{\"response\": {\"header\": {\"resultCode\": \"API ERROR: " + responseCode + "\"}}}";
    }
    conn.disconnect();

    // ------------------------------
    // 2. JSON 파싱 및 items 배열 생성
    // ------------------------------
    JSONArray items = new JSONArray();
    try {
        JSONObject jsonObj = new JSONObject(jsonResponse);
        JSONObject responseObj = jsonObj.getJSONObject("response");
        JSONObject bodyObj = responseObj.getJSONObject("body");
        JSONObject itemsObj = bodyObj.getJSONObject("items");
        Object itemData = itemsObj.get("item");
        if (itemData instanceof JSONArray) {
            items = (JSONArray) itemData;
        } else if (itemData instanceof JSONObject) {
            items = new JSONArray();
            items.put(itemData);
        }
    } catch(Exception e) {
        out.println("<p>초기 데이터를 불러오는데 실패했습니다: " + e.getMessage() + "</p>");
        items = new JSONArray();
    }

    // ------------------------------
    // 3. limit 파라미터 적용 (전체탭에서는 limit=8 전달)
    // ------------------------------
    String limitStr = request.getParameter("limit");
    int limit = items.length();
    if(limitStr != null) {
        try {
            int reqLimit = Integer.parseInt(limitStr);
            limit = Math.min(reqLimit, items.length());
        } catch(Exception ex) {
            // 파라미터 변환 실패 시 전체 아이템 수를 사용
        }
    }
%>
<html>
<head>
    <title>행사 및 축제</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <style>
        .card-img-custom {
            width: 300px;
            height: 212px;
            object-fit: cover;
        }
        .card-link {
            color: inherit;
            text-decoration: none;
        }
    </style>
</head>
<body>
<!-- API 응답 디버깅용 (필요 시 주석 처리) -->
<pre style="display:none;">
<%= jsonResponse %>
    </pre>

<h3 class="mb-3">행사 및 축제</h3>
<div class="row row-cols-1 row-cols-md-4 g-4 mb-5">
    <%
        // limit 변수만큼 반복 (전체 탭에서는 limit=8, 문화 축제 탭에서는 limit이 전달되지 않으면 전체 데이터 사용)
        for (int i = 0; i < limit; i++){
            JSONObject item = items.getJSONObject(i);
            String title = item.optString("title", "제목 없음");
            String imageUrl = item.optString("firstimage", "firstimage2");
            String description = item.optString("overview", "");
            if(description.isEmpty()){
                String startDate = item.optString("eventstartdate", "");
                String endDate = item.optString("eventenddate", "");
                if(!startDate.isEmpty() && !endDate.isEmpty()){
                    description = "행사 기간: " + startDate + " ~ " + endDate;
                } else {
                    description = "설명이 제공되지 않습니다.";
                }
            }
            String address = item.optString("addr1", "주소 정보 없음");
            String tel = item.optString("tel", "전화번호 정보 없음");
            String contentid = item.optString("contentid", "");
            String detailUrl = "detailFestival.jsp?contentid=" + contentid;
    %>
    <div class="col">
        <a href="<%= detailUrl %>" class="card-link">
            <div class="card h-100">
                <img src="<%= imageUrl %>" class="card-img-top card-img-custom" alt="<%= title %>">
                <div class="card-body">
                    <span class="badge bg-danger mb-2">행사 및 축제</span>
                    <h5 class="card-title"><%= title %></h5>
                    <p class="card-text text-muted"><%= description %></p>
                    <p class="card-text"><small class="text-muted">주소: <%= address %></small></p>
                    <p class="card-text"><small class="text-muted">전화번호: <%= tel %></small></p>
                </div>
            </div>
        </a>
    </div>
    <% } %>
</div>
</body>
</html>