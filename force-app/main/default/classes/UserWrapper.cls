global class UserWrapper implements Comparable {
    
    public User objuser;
    
    // Constructor
    public UserWrapper(User objuser1) {
        objuser = objuser1;
    }
    
    // Compare opportunities based on the opportunity amount.
    global Integer compareTo(Object compareTo) {
        // Cast argument to UserWrapper
        UserWrapper compareToUser = (UserWrapper)compareTo;
        
        // The return value of 0 indicates that both elements are equal.
        Integer returnValue = 0;
        if (objuser.BOATBUILDING__Assigned_Lead_Count__c > compareToUser.objuser.BOATBUILDING__Assigned_Lead_Count__c) {
            // Set return value to a positive value.
            returnValue = 1;
        } else if (objuser.BOATBUILDING__Assigned_Lead_Count__c < compareToUser.objuser.BOATBUILDING__Assigned_Lead_Count__c) {
            // Set return value to a negative value.
            returnValue = -1;
        }
        
        return returnValue;       
    }
}