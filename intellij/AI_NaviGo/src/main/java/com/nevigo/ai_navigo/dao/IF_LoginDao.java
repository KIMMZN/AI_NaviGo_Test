package com.nevigo.ai_navigo.dao;

import com.nevigo.ai_navigo.dto.MemberDTO;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

@Mapper
@Repository
public interface IF_LoginDao {
    public int isMemberId(MemberDTO member);
    public int isMemberPw(MemberDTO member);
    public MemberDTO getMemberInfo(MemberDTO member);
}
