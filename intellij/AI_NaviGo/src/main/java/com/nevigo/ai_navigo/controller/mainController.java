package com.nevigo.ai_navigo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class mainController {
    @GetMapping("/main")
    public String mainPage() {
        return "/main/home"; // home.html 파일과 매핑
    }
}
