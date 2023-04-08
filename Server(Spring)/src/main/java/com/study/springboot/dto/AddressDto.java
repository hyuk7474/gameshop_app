package com.study.springboot.dto;


public class AddressDto
{
	String mId;
	String adrName;
	String aName;
	String aZipcode;
	String aMain;
	String aSub;
	String aPrimary;
	
	public AddressDto() {}

	public AddressDto(String mId, String adrName, String aName, String aZipcode, String aMain, String aSub,
			String aPrimary) {
		super();
		this.mId = mId;
		this.adrName = adrName;
		this.aName = aName;
		this.aZipcode = aZipcode;
		this.aMain = aMain;
		this.aSub = aSub;
		this.aPrimary = aPrimary;
	}

	public String getmId()
	{
		return mId;
	}
	public void setmId(String mId)
	{
		this.mId = mId;
	}
	public String getaName()
	{
		return aName;
	}
	public void setaName(String aName)
	{
		this.aName = aName;
	}
	public String getaZipcode()
	{
		return aZipcode;
	}
	public void setaZipcode(String aZipcode)
	{
		this.aZipcode = aZipcode;
	}
	public String getaMain()
	{
		return aMain;
	}
	public void setaMain(String aMain)
	{
		this.aMain = aMain;
	}
	public String getaSub()
	{
		return aSub;
	}
	public void setaSub(String aSub)
	{
		this.aSub = aSub;
	}
	public String getaPrimary()
	{
		return aPrimary;
	}
	public void setaPrimary(String aPrimary)
	{
		this.aPrimary = aPrimary;
	}
	public String getAdrName() {
		return adrName;
	}
	public void setAdrName(String adrName) {
		this.adrName = adrName;
	}
	
}
