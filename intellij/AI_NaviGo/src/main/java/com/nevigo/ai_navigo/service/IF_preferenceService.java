package com.nevigo.ai_navigo.service;

import com.nevigo.ai_navigo.dto.UserClickDTO;

public interface IF_preferenceService {

    public String getPreferenceById(String memberId) throws Exception;
    public void clickTravelOne(UserClickDTO userclickdto) throws Exception;
}
