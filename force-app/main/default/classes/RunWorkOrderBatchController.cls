public with sharing class RunWorkOrderBatchController {


public String batchResult{get;set;}

public RunWorkOrderBatchController(){

    batchResult = 'The batch has been started and it will flow work order into QB';
    }
    
    
    public pagereference runBatch(){
    
    BatchSendWoToQb objBatchSendWoToQb = new BatchSendWoToQb();
    dataBase.executeBatch(objBatchSendWoToQb,1);
    batchResult = 'Work order has been flown into  QB.Please verify.';
    return null;
    }
}