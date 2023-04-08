package com.study.springboot.dto;

import lombok.Data;

@Data
public class QnADto
{
	String qId;
	String mId;
	String qTitle;
	String qContent;
	String qDate;
	String qGroup;
	String qStep;
	String qIndent;
	String qPhoto1; 
	String qPhoto2;
	String qPhoto3;
	String qRead;
}
