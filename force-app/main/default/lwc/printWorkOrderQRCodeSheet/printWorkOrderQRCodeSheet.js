import { LightningElement , track , api} from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
export default class PrintWorkOrderQRCodeSheet extends NavigationMixin(LightningElement) {
		
		 @api recordId;
		 @api objectApiName;

    retrievedRecordId = false;
		qr1 = false;qr2 = false;
		qr3 = false;qr4 = false;
		qr5 = false;qr6 = false;
		qr7 = false;qr8 = false;
		qr9 = false;qr10 = false;
		qr11 = false;qr12 = false;
		qr13 = false;qr14 = false;
		qr15 = false;qr16 = false;
		qr17 = false;qr18 = false;
		qr19 = false;qr20 = false;
		qr21 = false;qr22 = false;
		qr23 = false;qr24 = false;
		qr25 = false;qr26 = false;
		qr27 = false;qr28 = false;
		qr29 = false;qr30 = false;
		qr31 = false;qr32 = false;
		
    renderedCallback() {
        if (!this.retrievedRecordId && this.recordId) {
            this.retrievedRecordId = true; 
            console.log('Found recordId: ' + this.recordId);
			console.log('Found objectAPINAme: ' + this.objectApiName);
        }
    }
		handleQRChange1(event){
				console.log('>>>'+event.target.checked);
				this.qr1 = event.target.checked;
		}
		handleQRChange2(event){
				console.log('>>>'+event.target.checked);
				this.qr2 = event.target.checked;
		}
		handleQRChange3(event){
				console.log('>>>'+event.target.checked);
				this.qr3 = event.target.checked;
		}
		handleQRChange4(event){
				console.log('>>>'+event.target.checked);
				this.qr4 = event.target.checked;
		}
		handleQRChange5(event){
				console.log('>>>'+event.target.checked);
				this.qr5 = event.target.checked;
		}
		handleQRChange6(event){
				console.log('>>>'+event.target.checked);
				this.qr6 = event.target.checked;
		}
		handleQRChange7(event){
				console.log('>>>'+event.target.checked);
				this.qr7 = event.target.checked;
		}
		handleQRChange8(event){
				console.log('>>>'+event.target.checked);
				this.qr8 = event.target.checked;
		}
		handleQRChange9(event){
				console.log('>>>'+event.target.checked);
				this.qr9 = event.target.checked;
		}
		handleQRChange10(event){
				console.log('>>>'+event.target.checked);
				this.qr10 = event.target.checked;
		}
		handleQRChange11(event){
				console.log('>>>'+event.target.checked);
				this.qr11 = event.target.checked;
		}
		handleQRChange12(event){
				console.log('>>>'+event.target.checked);
				this.qr12 = event.target.checked;
		}
		handleQRChange13(event){
				console.log('>>>'+event.target.checked);
				this.qr13 = event.target.checked;
		}
		handleQRChange14(event){
				console.log('>>>'+event.target.checked);
				this.qr14 = event.target.checked;
		}
		handleQRChange15(event){
				console.log('>>>'+event.target.checked);
				this.qr15 = event.target.checked;
		}
		handleQRChange16(event){
				console.log('>>>'+event.target.checked);
				this.qr16 = event.target.checked;
		}
		handleQRChange17(event){
				console.log('>>>'+event.target.checked);
				this.qr17 = event.target.checked;
		}
		handleQRChange18(event){
				console.log('>>>'+event.target.checked);
				this.qr18 = event.target.checked;
		}
		handleQRChange19(event){
				console.log('>>>'+event.target.checked);
				this.qr19 = event.target.checked;
		}
		handleQRChange20(event){
				console.log('>>>'+event.target.checked);
				this.qr20 = event.target.checked;
		}
		handleQRChange21(event){
				console.log('>>>'+event.target.checked);
				this.qr21 = event.target.checked;
		}
		handleQRChange22(event){
				console.log('>>>'+event.target.checked);
				this.qr22 = event.target.checked;
		}
		handleQRChange23(event){
				console.log('>>>'+event.target.checked);
				this.qr23 = event.target.checked;
		}
		handleQRChange24(event){
				console.log('>>>'+event.target.checked);
				this.qr24 = event.target.checked;
		}
		handleQRChange25(event){
				console.log('>>>'+event.target.checked);
				this.qr25 = event.target.checked;
		}
		handleQRChange26(event){
				console.log('>>>'+event.target.checked);
				this.qr26 = event.target.checked;
		}
		handleQRChange27(event){
				console.log('>>>'+event.target.checked);
				this.qr27 = event.target.checked;
		}
		handleQRChange28(event){
				console.log('>>>'+event.target.checked);
				this.qr28 = event.target.checked;
		}
		handleQRChange29(event){
				console.log('>>>'+event.target.checked);
				this.qr29 = event.target.checked;
		}
		handleQRChange30(event){
				console.log('>>>'+event.target.checked);
				this.qr30 = event.target.checked;
		}
		handleQRChange31(event){
				console.log('>>>'+event.target.checked);
				this.qr31 = event.target.checked;
		}
		handleQRChange32(event){
				console.log('>>>'+event.target.checked);
				this.qr32 = event.target.checked;
		}
		handleNext(event){
				if(this.objectApiName == 'BOATBUILDING__Work_Order__c'){
					this[NavigationMixin.GenerateUrl]({
								type: 'standard__webPage',
								attributes: {
										url: '/apex/PrintWorkOrderQRSheet?id=' + this.recordId+'&qr1='+this.qr1+'&qr2='+this.qr2+'&qr3='+this.qr3+'&qr4='+this.qr4
										+'&qr5='+this.qr5+'&qr6='+this.qr6+'&qr7='+this.qr7+'&qr8='+this.qr8+'&qr9='+this.qr9+'&qr10='+this.qr10+'&qr11='
										+this.qr11+'&qr12='+this.qr12+'&qr13='+this.qr13+'&qr14='+this.qr14+'&qr15='+this.qr15+'&qr16='+this.qr16
										+'&qr17='+this.qr17+'&qr18='+this.qr18+'&qr19='+this.qr19+'&qr20='+this.qr20+'&qr21='+this.qr21+'&qr22='+this.qr22
										+'&qr23='+this.qr23+'&qr24='+this.qr24+'&qr25='+this.qr25+'&qr26='+this.qr26
										+'&qr27='+this.qr27+'&qr28='+this.qr28+'&qr29='+this.qr29+'&qr30='+this.qr30+'&qr31='+this.qr31+'&qr32='+this.qr32
								}
						}).then(generatedUrl => {
								window.open(generatedUrl);
						});
				}else if(this.objectApiName == 'BOATBUILDING__Item__c'){
						this[NavigationMixin.GenerateUrl]({
								type: 'standard__webPage',
								attributes: {
										url: '/apex/PrintItemQRSheet?id=' + this.recordId+'&qr1='+this.qr1+'&qr2='+this.qr2+'&qr3='+this.qr3+'&qr4='+this.qr4
										+'&qr5='+this.qr5+'&qr6='+this.qr6+'&qr7='+this.qr7+'&qr8='+this.qr8+'&qr9='+this.qr9+'&qr10='+this.qr10+'&qr11='
										+this.qr11+'&qr12='+this.qr12+'&qr13='+this.qr13+'&qr14='+this.qr14+'&qr15='+this.qr15+'&qr16='+this.qr16
										+'&qr17='+this.qr17+'&qr18='+this.qr18+'&qr19='+this.qr19+'&qr20='+this.qr20+'&qr21='+this.qr21+'&qr22='+this.qr22
										+'&qr23='+this.qr23+'&qr24='+this.qr24+'&qr25='+this.qr25+'&qr26='+this.qr26
										+'&qr27='+this.qr27+'&qr28='+this.qr28+'&qr29='+this.qr29+'&qr30='+this.qr30+'&qr31='+this.qr31+'&qr32='+this.qr32
								}
						}).then(generatedUrl => {
								window.open(generatedUrl);
						});
				}
				
		}
		handleCancel(event){
			const closeQA = new CustomEvent('close');
		this.dispatchEvent(closeQA);
		}
		
}