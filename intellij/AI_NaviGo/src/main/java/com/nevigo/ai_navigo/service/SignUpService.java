package com.nevigo.ai_navigo.service;

import com.nevigo.ai_navigo.dao.IF_SignUpDao;
import com.nevigo.ai_navigo.dto.MemberDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Map;

@Service
@RequiredArgsConstructor
public class SignUpService implements IF_SignUpService {
    private final IF_SignUpDao signUpDao;

    @Override
    @Transactional
    public int dupCheckId(String dupCheckId) {
        try {
            return signUpDao.dupCheckId(dupCheckId);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    @Transactional
    public int insMember(MemberDTO member) {
        try {
            return signUpDao.insMember(member);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    @Transactional
    public int insPreference(Map<String, Object> map) {
        try {
            System.out.println(map);
            return signUpDao.insPreference(map);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}
