<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>여행 분야 선택 - AI NaviGo</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/style.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/main.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>

    <style>
        .container {
            max-width: 1000px;
            margin: 40px auto;
            padding: 20px;
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        .card {
            cursor: pointer;
            text-align: center;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 10px;
            box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s;
        }
        .card:hover {
            transform: scale(1.05);
        }
        .card-title {
            font-size: 1.2rem;
            font-weight: bold;
        }
        .card-text {
            font-size: 1rem;
            color: #666;
        }
        .selected-card {
            background-color: #f0f0f0; /* 연한 회색으로 설정 */
            color: #333; /* 텍스트 색상도 어두운 색으로 설정 */
        }
    </style>
</head>
<body>
<header id="top-header">
    <jsp:include page="/WEB-INF/views/layout/nav.jsp" />
</header>

<div class="container">
    <h2 class="text-center mb-4">선호 여행 취향 선택</h2>
    <div class="row">
        <!-- 여행 분야 카드 -->
        <div class="col-12 col-md-3 mb-4">
            <div class="card" onclick="selectCategory('자연 관광지', this)">
                <div class="card-body">
                    <h5 class="card-title">자연 관광지</h5>
                    <p class="card-text">자연 속에서의 여행을 원하시면 선택하세요.</p>
                </div>
            </div>
        </div>

        <div class="col-12 col-md-3 mb-4">
            <div class="card" onclick="selectCategory('휴양 관광지', this)">
                <div class="card-body">
                    <h5 class="card-title">휴양 관광지</h5>
                    <p class="card-text">편안하게 쉬고 싶은 여행을 원하시면 선택하세요.</p>
                </div>
            </div>
        </div>

        <div class="col-12 col-md-3 mb-4">
            <div class="card" onclick="selectCategory('역사 관광지', this)">
                <div class="card-body">
                    <h5 class="card-title">역사 관광지</h5>
                    <p class="card-text">역사적인 장소를 탐방하는 여행을 원하시면 선택하세요.</p>
                </div>
            </div>
        </div>

        <div class="col-12 col-md-3 mb-4">
            <div class="card" onclick="selectCategory('음식 탐방', this)">
                <div class="card-body">
                    <h5 class="card-title">음식 탐방</h5>
                    <p class="card-text">맛있는 음식을 즐기고 싶다면 선택하세요.</p>
                </div>
            </div>
        </div>

        <div class="col-12 col-md-3 mb-4">
            <div class="card" onclick="selectCategory('육상 레포츠', this)">
                <div class="card-body">
                    <h5 class="card-title">육상 레포츠</h5>
                    <p class="card-text">액티브한 운동을 즐기고 싶다면 선택하세요.</p>
                </div>
            </div>
        </div>

        <div class="col-12 col-md-3 mb-4">
            <div class="card" onclick="selectCategory('문화시설', this)">
                <div class="card-body">
                    <h5 class="card-title">문화시설</h5>
                    <p class="card-text">문화적인 경험을 원하는 분들을 위한 여행입니다.</p>
                </div>
            </div>
        </div>

        <div class="col-12 col-md-3 mb-4">
            <div class="card" onclick="selectCategory('힐링 코스', this)">
                <div class="card-body">
                    <h5 class="card-title">힐링 코스</h5>
                    <p class="card-text">마음과 몸을 치유하는 여행을 원하시면 선택하세요.</p>
                </div>
            </div>
        </div>

        <div class="col-12 col-md-3 mb-4">
            <div class="card" onclick="selectCategory('쇼핑', this)">
                <div class="card-body">
                    <h5 class="card-title">쇼핑</h5>
                    <p class="card-text">쇼핑을 즐기고 싶다면 이 카드를 선택하세요.</p>
                </div>
            </div>
        </div>
    </div>

    <form id="categoryForm" action="/sign_card_result" method="POST" style="display: none;">
        <input type="hidden" name="selectedCategory" id="selectedCategoryInput">
    </form>

    <!-- 다음 버튼 -->
    <div class="d-flex justify-content-between mt-4">
        <button type="button" class="btn btn-secondary" onclick="window.history.back()">Cancel</button>
        <button type="button" class="btn btn-primary" id="nextBtn">Sign Up</button>
    </div>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

<script>
    let selectedCard = null;  // 현재 선택된 카드
    let selectedCategoryTitle = '';  // 선택된 카테고리의 title

    function selectCategory(category, cardElement) {
        // 이미 선택된 카드가 있을 경우 색상 초기화
        if (selectedCard) {
            selectedCard.classList.remove('selected-card');
        }

        // 선택된 카드에 색상 추가
        cardElement.classList.add('selected-card');
        selectedCard = cardElement;

        // 선택한 여행 분야를 로컬 스토리지에 저장
        localStorage.setItem('selectedCategory', category);

        // 선택된 카드의 제목 저장
        selectedCategoryTitle = cardElement.querySelector('.card-title').innerText;
    }

    document.getElementById('nextBtn').addEventListener('click', function() {
        // 선택된 카드가 있는 경우, 선택된 카테고리의 제목을 alert로 띄움
        if (selectedCard) {
            // 선택된 카테고리를 폼에 설정
            document.getElementById('selectedCategoryInput').value = localStorage.getItem('selectedCategory');

            // 폼을 제출하여 백엔드로 데이터 전송
            document.getElementById('categoryForm').submit();
        } else {
            alert("여행 분야를 선택해주세요.");
        }
    });

</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
