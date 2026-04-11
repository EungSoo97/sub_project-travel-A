package com.es.ta.userreaction;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class UserreactionDTO {
    
    // Review fields
    private int reviewId;
    private int planId;
    private int userId;
    private String content;
    private Date createdAt;
    private String userName; // For display purposes
    private String city;      // rs.getString("destination") 값을 담을 변수
    private int duration;     // rs.getInt("days") 값을 담을 변수
    private String planTitle; // rs.getString("plan_title") 값을 담을 변수


    // Like fields
    private int likeId;
    private boolean isLiked;
    
    // Constructor for review
    public UserreactionDTO(int reviewId, int planId, int userId, String content, Date createdAt, String userName) {
        this.reviewId = reviewId;
        this.planId = planId;
        this.userId = userId;
        this.content = content;
        this.createdAt = createdAt;
        this.userName = userName;
    }
    
    // Constructor for like
    public UserreactionDTO(int likeId, int planId, int userId, boolean isLiked) {
        this.likeId = likeId;
        this.planId = planId;
        this.userId = userId;
        this.isLiked = isLiked;
    }
}
