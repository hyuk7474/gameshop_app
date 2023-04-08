package com.study.springboot.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.study.springboot.dto.AddressDto;
import com.study.springboot.dto.AppMemberDto;
import com.study.springboot.dto.PaidDto;
import com.study.springboot.dto.QnADto;

@Mapper
public interface IAppGSDao
{
	public int join(String mId, String mPw, String mName, String mEmail, String mPnum);
	public AppMemberDto login(String mId);
	public int modify(String mId, String mName, String mEmail, String mPnum);
	public int modifyPW(String mId, String mPw);
	
	public int addAddress(String mId, String aName, String aZipcode, String aMain, String aSub, String aPrimary);
	public AddressDto checkANameDuplicated(String mId, String aName);
	public int makeNotPrimary(String mId, String aName);
	public List<AddressDto> getAddressList(String mId);
	public int deleteAddress(String mId, String aName);
	public int modifyAInfo(String mId, String oriName, String aName, String aZipcode, String aMain, String aSub, String aPrimary);
	
	public int writeQnA(Map<String, Object> mQnAInfo);
	public List<QnADto> getQnAList(String mId);
	public int deleteQnA(String qId);
	public int modifyQnA(Map<String, Object> mQnAInfo);
	public QnADto getModifiedQnA(String qId);
	
	public int addPaidInfo(Map<String, Object> paidInfo);
	public List<PaidDto> getPaidList(String mId);
	
	// 웹용
	public AddressDto findaName(String aName);
	public AddressDto findaPrimary(String mId);
	
//	public int write(@Param("bName") String bName, @Param("bTitle") String bTitle, @Param("bContent") String bContent);
//	public int getContentCount();
//	public BDto contentView(@Param("strId") String strId);
//	public int delete(@Param("bId") String bId);
//	public ArrayList<BDto> list(@Param("nEnd") int nEnd, @Param("nStart") int nStart);
//	public int modify(@Param("bName") String bName, @Param("bTitle") String bTitle, @Param("bContent") String bContent, @Param("bId") String bId);
//	// Integer.parseInt(bId)-modify
//	public int reply(@Param("bId") String bId, @Param("bName") String bName, @Param("bTitle") String bTitle, @Param("bContent") String bContent, @Param("bGroup") String bGroup, @Param("bStep") String bStep, @Param("bIndent") String bIndent);
//	public BDto reply_view(@Param("bId") String bId);
//	public int replyShape(@Param("strGroup") String strGroup, @Param("strStep") String strStep);
//	public int upHit(@Param("strId") String strId);
//	public ArrayList<BCommentInfo> commentList(String bId);
}
