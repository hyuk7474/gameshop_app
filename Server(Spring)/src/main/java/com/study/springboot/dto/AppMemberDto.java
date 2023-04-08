package com.study.springboot.dto;

import lombok.Data;

@Data
public class AppMemberDto
{
	String mId;
	String mPw;
	String mName;
	String mEmail;
	String mPnum;
	int mBlack;
	int enabled;
}
