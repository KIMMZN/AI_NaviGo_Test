<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.net.*, java.io.*, org.json.JSONArray, org.json.JSONObject" %>

<%
    // ------------------------------
    // 1. API 호출: areaBasedList1 (기본 목록 조회)
    // ------------------------------
    String preferenceMB = (String) request.getAttribute("preference");
    if(preferenceMB == null || preferenceMB.trim().isEmpty()) {
        preferenceMB = "A0202";
    }

    String tempword = "힐링 코스";
    String tempsearchword = "";
    if(tempword.equals("힐링 코스")){
        tempsearchword = "C0114";
    } else if(tempword.equals("음식")){
        tempsearchword = "A0502";
    }

    String serviceKey = "zEp9kLeLZiXElh6mddTl2DXHIl44C4brxSyQojUBO6zjiy25apv9Dvh00sygk%2BKzMuXzMv3zKpoylWiGbVlCLA%3D%3D";
    StringBuilder urlBuilder = new StringBuilder();
    urlBuilder.append("http://apis.data.go.kr/B551011/KorService1/areaBasedList1?");
    urlBuilder.append("serviceKey=").append(serviceKey);
    urlBuilder.append("&numOfRows=40");
    urlBuilder.append("&pageNo=1");
    urlBuilder.append("&MobileOS=ETC");
    urlBuilder.append("&MobileApp=AINaviGo");
    urlBuilder.append("&_type=json");
    urlBuilder.append("&listYN=Y");
    urlBuilder.append("&arrange=R");
    urlBuilder.append("&cat2=").append(preferenceMB);

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
        while((line = br.readLine()) != null){
            sb.append(line);
        }
        br.close();
        jsonResponse = sb.toString();
    } else {
        jsonResponse = "{\"response\":{\"header\":{\"resultCode\":\"API ERROR: " + responseCode + "\"}}}";
    }
    conn.disconnect();

    // ------------------------------
    // 2. JSON 파싱 (목록 items 배열 추출)
    // ------------------------------
    JSONArray items = new JSONArray();
    try {
        JSONObject jsonObj = new JSONObject(jsonResponse);
        JSONObject responseObj = jsonObj.getJSONObject("response");
        JSONObject bodyObj = responseObj.getJSONObject("body");
        JSONObject itemsObj = bodyObj.getJSONObject("items");
        Object itemData = itemsObj.get("item");
        if(itemData instanceof JSONArray){
            items = (JSONArray) itemData;
        } else if(itemData instanceof JSONObject){
            items = new JSONArray();
            items.put(itemData);
        }
    } catch(Exception e){
        items = new JSONArray();
    }

    // ------------------------------
    // 3. limit 적용 (최대 9개까지만 표시, 3개씩 3줄)
    // ------------------------------
    String limitStr = request.getParameter("limit");
    int limit = items.length();
    if(limitStr != null) {
        try {
            int reqLimit = Integer.parseInt(limitStr);
            limit = Math.min(reqLimit, items.length());
        } catch(Exception ex) {
            // 파라미터 변환 실패 시 전체 아이템 사용
        }
    }
    limit = Math.min(limit, 40); // 한 페이지에 최대 9개까지만 표시
%>

<html>
<head>
    <title>AI 추천 여행지</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" />
    <style>
        /* 카드 이미지 크기 조정 */
        .card-img-top {
            width: 100%;
            height: 180px;
            object-fit: cover; /* 카드에 꽉 차도록 조절 */
        }

        /* 카드 크기 균일하게 설정 */
        .card {
            display: flex;
            flex-direction: column;
            height: 100%;
        }

        /* 카드 본문 균일하게 배치 */
        .card-body {
            flex-grow: 1;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        /* AI 추천 배지 스타일 (작게 조정 및 크기 자동 조절) */
        .badge-small {
            font-size: 0.8rem;
            padding: 2px 6px;
            display: inline-block;
            max-width: fit-content;
        }

        /* 카드 링크 스타일 */
        .card-link {
            color: inherit;
            text-decoration: none;
        }

        /* 중앙 정렬 및 여백 추가 */
        .container-custom {
            max-width: 80%;
            margin: auto;
        }
    </style>
</head>
<body>

<h3 class="mb-3 text-center">AI추천 여행지</h3>

<!-- 한 줄에 3개씩 배치되도록 설정 -->
<div class="container container-custom">
    <div class="row row-cols-1 row-cols-md-3 g-4 mb-5">
        <%
            for(int i = 0; i < limit; i++){
                JSONObject item = items.getJSONObject(i);
                String title = item.optString("title", "제목 없음");
                String imageUrl = item.optString("firstimage", "firstimage2");
                if(imageUrl == null || imageUrl.isEmpty()){
                    imageUrl = "placeholder.jpg";
                }
                String contentid = item.optString("contentid", "");
                String contenttypeid = item.optString("contenttypeid", "");
                String cat1 = item.optString("cat1", "기본값");
                String cat2 = item.optString("cat2", "기본값");
                String cat3 = item.optString("cat3", "기본값");

                String detailUrl = "recommend/detail?contentid=" + contentid + "&contenttypeid=" + contenttypeid;
        %>

        <div class="col">
            <a href="<%= detailUrl %>" class="card-link" onclick="recordClick('<%= contentid %>', '<%= cat1 %>', '<%= cat2 %>', '<%= cat3 %>')">
                <div class="card h-100">
                    <img src="<%= imageUrl %>" class="card-img-top" alt="<%= title %>">
                    <div class="card-body">
                        <span class="badge bg-primary badge-small mb-2">AI추천</span>
                        <h5 class="card-title"><%= title %></h5>
                    </div>
                </div>
            </a>
        </div>
        <%
            } // end for
        %>
    </div>
</div>

<script>
    function recordClick(contentid, cat1, cat2, cat3) {
        fetch('/recordClick', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                contentid: contentid,
                cat1: cat1,
                cat2: cat2,
                cat3: cat3
            })
        })
            .then(response => response.text())
            .then(data => console.log(data));
    }
</script>

</body>
</html>
