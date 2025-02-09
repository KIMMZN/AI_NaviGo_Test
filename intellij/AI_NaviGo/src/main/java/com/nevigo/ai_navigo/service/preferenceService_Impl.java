package com.nevigo.ai_navigo.service;

import com.nevigo.ai_navigo.dao.IF_preferenceDao;
import com.nevigo.ai_navigo.dto.UserClickDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@RequiredArgsConstructor
@Service
public class preferenceService_Impl implements IF_preferenceService{

    private final IF_preferenceDao ifpreferencedao;

    @Override
    public String getPreferenceById(String memberId) throws Exception {

        String purpose = ifpreferencedao.getPreferenceById(memberId);

        if(purpose != null) {
            if (purpose.equals("자연 관광지")) {
                purpose = "A0101";
            }else if(purpose.equals("휴양 관광지")) {
                purpose = "A0202";
            }else if(purpose.equals("쇼핑")) {
                purpose = "A0401";
            }else  if(purpose.equals("역사 관광지")) {
                purpose = "A0201";
            }else if(purpose.equals("음식 탐방")) {
                purpose = "A0502";
            }else if(purpose.equals("육상 레포츠")) {
                purpose = "A0302";
            }else if(purpose.equals("문화시설")) {
                purpose = "A0206";
            }else if(purpose.equals("힐링 코스")) {
                purpose = "C0114";
            }
        }

        //디버그
        System.out.println("서비스단 선호도: "+ purpose);

        return purpose;
    }

    @Override
    public void clickTravelOne(UserClickDTO userclickdto) throws Exception {

        ifpreferencedao.setUserClickInfo(userclickdto);
    }
}
