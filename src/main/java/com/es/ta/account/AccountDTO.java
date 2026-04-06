package com.es.ta.account;
import com.google.gson.Gson;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class AccountDTO {

    private int user_id;
    private String loginId;
    private String password;
    private String name;
    private String gender;
    private Date birthDate;
    private String email;


    public String toJSON(){
        Gson gson =new Gson();
        return gson.toJson(this);
    }

}