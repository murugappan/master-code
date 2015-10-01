public with sharing class CPQCustomerTierMgr {
	static private Map<String, Integer> TIERS_BY_COUNTRY = new Map<String, Integer> {
		'algeria' => 4,
		'antigua and barbuda' => 3,
		'argentina' => 3,
		'australia' => 1,
		'austria' => 1,
		'bahamas' => 3,
		'bahrain' => 3,
		'barbados' => 3,
		'belarus' => 4,
		'belgium' => 1,
		'bermuda' => 3,
		'bolivia' => 3,
		'botswana' => 4,
		'brazil' => 3,
		'bulgaria' => 4,
		'chile' => 3,
		'china' => 2,
		'columbia' => 3,
		'costa rica' => 3,
		'croatia' => 4,
		'cyprus' => 4,
		'czech republic' => 4,
		'denmark' => 1,
		'dominican republic' => 3,
		'ecuador' => 3,
		'egypt' => 4,
		'estonia' => 4,
		'fiji' => 4,
		'finland' => 1,
		'france' => 1,
		'georgia' => 4,
		'germany' => 1,
		'greece' => 4,
		'honduras' => 3,
		'hong kong' => 1,
		'hungary' => 4,
		'iceland' => 1,
		'india' => 4,
		'indonesia' => 4,
		'ireland' => 1,
		'israel' => 4,
		'italy' => 2,
		'japan' => 1,
		'jordan' => 4,
		'kenya' => 4,
		'kuwait' => 1,
		'latvia' => 4,
		'lebanon' => 3,
		'libya' => 4,
		'lithuania' => 4,
		'luxemborg' => 1,
		'macau' => 1,
		'malaysia' => 4,
		'malta' => 4,
		'mexico' => 3,
		'morocco' => 4,
		'neth. antilles' => 3,
		'netherlands' => 1,
		'new zealand' => 1,
		'nigeria' => 4,
		'norway' => 1,
		'oman' => 3,
		'pakistan' => 4,
		'panama' => 3,
		'peru' => 3,
		'philippines' => 4,
		'poland' => 3,
		'portugal' => 3,
		'puerto rico' => 3,
		'qatar' => 1,
		'romania' => 4,
		'russia' => 3,
		'saudi arabia' => 2,
		'singapore' => 1,
		'slovenia' => 4,
		'south africa' => 2,
		'south korea' => 2,
		'spain' => 3,
		'sri lanka' => 4,
		'sweden' => 1,
		'switzerland' => 1,
		'taiwan' => 4,
		'tanzania' => 4,
		'thailand' => 4,
		'trinidad and tobago' => 3,
		'tunisia' => 4,
		'turkey' => 4,
		'uganda' => 4,
		'united arab emirates' => 2,
		'united kingdom' => 1,
		'uruguay' => 3,
		'us virgin islands' => 1,
		'venezuela' => 3,
		'vietnam' => 4
	};
	
	/*
	 * Retrieves the customer tier corresponding to the given country string.
	 */
	public static Integer getCustomerTier(String country) {
		Integer tier = TIERS_BY_COUNTRY.get(country != null ? country.toLowerCase() : '');
		if (tier == null) {
			tier = 1;
		}
		return tier;
	}
	
	///////////////////////////////////////////////
	//////////////// UNIT TESTING
	///////////////////////////////////////////////
	
	public static testmethod void getKnownCountryCustomerTierTest() {
		System.assertEquals(4, getCustomerTier('vietnam'));
	}
	
	public static testmethod void getUnknownCountryCustomerTierTest() {
		System.assertEquals(1, getCustomerTier('palestine'));
	}
}