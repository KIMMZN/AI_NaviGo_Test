package com.nevigo.ai_navigo.service;

import com.nevigo.ai_navigo.dto.MemberDTO;

public interface IF_LoginService {
    public int isMemberId(MemberDTO member);
    public int isMemberPw(MemberDTO member);
    public MemberDTO getMemberInfo(MemberDTO member);
}
