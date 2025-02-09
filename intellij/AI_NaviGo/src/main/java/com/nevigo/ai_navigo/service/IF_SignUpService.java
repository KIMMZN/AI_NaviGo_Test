package com.nevigo.ai_navigo.service;

import com.nevigo.ai_navigo.dto.MemberDTO;

import java.util.Map;

public interface IF_SignUpService {
    public int dupCheckId(String dupCheckId);
    public int insMember(MemberDTO member);
    public int insPreference(Map<String, Object> preference);
}