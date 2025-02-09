<%--
  Created by IntelliJ IDEA.
  User: Moon yebin
  Date: 25. 2. 4.
  Time: 오후 2:04
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>updateForm</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/style.css"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/main.css"/>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
  <style>
    .google-btn {
      background-color: white;
      border: 2px solid #ccc;
      color: black;
    }
    .google-btn:hover {
      border-color: #888;
    }
    .custom-divider {
      margin: 8px 0;
    }
    .sign-up-divider {
      margin: 24px 0;
    }
  </style>
</head>

<body>

<div class="update-container">
  <h2>회원 정보 수정</h2>
</div>

<!-- chatbot 포함 -->
<jsp:include page="/WEB-INF/views/mypage/chatbot.jsp" />





<!-- Bootstrap JS (Popper.js 포함) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>