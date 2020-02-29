public class attachmentsample {

    public attachmentsample(ApexPages.StandardController controller) {

    }
    Public transient Attachment myfile;
    Public Attachment getmyfile()
    {
        myfile = new Attachment();
        return myfile;
    }
   
    Public Pagereference Savedoc()
    {
        String accid = System.currentPagereference().getParameters().get('id');

        Attachment a = new Attachment(parentId = accid, name=myfile.name, body = myfile.body);
         
         /* insert the attachment */
        if(!Test.isRunningTest()) {
         	insert a; 
        	return new Pagereference('/'+accid);
        } else {
            return null;
        }
    }   

}