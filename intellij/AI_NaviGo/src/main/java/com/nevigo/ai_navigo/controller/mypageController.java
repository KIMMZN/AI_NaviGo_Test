package com.nevigo.ai_navigo.controller;
import com.nevigo.ai_navigo.service.MemberUpdateService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import com.nevigo.ai_navigo.dto.MemberDTO;
import com.nevigo.ai_navigo.dao.memberUpdateDao;

@Controller
@RequestMapping("/mypage")
public class mypageController {

    private final MemberUpdateService memberService;  // DAO가 아닌 Service 주입

    @Autowired
    public mypageController(MemberUpdateService memberService) {
        this.memberService = memberService;  // 서비스 주입
    }

    @GetMapping
    public String mypage(Model model, HttpSession session) {
        String memberId = (String) session.getAttribute("memberId");

        // memberService를 통해 findById 호출
        MemberDTO member = memberService.getMemberById(memberId);  // Service 사용
        model.addAttribute("member", member);
        return "/mypage/mypage";  // mypage.jsp로 이동
    }

    @GetMapping("/update")
    public String update(@RequestParam("memberId") String memberId, Model model) {
        MemberDTO member = memberService.getMemberById(memberId);  // 서비스 호출
        model.addAttribute("member", member);
        return "/updateForm";  // updateForm.jsp로 이동
    }

    @PostMapping("/update")
    public String updateMember(@ModelAttribute MemberDTO member, HttpSession session) {
        String memberId = (String) session.getAttribute("memberId");

        //member.setMemberId(memberId);  // 세션에서 ID를 가져와 설정
        memberService.updateMember(member);  // 서비스 호출하여 회원 정보 업데이트
        return "redirect:/mypage/update";  // 업데이트 후 마이페이지로 리다이렉트
    }
}