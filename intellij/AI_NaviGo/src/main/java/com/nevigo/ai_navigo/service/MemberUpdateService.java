package com.nevigo.ai_navigo.service;

import com.nevigo.ai_navigo.dto.MemberDTO;

import com.nevigo.ai_navigo.dao.memberUpdateDao;
import org.springframework.stereotype.Service;
import org.springframework.beans.factory.annotation.Autowired;

@Service
public class MemberUpdateService {
    private final memberUpdateDao memberUpdateDao;

    @Autowired // 의존성 주입을 위함 (생성자 주입 방식)
    public MemberUpdateService(memberUpdateDao memberUpdateDao) {
        this.memberUpdateDao = memberUpdateDao; // spring이 주입하는 DAO
    }

    public MemberDTO getMemberById(String memberId) {
        return memberUpdateDao.findById(memberId);  // 변경된 DAO에서 조회
    }

    public void updateMember(MemberDTO member) {
        memberUpdateDao.updateMember(member);  // DAO의 updateMember 메서드 호출
    }
}

