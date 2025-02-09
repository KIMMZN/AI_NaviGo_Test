package com.nevigo.ai_navigo.controller;


import com.nevigo.ai_navigo.dao.IF_LoginDao;
import com.nevigo.ai_navigo.dto.MemberDTO;
import com.nevigo.ai_navigo.service.IF_LoginService;
import com.nevigo.ai_navigo.service.IF_SignUpService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class loginController {
    @Autowired
    private IF_LoginService loginService;
    @Autowired
    private HttpSession session;

    @PostMapping("/isLogin")
    @ResponseBody
    public String login(@ModelAttribute MemberDTO member) {
        if(loginService.isMemberId(member) == 1){
            if(loginService.isMemberPw(member) != 0){
                MemberDTO memberDTO = loginService.getMemberInfo(member);
                session.setAttribute("memberInfo", memberDTO);
            }else{
                return "비밀번호가 틀립니다.";
            }
        }else{
            return "존재하지 않는 계정입니다.";
        }
        return "ok";
    }

    @PostMapping("/auth/sign_in")
    public String signIn(@ModelAttribute MemberDTO member) {
        return "redirect:/main";
    }

    @PostMapping("/logout")
    public String logout(HttpSession session) {
        session.removeAttribute("memberInfo");
        return "redirect:/main";
    }
}
