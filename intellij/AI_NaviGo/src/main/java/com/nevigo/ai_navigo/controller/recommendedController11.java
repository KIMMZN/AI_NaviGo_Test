//package com.nevigo.ai_navigo.controller;
//
//
//import com.nevigo.ai_navigo.dto.MemberDTO;
//import com.nevigo.ai_navigo.dto.UserClickDTO;
//import com.nevigo.ai_navigo.service.IF_preferenceService;
//import jakarta.servlet.http.HttpSession;
//import lombok.RequiredArgsConstructor;
//import org.json.JSONArray;
//import org.springframework.http.HttpStatus;
//import org.springframework.http.ResponseEntity;
//import org.springframework.stereotype.Controller;
//import org.springframework.ui.Model;
//import org.springframework.web.bind.annotation.GetMapping;
//import org.springframework.web.bind.annotation.PostMapping;
//import org.springframework.web.bind.annotation.RequestBody;
//import org.springframework.web.client.RestTemplate;
//
//@Controller
//@RequiredArgsConstructor
//public class recommendedController11 {
//
//    private final IF_preferenceService ifPreferenceService;
//    private final String FASTAPI_URL = "http://127.0.0.1:5000/recommend/";
//    private final RestTemplate restTemplate = new RestTemplate();
//
//    @GetMapping("/main/recommended")
//    public String recommendedController(HttpSession session, Model model) {
//        MemberDTO member = (MemberDTO) session.getAttribute("memberInfo");
//
//        if (member != null) {
//            String memberId = member.getMemberId();
//            System.out.println("✅ Spring Boot - 로그인된 memberId: " + memberId);
//
//            String apiUrl = FASTAPI_URL + memberId;
//            System.out.println("✅ Spring Boot → FastAPI 요청 URL: " + apiUrl);
//
//            try {
//                ResponseEntity<String> response = restTemplate.getForEntity(apiUrl, String.class);
//                if (response.getStatusCode().is2xxSuccessful()) {
//                    System.out.println("✅ FastAPI 응답 데이터: " + response.getBody());
//
//                    // JSON 응답을 JSONArray로 변환
//                    JSONArray recommendations = new JSONArray(response.getBody());
//                    model.addAttribute("recommendations", recommendations);
//                } else {
//                    System.out.println("❌ FastAPI 응답 실패: " + response.getStatusCode());
//                    model.addAttribute("recommendations", new JSONArray());
//                }
//            } catch (Exception e) {
//                System.out.println("❌ FastAPI 호출 오류: " + e.getMessage());
//                model.addAttribute("recommendations", new JSONArray());
//            }
//
//            return "/recommended/recommended";
//        } else {
//            System.out.println("❌ Spring Boot - 로그인 정보 없음 (세션에 memberInfo 없음).");
//            return "redirect:/main";
//        }
//    }
//
//    @GetMapping("main/recommend/detail")
//    public String detailController(HttpSession session, Model model) throws Exception {
//
//
//        return "/recommended/detail";
//    }
//
//    @PostMapping("/recordClick")
//    public ResponseEntity<String> recordUserClick(HttpSession session,
//                                                  @RequestBody UserClickDTO userClickDTO) throws Exception {
//        MemberDTO member = (MemberDTO) session.getAttribute("memberInfo");
//        if(member != null) {
//            String memberId = member.getMemberId();
//            userClickDTO.setMember_id(memberId);
//
////            String contentid = userClickDTO.getContentid();
////            String cat1 = userClickDTO.getCat1();
////            String cat2 = userClickDTO.getCat2();
////            String cat3 = userClickDTO.getCat3();
//
//            ifPreferenceService.clickTravelOne(userClickDTO);
//
//
////            System.out.println("memberId: " + memberId + " /// contentid: " + contentid +
////                    " /// cat1: " + cat1 + " /// cat2: " + cat2 + " /// cat3: " + cat3);
//            System.out.println(userClickDTO.toString());
//
////            ifPreferenceService.saveUserClick(memberId, contentid);
//            //
//            return ResponseEntity.ok("Click recorded");
//        }
//        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("User not logged in");
//    }
//
//
//
//
//}
