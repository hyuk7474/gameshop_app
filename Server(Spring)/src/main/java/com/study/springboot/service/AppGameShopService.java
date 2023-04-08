package com.study.springboot.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.study.springboot.dao.IAppGSDao;
import com.study.springboot.dto.AddressDto;
import com.study.springboot.dto.AppMemberDto;
import com.study.springboot.dto.PaidDto;
import com.study.springboot.dto.QnADto;

@Service
public class AppGameShopService implements IAppGameShopService
{
	
	@Autowired
	IAppGSDao appDao;

	int nResult = 0;

	@Override
	public int join(String mId, String mPw, String mName, String mEmail, String mPnum)
	{
		nResult = appDao.join(mId, mPw, mName, mEmail, mPnum);	
			
		return nResult;		
		
	}

	@Override
	public AppMemberDto login(String mId)
	{			
		return appDao.login(mId);
	}

	@Override
	public int modify(String mId, String mName, String mEmail, String mPnum)
	{
		nResult = appDao.modify(mId, mName, mEmail, mPnum);	
		
		return nResult;
	}

	@Override
	public int addAddress(String mId, String aName, String aZipcode, String aMain, String aSub, String aPrimary)
	{
		nResult = 0;		
		AddressDto aDto = appDao.checkANameDuplicated(mId ,aName);
		
		System.out.println(aDto!=null);
		
		
		if(aDto==null||aDto.equals("")) {
			nResult = appDao.addAddress(mId, aName, aZipcode, aMain, aSub, aPrimary);
			if(aPrimary.equals("1")) {
				int nNotPrimary = appDao.makeNotPrimary(mId, aName);
				System.out.printf("PrimaryUpdated: %d \n", nNotPrimary);				
			}
		} else {
			nResult =2;
		}
		
		return nResult;
	}

	@Override
	public List<AddressDto> getAddressList(String mId)
	{
		return appDao.getAddressList(mId);
	}

	@Override
	public int deleteAddress(String mId, String aName)
	{
		nResult = appDao.deleteAddress(mId, aName); 
		return nResult;
	}

	@Override
	public int modifyAInfo(String mId, String oriName, String aName, String aZipcode, String aMain, String aSub,
			String aPrimary)
	{		
		nResult = 0;		
		AddressDto aDto = appDao.checkANameDuplicated(mId ,aName);
		
		System.out.println(aDto!=null);
		
		if(aDto==null) {
			nResult = appDao.modifyAInfo(mId, oriName, aName, aZipcode, aMain, aSub, aPrimary);
			int nNotPrimary = appDao.makeNotPrimary(mId, aName);
			System.out.printf("PrimaryUpdated: %d \n", nNotPrimary);
		} else if(aDto!=null) {
			if(!aDto.getaZipcode().equals(aZipcode)||!aDto.getaMain().equals(aMain)||!aDto.getaSub().equals(aSub)||!aDto.getaPrimary().equals(aPrimary)) {
				nResult = appDao.modifyAInfo(mId, oriName, aName, aZipcode, aMain, aSub, aPrimary);
				int nNotPrimary = appDao.makeNotPrimary(mId, aName);
				System.out.printf("PrimaryUpdated: %d \n", nNotPrimary);				
			} else {
				nResult=2;
			}
		}
		
		return nResult;
	}
	
	@Override
	public int writeQnA(Map<String, Object> mQnAInfo)
	{
		nResult = appDao.writeQnA(mQnAInfo);
		return nResult;
	}

	@Override
	public List<QnADto> getQnAList(String mId)
	{
		return appDao.getQnAList(mId);
	}

	@Override
	public int deleteQnA(String qId)
	{
		nResult = appDao.deleteQnA(qId);
		return nResult;
	}

	@Override
	public int modifyQnA(Map<String, Object> mQnAInfo)
	{
		nResult = appDao.modifyQnA(mQnAInfo);
		return nResult;
	}

	@Override
	public QnADto getModifiedQnA(String qId)
	{		
		return appDao.getModifiedQnA(qId);
	}
	
	@Override
	public int addPaidInfo(Map<String, Object> paidInfo)
	{
		nResult = appDao.addPaidInfo(paidInfo);		
		return nResult;
	}
	
	@Override
	public List<PaidDto> getPaidList(String mId)
	{		
		return appDao.getPaidList(mId);
	}
	
	@Override
	public int modifyPW(String mId, String mPw)
	{
		nResult = appDao.modifyPW(mId, mPw);
		return nResult;
	}
	
	// 웹용
	@Override
	public AddressDto findaName(String aName) {
		return appDao.findaName(aName);
	}

	@Override
	public AddressDto findaPrimary(String mId) {
		return appDao.findaPrimary(mId);
	}

	

	
}
