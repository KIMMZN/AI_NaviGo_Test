<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>회원가입 - AI NaviGo</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/style.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/main.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <style>
        .container {
            max-width: 500px;
            margin: 40px auto;
            padding: 20px;
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        .form-label {
            font-weight: bold;
        }
        .form-group {
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
<header id="top-header">
    <jsp:include page="/WEB-INF/views/layout/nav.jsp" />
</header>

<div class="container">
    <h2 class="text-center">회원가입</h2>
    <form action="/signResult" method="post">
        <div class="form-group">
            <label for="member_name" class="form-label">이름</label>
            <input type="text" class="form-control" id="member_name" name="memberName" required>
        </div>
        <div class="form-group">
            <label for="member_id" class="form-label">아이디</label>
            <div class="input-group">
                <input type="text" class="form-control" id="member_id" name="memberId" required>
                <input type="hidden" id="hidden_member_id" name="memberId">
                <button type="button" class="btn btn-secondary" id="checkIdBtn">중복 확인</button>
            </div>
        </div>
        <div class="form-group">
            <label for="member_pw" class="form-label">비밀번호</label>
            <input type="password" class="form-control" id="member_pw" name="memberPw" required>
        </div>
        <div class="form-group">
            <label class="form-label">성별</label>
            <select class="form-control" name="memberGender">
                <option value="M">남성</option>
                <option value="F">여성</option>
            </select>
        </div>
        <div class="d-flex justify-content-between mt-4">
            <button type="button" class="btn btn-secondary" onclick="window.history.back()">Cancel</button>
            <button type="submit" class="btn btn-primary">Next</button>
        </div>
    </form>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

<script>
    function showVerificationInput() {
        document.getElementById('verification-group').style.display = 'block';
    }

    //아이디 중복 확인을 위한 function
    $(document).ready(function() {
        $("#checkIdBtn").click(function() { // "중복 확인" 버튼 클릭 시 실행
            var userId = $("#member_id").val(); // 입력된 ID 값 가져오기

            if (userId.trim() === "") {
                alert("아이디를 입력해주세요.");
                return;
            }
            $.ajax({
                type: "POST",
                url: "/dupCheckId",
                data: { id: userId },
                success: function(response) {
                    if (response === '사용 가능한 ID 입니다.') {
                        // 입력창과 버튼을 비활성화
                        $("#member_id").prop("disabled", true);
                        $("#checkIdBtn").prop("disabled", true);
                        $("#hidden_member_id").val(userId); // hidden input에 값 설정
                        alert(response); // 사용 가능 메시지 출력
                    } else {
                        // 입력창을 비우기
                        $("#member_id").val("");
                        alert("사용할 수 없는 ID입니다. 다시 입력해주세요.");
                    }
                },
                error: function(xhr, status, error) {
                    console.error("AJAX 오류:", error);
                }
            });
        });
    });

</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
