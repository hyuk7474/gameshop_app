package com.study.springboot.dto;

import java.sql.Timestamp;

public class PaidDto
{
	int pNum;
	String pId;
	String mId;
	String totalPrice;
	int aZipcode;
	String aMain;
	String aSub;
	String pDeliverymemo;
	Timestamp pDate;
	int pStatus;
	String adrName;
	
	public PaidDto() {}

	public PaidDto(int pNum, String pId, String mId, String totalPrice, int aZipcode, String aMain, String aSub,
			String pDeliverymemo, Timestamp pDate, int pStatus, String adrName) {
		super();
		this.pNum = pNum;
		this.pId = pId;
		this.mId = mId;
		this.totalPrice = totalPrice;
		this.aZipcode = aZipcode;
		this.aMain = aMain;
		this.aSub = aSub;
		this.pDeliverymemo = pDeliverymemo;
		this.pDate = pDate;
		this.pStatus = pStatus;
		this.adrName = adrName;
	}

	public int getpNum() {
		return pNum;
	}
	public void setpNum(int pNum) {
		this.pNum = pNum;
	}
	public String getpId() {
		return pId;
	}
	public void setpId(String pId) {
		this.pId = pId;
	}
	public String getmId() {
		return mId;
	}
	public void setmId(String mId) {
		this.mId = mId;
	}
	public String getTotalPrice() {
		return totalPrice;
	}
	public void setTotalPrice(String totalPrice) {
		this.totalPrice = totalPrice;
	}
	public int getaZipcode() {
		return aZipcode;
	}
	public void setaZipcode(int aZipcode) {
		this.aZipcode = aZipcode;
	}
	public String getaMain() {
		return aMain;
	}
	public void setaMain(String aMain) {
		this.aMain = aMain;
	}
	public String getaSub() {
		return aSub;
	}
	public void setaSub(String aSub) {
		this.aSub = aSub;
	}
	public String getpDeliverymemo() {
		return pDeliverymemo;
	}
	public void setpDeliverymemo(String pDeliverymemo) {
		this.pDeliverymemo = pDeliverymemo;
	}
	public Timestamp getpDate() {
		return pDate;
	}
	public void setpDate(Timestamp pDate) {
		this.pDate = pDate;
	}
	public int getpStatus() {
		return pStatus;
	}
	public void setpStatus(int pStatus) {
		this.pStatus = pStatus;
	}
	public String getAdrName() {
		return adrName;
	}
	public void setAdrName(String adrName) {
		this.adrName = adrName;
	}

}
