package com.nevigo.ai_navigo.dao;

import com.nevigo.ai_navigo.dto.MemberDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

@Mapper
@Repository
public interface memberUpdateDao {
    MemberDTO findById(@Param("member_id") String memberId);  // 회원 조회
    void updateMember(MemberDTO member);  // 회원 정보 수정
}