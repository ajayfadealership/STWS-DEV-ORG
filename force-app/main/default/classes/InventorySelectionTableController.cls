public with sharing class InventorySelectionTableController {
	
	@AuraEnabled
	public static List<PriceAndProductOptionWraperClass> getProductPriceApex(String invId) {
		
		List<BOATBUILDING__Inventory_Line_Item__c> lstILI = [Select 
									                                 Id, 
									                                 IsDeleted, 
									                                 Name, 
									                                 Name__c,
									                                 Related_to_Inventory__c, 
									                                 Item_Description__c, 
									                                 Discount__c,
									                                 Dealer_Price__c, 
									                                 Option_Category__c,
									                                 Price__c, 
									                                 Product_Code__c, 
									                                 Quantity__c  
							                                 From   
									                                 BOATBUILDING__Inventory_Line_Item__c Where BOATBUILDING__Related_to_Inventory__c =: invId];
		
		Set<String> selectedOptionsforInventory = new Set<String>();
		Set<String> setProductCode = new Set<String>();
        if(lstILI.size() > 0){
            for(BOATBUILDING__Inventory_Line_Item__c objInventoryLineItem : lstILI)
            {
                selectedOptionsforInventory.add(objInventoryLineItem.Name__c);
                if(objInventoryLineItem.Product_Code__c != null){
                    setProductCode.add(objInventoryLineItem.Product_Code__c);
                }
            }
            
            
        }
		
		
		List<PriceAndProductOptionWraperClass> lstPriceAndProductOptionWraperClass = new List<PriceAndProductOptionWraperClass>();
		String SelectedType = '', selectedManu = '', selectedYear = '', selectedModel = '', selectedModelVariant = '', MVStatus = '0';
		
		Inventory__c objInventory = [Select i.Transmission_Gearbox_SN__c, i.Year__c, i.Trailer_VIN__c,
                             				i.Stage__c, i.Total_Dealer_Price__c, i.Hull_ID__c, i.Name, i.Model__c, 
                             				i.Model_Variant__c, i.Manufacturer__c, i.Id, i.Cost__c, i.Suggested_List_Price__c, 
                             				i.RecordType.Name
                         			From 
                             				BOATBUILDING__Inventory__c i 
                             		where 
                             				Id=: invId];
		List<Manufacturer__c> lstManu = [Select Id,Name, Model_Variant__c from BOATBUILDING__Manufacturer__c where Name =: objInventory.Manufacturer__c limit 1];
		
		if(!lstManu.isEmpty()) {
			Manufacturer__c objManu = lstManu[0];
			if(objManu.Model_Variant__c) {
				MVStatus = '1';
			}
			
			Map<String , List<BOATBUILDING__ProductPrice__c>> mapSelectedCategory = new Map<String , List<BOATBUILDING__ProductPrice__c>>();
			Map<String , List<CheckBoxWraper>> mapCheckBoxWraper = new Map<String , List<CheckBoxWraper>>();
		
			System.debug('>>: '+SelectedType);
			  
			selectedManu = objManu.Id;
			
			if(objInventory.RecordType.Name != null && objInventory.RecordType.Name == 'New Boats') {
	            	SelectedType = 'New Boat'; 
	        } else if(objInventory.RecordType.Name != null && objInventory.RecordType.Name == 'Used Boats') {
        			SelectedType = 'Used Boat';
	        } else {
	        		SelectedType = objInventory.RecordType.Name; 
	        }
			
			if(objInventory.Model__c != null){
                selectedModel = objInventory.Model__c;
            }
            if(objInventory.Model_Variant__c != null){
                selectedModelVariant = objInventory.Model_Variant__c;
            }
            if(objInventory.Year__c != null){
                selectedYear = objInventory.Year__c;
            }
			List<Product__c> lstPro;
			if(objManu.Model_Variant__c) {
				lstPro = [Select Id From Product__c Where Product_Manufacturer__c =: objManu.Id AND  MModel2__c =: selectedModel AND M_Model_Variant__c=: selectedModelVariant AND M_Year__c =: selectedYear AND Product_Type__c =: SelectedType limit 1];
			} else {
				lstPro = [Select Id From Product__c where Product_Manufacturer__c =: objManu.Id AND MModel2__c =: selectedModel AND M_Year__c =: selectedYear AND Product_Type__c =: SelectedType limit 1];
			}
			
			
			System.debug('>>:lstPro: '+lstPro);
			if(!lstPro.isEmpty()) {
				Product__c objProduct = lstPro[0];
				
				if(MVStatus == '1') {
					selectedModelVariant = objProduct.Id;
					mapSelectedCategory = OptionAndSelectedCatagoryUtil.getInstance(selectedModelVariant, selectedManu, selectedYear, objInventory.RecordType.Name).getSelectedCatagory();
					if(objInventory.RecordType.Name == 'New Boats') {
						Map<String , List<BOATBUILDING__ProductPrice__c>> mapSelectedCategory2 = OptionAndSelectedCatagoryUtil.getInstance(selectedModelVariant, selectedManu, selectedYear, 'Trailer').getSelectedCatagory();
						mapSelectedCategory.putAll(mapSelectedCategory2);
					}
					System.debug('mapSelectedCategory: '+mapSelectedCategory);
				} else {
					selectedModel = objProduct.Id;
					mapSelectedCategory = OptionAndSelectedCatagoryUtil.getInstance(selectedModel, selectedManu, selectedYear, objInventory.RecordType.Name).getSelectedCatagory();
					System.debug('mapSelectedCategory: '+mapSelectedCategory);
					if(objInventory.RecordType.Name == 'New Boats') {
						Map<String , List<BOATBUILDING__ProductPrice__c>> mapSelectedCategory2 = OptionAndSelectedCatagoryUtil.getInstance(selectedModel, selectedManu, selectedYear, 'Trailer').getSelectedCatagory();
						mapSelectedCategory.putAll(mapSelectedCategory2);
					}
				}
				 
				List<CheckBoxWraper> lstCheckBoxWraper;
		        
		        for(String strMapValues : mapSelectedCategory.keySet()){
		            lstCheckBoxWraper = new List<CheckBoxWraper>();
		            for(BOATBUILDING__ProductPrice__c objProductPriceForSelectedCategory : mapSelectedCategory.get(strMapValues)){
		            		if(MVStatus == '1') {
	                        if(selectedOptionsforInventory.contains(String.valueOf(objProductPriceForSelectedCategory.ProductSelected_Category__c))  
	                           	&& objInventory.Manufacturer__c == objProductPriceForSelectedCategory.ProductManufacturer__c
	                           		&& objInventory.Year__c == objProductPriceForSelectedCategory.Year__c
	                           			&& objInventory.Model__c == objProductPriceForSelectedCategory.Product_Model__c
	                           				&& objInventory.Model_Variant__c == objProductPriceForSelectedCategory.Model_Variant__c
	                           					&& setProductCode.contains(String.ValueOf(objProductPriceForSelectedCategory.Product_Code__c))) {
	                           						
	                               lstCheckBoxWraper.add(new CheckBoxWraper(true, lstCheckBoxWraper.size()+1, objProductPriceForSelectedCategory));
	                           }else{
	                               lstCheckBoxWraper.add(new CheckBoxWraper(false, lstCheckBoxWraper.size()+1, objProductPriceForSelectedCategory));
	                           }
	                    } else {
                            if(selectedOptionsforInventory.contains(String.valueOf(objProductPriceForSelectedCategory.ProductSelected_Category__c))  
                               && String.valueOf(objInventory.Manufacturer__c).containsIgnoreCase(objProductPriceForSelectedCategory.ProductManufacturer__c)
                               && String.valueOf(objInventory.Year__c).containsIgnoreCase(objProductPriceForSelectedCategory.Year__c)
                               && String.valueOf(objInventory.Model__c).containsIgnoreCase(objProductPriceForSelectedCategory.Product_Model__c)
                               && setProductCode.contains(String.ValueOf(objProductPriceForSelectedCategory.Product_Code__c))){
                                   lstCheckBoxWraper.add(new CheckBoxWraper(true, lstCheckBoxWraper.size()+1, objProductPriceForSelectedCategory));
                               }else{ 
                                   lstCheckBoxWraper.add(new CheckBoxWraper(false, lstCheckBoxWraper.size()+1, objProductPriceForSelectedCategory));
                               }
                        }
		                
		            }
		            mapCheckBoxWraper.put(strMapValues, lstCheckBoxWraper);
		        }
		        
		        
		        
				for(String strUtil : mapSelectedCategory.keySet()){
		            lstPriceAndProductOptionWraperClass.add(new PriceAndProductOptionWraperClass(strUtil, mapCheckBoxWraper.get(strUtil)));
		        }
			}
		} 
        return lstPriceAndProductOptionWraperClass;
	}
	
	
	@AuraEnabled 
	public static List<DealerOptionWraper> getDealerPriceApex1(String invId) {
		
		List<BOATBUILDING__Inventory_Line_Item__c> lstILI = [Select 
									                                 Id, 
									                                 IsDeleted, 
									                                 Name, 
									                                 Name__c,
									                                 Related_to_Inventory__c, 
									                                 Item_Description__c, 
									                                 Discount__c,
									                                 Dealer_Price__c, 
									                                 Option_Category__c,
									                                 Price__c, 
									                                 Product_Code__c, 
									                                 Quantity__c,
									                                 Non_Taxable__c  
									                                 From   
									                                 BOATBUILDING__Inventory_Line_Item__c Where BOATBUILDING__Related_to_Inventory__c =: invId];
									                                 
		Map<String, BOATBUILDING__Inventory_Line_Item__c> mapILI= new Map<String, BOATBUILDING__Inventory_Line_Item__c>();
        if(lstILI.size() > 0){
            for(BOATBUILDING__Inventory_Line_Item__c objInventoryLineItem : lstILI) {
                if(objInventoryLineItem.Product_Code__c != null){
                    mapILI.put(objInventoryLineItem.Product_Code__c, objInventoryLineItem);     
                }
            }
        }
		
		List<DealerOptionWraper> lstDealerOptionWraper = new List<DealerOptionWraper>();
		
		List<BOATBUILDING__Dealer_Option__c> lstDealerOption = [SELECT 
						                                                  Id,
						                                                  Name,
						                                                  Part_Number__c,
						                                                  Retail_Price__c,
						                                                  Cost__c,
						                                                  Non_Taxable__c
				                                                  FROM
					                                                  BOATBUILDING__Dealer_Option__c];
        
        String UserId = UserInfo.getUserId();
        Set<String> ProductCodeForNonExist = new Set<String>();
        if(lstDealerOption.size() > 0){
        		
            for(BOATBUILDING__Dealer_Option__c objDealerOption : lstDealerOption){
            		ProductCodeForNonExist.add(objDealerOption.Part_Number__c); 
	            //	if((objDealerOption.BOATBUILDING__Temp_User_Id__c != null && objDealerOption.BOATBUILDING__Temp_User_Id__c == UserId) && objDealerOption.BOATBUILDING__Is_Temp__c == true) {
	            		//lstDealerOptionWraper.add(new DealerOptionWraper(true, objDealerOption, true));
	            	//}else if(objDealerOption.BOATBUILDING__Is_Temp__c == false) {
	            		
	            		if(mapILI.keySet().contains(objDealerOption.Part_Number__c)) {
	            			objDealerOption.Non_Taxable__c = mapILI.get(objDealerOption.Part_Number__c).Non_Taxable__c;
                        lstDealerOptionWraper.add(new DealerOptionWraper(true, objDealerOption, false)); 
                    }else{
                        lstDealerOptionWraper.add(new DealerOptionWraper(false, objDealerOption, false));
                    }
	            		
	            		
	                
            		//}
            }
			List<BOATBUILDING__Dealer_Option__c> lstDealerOption2 = new List<BOATBUILDING__Dealer_Option__c>();
            if(lstILI.size() > 0){
	            for(BOATBUILDING__Inventory_Line_Item__c objInventoryLineItem : lstILI) {
	                if(!ProductCodeForNonExist.contains(objInventoryLineItem.Product_Code__c) && objInventoryLineItem.Option_Category__c == 'Dealer Options'){
	                    BOATBUILDING__Dealer_Option__c objDO = new BOATBUILDING__Dealer_Option__c();
	                    objDO.Name = objInventoryLineItem.Name__c;
	                    objDO.Part_Number__c = objInventoryLineItem.Product_Code__c;
	                    objDO.Retail_Price__c = objInventoryLineItem.Price__c;
	                    objDO.Cost__c = objInventoryLineItem.Dealer_Price__c;
	                    objDO.Non_Taxable__c = objInventoryLineItem.Non_Taxable__c;
	                    lstDealerOptionWraper.add(new DealerOptionWraper(true, objDO, true));
	                }
	            }
	            
	        }
        }  else if(lstILI.size() > 0){
	            for(BOATBUILDING__Inventory_Line_Item__c objInventoryLineItem : lstILI) {
	                if(!ProductCodeForNonExist.contains(objInventoryLineItem.Product_Code__c) && objInventoryLineItem.Option_Category__c == 'Dealer Options'){
	                    BOATBUILDING__Dealer_Option__c objDO = new BOATBUILDING__Dealer_Option__c();
	                    objDO.Name = objInventoryLineItem.Name__c;
	                    objDO.Part_Number__c = objInventoryLineItem.Product_Code__c;
	                    objDO.Retail_Price__c = objInventoryLineItem.Price__c;
	                    objDO.Cost__c = objInventoryLineItem.Dealer_Price__c;
	                    objDO.Non_Taxable__c = objInventoryLineItem.Non_Taxable__c; 
	                    lstDealerOptionWraper.add(new DealerOptionWraper(true, objDO, true));
	                }
	            }
	            
	        }
         
        return lstDealerOptionWraper;
	}
	
	@AuraEnabled
	public static List<DealerOptionWraper> getDealerPriceApex() {
		
		
		
		List<DealerOptionWraper> lstDealerOptionWraper = new List<DealerOptionWraper>();
		 
		List<BOATBUILDING__Dealer_Option__c> lstDealerOption = [SELECT 
					                                                  Id,
					                                                  Name,
					                                                  Part_Number__c,
					                                                  Retail_Price__c,
					                                                  Cost__c,
					                                                  Non_Taxable__c
					                                                  FROM
					                                                  BOATBUILDING__Dealer_Option__c];
        
        String UserId = UserInfo.getUserId();
        if(lstDealerOption.size() > 0){
            for(BOATBUILDING__Dealer_Option__c objDealerOption : lstDealerOption){
                lstDealerOptionWraper.add(new DealerOptionWraper(false, objDealerOption, false));
            }
        } 
         
        return lstDealerOptionWraper;
	}
	
	@AuraEnabled
	public static Product__c getProdutPriceingApexMD(String invId) {
		Product__c objProduct = new Product__c();
		objProduct.M_Boat_MSRP_PRICE__c = 0.00;
		objProduct.Cost_Price__c = 0.00;
		String SelectedType = '', selectedManu = '', selectedYear = '', selectedModel = '', selectedModelVariant = '', MVStatus = '0';
		
		Inventory__c objInventory = [Select i.Transmission_Gearbox_SN__c, i.Year__c, i.Trailer_VIN__c,
                             				i.Stage__c, i.Total_Dealer_Price__c, i.Hull_ID__c, i.Name, i.Model__c, 
                             				i.Model_Variant__c, i.Manufacturer__c, i.Id, i.Cost__c, i.Suggested_List_Price__c, 
                             				i.RecordType.Name
                         			From 
                             				BOATBUILDING__Inventory__c i 
                             		where 
                             				Id=: invId];
		List<Manufacturer__c> lstManu = [Select Id,Name, Model_Variant__c from BOATBUILDING__Manufacturer__c where Name =: objInventory.Manufacturer__c limit 1];
		
		if(!lstManu.isEmpty()) {
			Manufacturer__c objManu = lstManu[0];
			if(objManu.Model_Variant__c) {
				MVStatus = '1';
			}
			
			Map<String , List<BOATBUILDING__ProductPrice__c>> mapSelectedCategory = new Map<String , List<BOATBUILDING__ProductPrice__c>>();
			Map<String , List<CheckBoxWraper>> mapCheckBoxWraper = new Map<String , List<CheckBoxWraper>>();
		
			System.debug('>>: '+SelectedType);
			  
			selectedManu = objManu.Id;
			
			if(objInventory.RecordType.Name != null && objInventory.RecordType.Name == 'New Boats') {
	            	SelectedType = 'New Boat'; 
	        } else if(objInventory.RecordType.Name != null && objInventory.RecordType.Name == 'Used Boats') {
        			SelectedType = 'Used Boat';
	        } else {
	        		SelectedType = objInventory.RecordType.Name; 
	        }
			
			if(objInventory.Model__c != null){
                selectedModel = objInventory.Model__c;
            }
            if(objInventory.Model_Variant__c != null){
                selectedModelVariant = objInventory.Model_Variant__c;
            }
            if(objInventory.Year__c != null){
                selectedYear = objInventory.Year__c;
            }
			List<Product__c> lstPro;
			if(objManu.Model_Variant__c) {
				lstPro = [Select Id, M_Boat_MSRP_PRICE__c, Cost_Price__c From Product__c Where Product_Manufacturer__c =: objManu.Id AND  MModel2__c =: selectedModel AND M_Model_Variant__c=: selectedModelVariant AND M_Year__c =: selectedYear AND Product_Type__c =: SelectedType limit 1];
			} else {
				lstPro = [Select Id, M_Boat_MSRP_PRICE__c, Cost_Price__c From Product__c where Product_Manufacturer__c =: objManu.Id AND MModel2__c =: selectedModel AND M_Year__c =: selectedYear AND Product_Type__c =: SelectedType limit 1];
			}
			
			
			System.debug('>>:lstPro: '+lstPro);
			if(!lstPro.isEmpty()) {
				objProduct = lstPro[0];
				
			}
		} 
        return objProduct;
	}   
}