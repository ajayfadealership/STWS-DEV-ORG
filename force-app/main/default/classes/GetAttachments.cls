@RestResource(urlMapping = '/Attachment')
global class GetAttachments {
    @HttpGet
    global static String doGet() {
        String strAttachmentId = RestContext.request.params.get('attId');
        if(String.isNotBlank(strAttachmentId)) {
            List<Attachment> lstAttachment = [SELECT 
                                                        Id,
                                                        Name,
                                                        Body
                                                FROM
                                                        Attachment
                                                WHERE
                                                        Id =:strAttachmentId];
            if(lstAttachment.size() > 0) {
                return 'data:image/jpg'+';base64,'+EncodingUtil.base64Encode(lstAttachment[0].Body);
            }
        }
        return 'No Image Found';
    }
}