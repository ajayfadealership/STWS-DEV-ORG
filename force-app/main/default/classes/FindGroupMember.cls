public class FindGroupMember {

    //static map
    public static Map<Id, List<Id>> mapGroupToUserId = new Map<Id, List<Id>>();
    public FindGroupMember(){
        
        // Entering values in Static Map -- Start
        List<GroupMember> listGM = [SELECT GroupId, UserOrGroupId FROM GroupMember];
        
        for(GroupMember objGM: listGM){
            if(mapGroupToUserId.containsKey(objGM.groupId)){
                List<Id> listGroupId = mapGroupToUserId.get(objGM.groupId);
                listGroupId.add(objGM.groupId);
                mapGroupToUserId.put(objGM.GroupId, listGroupId);
            } else {
                mapGroupToUserId.put(objGM.GroupId, new List<Id> {objGM.UserOrGroupId});
            }
        }
        // Entering values in Static Map -- End
    }
    
    // method to check user in group
    public Boolean isGroupMemberUser(String userId, String groupId){
        
        if(mapGroupToUserId.containsKey(groupId)){
            for(Id uID: mapGroupToUserId.get(GroupId)){
                if(uID == userId){
                    return true;
                } else if(String.valueOf(uId).StartsWith('00G')){
                    return isGroupMemberUser(userId, uId);
                }
            }
        }
        
        return false;
    }
}