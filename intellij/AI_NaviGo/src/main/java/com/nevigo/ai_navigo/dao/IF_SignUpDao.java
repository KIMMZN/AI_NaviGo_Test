package com.nevigo.ai_navigo.dao;

import com.nevigo.ai_navigo.dto.MemberDTO;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.Map;

@Mapper
@Repository
public interface IF_SignUpDao {
    // 사용자 아이디 중복 체크
    public int dupCheckId(String memberId);
    public int insMember(MemberDTO member);
    public int insPreference(Map<String, Object> member);
}
