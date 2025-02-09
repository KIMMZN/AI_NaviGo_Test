<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.json.JSONArray, org.json.JSONObject" %>

<%
    JSONArray items = (JSONArray) request.getAttribute("items");
%>

<html>
<head>
    <title>AI 추천 여행지</title>
    <script>
        function recordClick(contentid, cat1, cat2, cat3) {
            // 자바스크립트로 /recordClick 엔드포인트에 POST
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
                .then(data => console.log("Click recorded:", data))
                .catch(err => console.error("Error:", err));
        }
    </script>
</head>
<body>

<h3 class="mb-3 text-center">AI 추천 여행지</h3>

<div class="container">
    <div class="row row-cols-1 row-cols-md-3 g-4 mb-5">
        <%
            for (int i = 0; i < items.length(); i++) {
                JSONObject item = items.getJSONObject(i);
                String title = item.optString("title", "제목 없음");
                String imageUrl = item.optString("firstimage", "placeholder.jpg");
                String contentid = item.optString("contentid", "");
                // 아래 cat1, cat2, cat3도 가져온 뒤 onclick에서 넘겨줍니다.
                String cat1 = item.optString("cat1", "");
                String cat2 = item.optString("cat2", "");
                String cat3 = item.optString("cat3", "");

                String addr1 = item.optString("addr1", "주소 정보 없음");
                String contenttypeid = item.optString("contenttypeid", "");

                String detailUrl = "recommend/detail?contentid=" + contentid + "&contenttypeid=" + contenttypeid;
        %>

        <div class="col">
            <!-- 카드 클릭 시 recordClick() 호출 + 이후 detail 페이지로 이동하도록 구성 -->
            <a href="<%= detailUrl %>" class="card-link"
               onclick="recordClick('<%= contentid %>', '<%= cat1 %>', '<%= cat2 %>', '<%= cat3 %>');">
                <div class="card h-100">
                    <img src="<%= imageUrl %>" class="card-img-top" alt="<%= title %>">
                    <div class="card-body">
                        <h5 class="card-title"><%= title %></h5>
                        <h6 class="card-addr"><%= addr1 %></h6>
                    </div>
                </div>
            </a>
        </div>
        <%
            } // end for
        %>
    </div>
</div>

</body>
</html>
