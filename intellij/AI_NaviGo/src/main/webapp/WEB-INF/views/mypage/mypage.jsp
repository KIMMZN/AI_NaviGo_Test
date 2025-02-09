<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>My Page</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/style.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/main.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <style>
        /* 메인 컨테이너 스타일 */
        .mypage-container {
            display: flex;
            flex-wrap: nowrap; /* 줄바꿈 방지 */
            align-items: stretch; /* 높이 균일하게 */
            padding: 20px;
        }

        /* 사이드바 스타일 */
        .sidebar {
            width: 220px;
            background-color: #f8f9fa;
            padding: 20px;
            border-right: 1px solid #ccc;
            height: 100vh;
            position: sticky;
            top: 20px;
        }
        .sidebar .nav-link {
            cursor: pointer;
            font-size: 18px;
            padding: 10px;
            color: #333;
            display: block;
            text-decoration: none;
            transition: background-color 0.3s;
        }
        .sidebar .nav-link:hover, .sidebar .nav-link.active {
            background-color: #007bff;
            color: white;
            border-radius: 5px;
        }

        /* 본문 영역 스타일 */
        .content {
            flex-grow: 1;
            padding: 30px;
            background-color: #e9ecef;
            border: 1px solid #ccc;
            min-height: 600px;
        }

        /* 처음에는 개인정보 수정 화면만 보이도록 설정 */
        .content-section {
            display: none;
        }
        #profile-section {
            display: block; /* 기본적으로 개인정보 수정 표시 */
        }
    </style>
</head>
<body>

<!-- 헤더 포함 -->
<header id="top-header">
    <jsp:include page="/WEB-INF/views/layout/nav.jsp" />
</header>

<!-- 마이페이지 메인 컨테이너 -->
<div class="mypage-container container">
    <!-- 사이드바 메뉴 -->
    <div class="sidebar">
        <ul class="nav flex-column">
            <li class="nav-item">
                <span class="nav-link active" onclick="showSection('profile')">개인정보 수정</span>
            </li>
            <li class="nav-item">
                <span class="nav-link" onclick="showSection('history')">나의 히스토리</span>
            </li>
        </ul>
    </div>

    <!-- 본문 영역 -->
    <div class="content">
        <!-- 개인정보 수정 -->
        <div id="profile-section" class="content-section">
            <jsp:include page="/WEB-INF/views/mypage/updateForm.jsp" />
        </div>

        <!-- 여행 히스토리 -->
        <div id="history-section" class="content-section">
            <jsp:include page="/WEB-INF/views/mypage/hitory.jsp" />
        </div>
    </div>
</div>

<!-- chatbot 포함 -->
<jsp:include page="/WEB-INF/views/mypage/chatbot.jsp" />

<!-- 푸터 포함 -->
<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

<!-- JavaScript -->
<script>
    function showSection(section) {
        // 모든 섹션 숨기기
        document.querySelectorAll('.content-section').forEach(el => el.style.display = 'none');
        // 선택한 섹션 보이기
        document.getElementById(section + '-section').style.display = 'block';

        // 모든 메뉴에서 active 제거 후, 선택한 메뉴만 active 추가
        document.querySelectorAll('.sidebar .nav-link').forEach(el => el.classList.remove('active'));
        event.target.classList.add('active');
    }
</script>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
