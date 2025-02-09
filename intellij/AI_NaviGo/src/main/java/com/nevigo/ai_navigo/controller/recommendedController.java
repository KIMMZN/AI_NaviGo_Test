package com.nevigo.ai_navigo.controller;

import com.nevigo.ai_navigo.dto.MemberDTO;
import com.nevigo.ai_navigo.dto.UserClickDTO;
import com.nevigo.ai_navigo.service.IF_preferenceService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.http.*;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import java.net.URI;
import java.nio.charset.StandardCharsets;

@Controller
@RequiredArgsConstructor
public class recommendedController {

    private final IF_preferenceService ifPreferenceService;
    private final RestTemplate restTemplate = new RestTemplate();

    // FastAPI URL
    private static final String FASTAPI_URL = "http://127.0.0.1:5000/recommend/";

    // 공공데이터 API 기본 URL (마지막의 '?' 제거)
    private static final String BASE_API_URL = "http://apis.data.go.kr/B551011/KorService1/areaBasedList1";

    // 이미 URL 인코딩된 키(포털에서 제공된 Encoding 버전) 사용하거나,
    // 디코딩된 상태라면 별도 URLEncoder.encode(...) 하지 않음
    // 예: 인코딩된 값: "zEp9kLeLZiXElh6mddTl2DXHIl44C4brxSyQojUBO6zjiy25apv9Dvh00sygk%2BKzMuXzMv3zKpoylWiGbVlCLA%3D%3D"
    // 또는 디코딩된 값: "zEp9kLeLZiXElh6mddTl2DXHIl44C4brxSyQojUBO6zjiy25apv9Dvh00sygk+KzMuXzMv3zKpoylWiGbVlCLA=="
    // [예시] 이미 인코딩된 값 그대로 사용:
    private static final String SERVICE_KEY = "zEp9kLeLZiXElh6mddTl2DXHIl44C4brxSyQojUBO6zjiy25apv9Dvh00sygk%2BKzMuXzMv3zKpoylWiGbVlCLA%3D%3D";
    // 만약 디코딩된 키라면 이렇게 설정:
    // private static final String SERVICE_KEY = "zEp9kLeLZiXElh6mddTl2DXHIl44C4brxSyQojUBO6zjiy25apv9Dvh00sygk+KzMuXzMv3zKpoylWiGbVlCLA==";

    @GetMapping("/main/recommended")
    public String recommendedController(HttpSession session, Model model) {
        // 세션 체크
        MemberDTO member = (MemberDTO) session.getAttribute("memberInfo");
        if (member == null) {
            System.out.println("❌ [recommendedController] 세션에 memberInfo 없음 → 메인 페이지로");
            return "redirect:/main";
        }
        String memberId = member.getMemberId();
        System.out.println("✅ [recommendedController] 로그인된 memberId: " + memberId);

        // FastAPI 호출
        String recommendedCat3 = callFastAPI(memberId);
        if (recommendedCat3 == null) {
            System.out.println("❌ [recommendedController] recommendedCat3 = null");
            model.addAttribute("items", new JSONArray());
            return "/recommended/recommended";
        }

        // 공공데이터 API 호출
        try {
            // 1) UriComponentsBuilder 사용
            //    .build(true) → 이미 인코딩된 파라미터를 추가 인코딩하지 않음
            //    (또는 디코딩된 키라면 builder가 자동 인코딩)
            URI uri = UriComponentsBuilder
                    .fromHttpUrl(BASE_API_URL)
                    .queryParam("serviceKey", SERVICE_KEY)
                    .queryParam("numOfRows", 9)
                    .queryParam("pageNo", 1)
                    .queryParam("MobileOS", "ETC")
                    .queryParam("MobileApp", "AppTest")
                    .queryParam("_type", "json")
                    .queryParam("listYN", "Y")
                    .queryParam("arrange", "R")
                    .queryParam("cat3", recommendedCat3)
                    .build(true)   // true → 기존 파라미터 그대로 (중복 인코딩X)
                    .toUri();

            System.out.println("✅ [recommendedController] 최종 요청 URI: " + uri);

            // 2) 헤더 설정
            HttpHeaders headers = new HttpHeaders();
            headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
            headers.set("User-Agent", "Mozilla/5.0");

            HttpEntity<?> entity = new HttpEntity<>(headers);

            // 3) 실제 요청
            ResponseEntity<String> response = restTemplate.exchange(
                    uri,
                    HttpMethod.GET,
                    entity,
                    String.class
            );

            // 4) 응답 파싱
            System.out.println("✅ [recommendedController] 응답 상태: " + response.getStatusCode());
            System.out.println("✅ [recommendedController] 응답 헤더: " + response.getHeaders());
            String responseBody = response.getBody();
            System.out.println("✅ [recommendedController] 응답 바디: " + responseBody);

            if (response.getStatusCode() == HttpStatus.OK && responseBody != null) {
                JSONObject jsonObj = new JSONObject(responseBody);

                if (jsonObj.has("response")) {
                    JSONObject respObj = jsonObj.getJSONObject("response");
                    if (respObj.has("body")
                            && respObj.getJSONObject("body").has("items")
                            && respObj.getJSONObject("body").getJSONObject("items").has("item")) {

                        JSONArray items = respObj
                                .getJSONObject("body")
                                .getJSONObject("items")
                                .getJSONArray("item");
                        model.addAttribute("items", items);
                    } else {
                        System.out.println("❌ [recommendedController] 'item' 배열 없음.");
                        model.addAttribute("items", new JSONArray());
                    }
                } else {
                    System.out.println("❌ [recommendedController] 'response' 키 없음.");
                    model.addAttribute("items", new JSONArray());
                }
            } else {
                System.out.println("❌ [recommendedController] 응답 코드 200이 아니거나 바디가 null");
                model.addAttribute("items", new JSONArray());
            }
        } catch (Exception e) {
            System.out.println("❌ [recommendedController] 공공데이터 API 오류: " + e.getMessage());
            e.printStackTrace();
            model.addAttribute("items", new JSONArray());
        }

        return "/recommended/recommended";
    }

    /**
     * FastAPI 호출 (AI 추천)
     */
    private String callFastAPI(String memberId) {
        String url = FASTAPI_URL + memberId;
        System.out.println("✅ [callFastAPI] FastAPI 호출 URL: " + url);

        try {
            HttpHeaders headers = new HttpHeaders();
            headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
            headers.set("User-Agent", "Mozilla/5.0");

            HttpEntity<?> entity = new HttpEntity<>(headers);

            ResponseEntity<String> response = restTemplate.exchange(
                    url,
                    HttpMethod.GET,
                    entity,
                    String.class
            );

            System.out.println("✅ [callFastAPI] 응답 상태: " + response.getStatusCode());
            System.out.println("✅ [callFastAPI] 응답 헤더: " + response.getHeaders());
            System.out.println("✅ [callFastAPI] 응답 바디: " + response.getBody());

            if (response.getStatusCode() == HttpStatus.OK && response.getBody() != null) {
                JSONObject jsonResponse = new JSONObject(response.getBody());
                return jsonResponse.optString("cat3", null);
            }
        } catch (Exception e) {
            System.out.println("❌ [callFastAPI] FastAPI 오류: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    @GetMapping("main/recommend/detail")
    public String detailController(HttpSession session, Model model) {
        return "/recommended/detail";
    }

    @PostMapping("/recordClick")
    public ResponseEntity<String> recordUserClick(
            HttpSession session,
            @RequestBody UserClickDTO userClickDTO
    ) throws Exception {
        MemberDTO member = (MemberDTO) session.getAttribute("memberInfo");
        if (member != null) {
            String memberId = member.getMemberId();
            userClickDTO.setMember_id(memberId);
            ifPreferenceService.clickTravelOne(userClickDTO);
            System.out.println("[recordClick] " + userClickDTO);
            return ResponseEntity.ok("Click recorded");
        }
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("User not logged in");
    }
}
