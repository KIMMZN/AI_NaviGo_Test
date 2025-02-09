package com.nevigo.ai_navigo.service;

import com.nevigo.ai_navigo.dao.IF_LoginDao;
import com.nevigo.ai_navigo.dao.IF_SignUpDao;
import com.nevigo.ai_navigo.dto.MemberDTO;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class LoginService implements IF_LoginService{
    private final IF_LoginDao loginDao;

    @Override
    @Transactional
    public int isMemberId(MemberDTO member) {
        try {
            return loginDao.isMemberId(member);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    @Transactional
    public int isMemberPw(MemberDTO member) {
        try {
            return loginDao.isMemberPw(member);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    @Transactional
    public MemberDTO getMemberInfo(MemberDTO member) {
        try {
            MemberDTO result = loginDao.getMemberInfo(member);
            return result;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}
