<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!-- nav.jsp -->
<nav class="navbar navbar-expand-lg navbar-light" style="background-color: #e8f1fa;">
    <div class="container-fluid">
        <!-- 로고 포함 -->
        <jsp:include page="/WEB-INF/views/layout/header.jsp" />

        <!-- 토글 버튼 (햄버거 메뉴) -->
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mainNavbar"
                aria-controls="mainNavbar" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <!-- 실제 메뉴 -->
        <div class="collapse navbar-collapse" id="mainNavbar">
            <ul class="navbar-nav ms-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link" href="#">추천 여행지</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#">AI여행지 생성</a>
                </li>

                <%-- session에 memberInfo가 있으면 마이 페이지와 Logout 버튼 표시 --%>
                <% if (session.getAttribute("memberInfo") != null) { %>
                <li class="nav-item">
                    <a class="nav-link" href="/mypage">마이 페이지</a>
                </li>
                <li class="nav-item">
                    <form action="/logout" method="post">
                        <button class="btn btn-primary ms-2" data-bs-toggle="modal" type="submit">Logout</button>
                    </form>
                </li>
                <% } else { %>
                <%-- session에 memberInfo가 없으면 Sign In 버튼만 표시 --%>
                <li class="nav-item">
                    <button class="btn btn-primary ms-2" data-bs-toggle="modal" data-bs-target="#signInModal">Sign In</button>
                </li>
                <% } %>
            </ul>
        </div>
    </div>
</nav>